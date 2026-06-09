function calib = calibrate_forest_scene_params()
%CALIBRATE_FOREST_SCENE_PARAMS
% Derive forest-scene calibration parameters from packaged datasets and
% explicit literature-inspired mappings.

base_dir = fileparts(mfilename('fullpath'));
repo_dir = fileparts(base_dir);
cache_path = fullfile(base_dir, 'forest_scene_calibration_cache.mat');
force_recompute = strcmpi(getenv('FOREST_CALIBRATION_FORCE_RECOMPUTE'), '1');

if ~force_recompute && isfile(cache_path)
    cached = load(cache_path, 'calib');
    if isfield(cached, 'calib')
        calib = cached.calib;
        disp(struct2table(local_flatten_calib(calib)));
        return;
    end
end

roads_shp = fullfile(repo_dir, 'external_data', 'Forest_Roads_USFS', 'S_USA.RoadCore_FS.shp');
tif_file = fullfile(repo_dir, 'external_data', 'ForestPaths', 'merged_pred_q050_ulx_5900_uly_1640.tif');
pcd_file = fullfile(repo_dir, 'external_data', 'Below_Canopy_Forestry', ...
    'Below_canopy_pointcloud_2024-11-15-08-45-11.pcd');

required_files = {roads_shp, tif_file, pcd_file};
for i = 1:numel(required_files)
    if ~isfile(required_files{i})
        error('Calibration resource missing: %s', required_files{i});
    end
end

road_stats = local_extract_road_stats(roads_shp);
veg_stats = local_extract_vegetation_stats(tif_file);
pcd_stats = local_extract_pointcloud_stats(pcd_file);

calib = struct();
calib.road_stats = road_stats;
calib.vegetation_stats = veg_stats;
calib.pointcloud_stats = pcd_stats;

% Link-distance scaling from real road geometry
calib.link_distance_scale = min(max(road_stats.segment_length_p75_m / 60.0, 0.9), 1.8);

% Literature-guided pathloss exponent mapping:
% use exponent in dB/decade form consistent with current simulator
% alpha_linear in [2.1, 2.9] -> exponent_db = 10 * alpha_linear.
alpha_los_linear = min(max(2.1 + 0.45 * road_stats.curvature_norm + 0.30 * veg_stats.cover_density_norm, 2.1), 2.9);
alpha_nlos_linear = min(max(alpha_los_linear + 0.35 + 0.55 * veg_stats.cover_density_norm, 2.6), 3.8);
calib.pathloss_los_exponent = 10.0 * alpha_los_linear;
calib.pathloss_nlos_exponent = 10.0 * alpha_nlos_linear;

calib.pathloss_los_offset_dB = 46.5 + 1.8 * veg_stats.cover_density_norm;
calib.pathloss_nlos_offset_dB = calib.pathloss_los_offset_dB + 3.0 + 1.6 * veg_stats.cover_density_norm;

% Vegetation attenuation and blockage severity.
% Re-anchored so the affine ENDPOINTS hit the TR 37.885 sec.6.2.1 NLOSv blockage
% means: attenuation_norm=0 -> mu=5 dB (single blocker), =1 -> mu=9 dB (high
% blockage). (Was 3.5+3.5*norm spanning 3.5..7, which hit neither standard
% anchor.) NOTE: changes forest-geometry calibrated scenarios -> re-run those.
calib.nlosv_extra_loss_dB = 5.0 + 4.0 * veg_stats.attenuation_norm;
calib.blind_link_loss_scale_dB = 4.5 + 3.0 * veg_stats.cover_density_norm;
calib.blind_interference_scale_dB = 1.8 + 1.4 * veg_stats.attenuation_norm;
calib.interference_scale = 1.6 + 0.7 * veg_stats.cover_density_norm;

% GNSS degradation from canopy proxy + pointcloud density
gnss_severity = min(max(0.55 * veg_stats.cover_density_norm + 0.45 * pcd_stats.canopy_density_norm, 0.0), 1.0);
calib.position_gnss_independent_noise_std = 0.08 + 0.06 * gnss_severity;
calib.position_gnss_multipath_noise_std = 0.12 + 0.10 * gnss_severity;
calib.position_blind_zone_sigma_penalty = 1.15 + 0.45 * gnss_severity;
calib.position_blind_zone_score_penalty = 0.20 + 0.10 * gnss_severity;
calib.position_rsu_relief_cap = 0.86 - 0.12 * gnss_severity;
calib.confidence_regime_blind_threshold = 0.18 - 0.05 * gnss_severity;
calib.confidence_regime_qpos_threshold = 0.72 + 0.05 * gnss_severity;

% Scheduler blind-zone parameters from geometry + attenuation
calib.utility_blind_protection_threshold = 0.54 - 0.05 * veg_stats.cover_density_norm;
calib.utility_blind_pos_threshold = 0.50 + 0.04 * gnss_severity;
calib.utility_blind_relay_threshold = 0.80 + 0.06 * veg_stats.cover_density_norm;
calib.utility_low_risk_guard_threshold = 0.30;
calib.utility_low_risk_blind_threshold = 0.15;

% Physical deadlines kept slightly relaxed in harder forest scenes
calib.deadline_coop = 0.19 + 0.01 * veg_stats.cover_density_norm;
calib.deadline_emergency = 0.073 + 0.004 * veg_stats.cover_density_norm;

try
    save(cache_path, 'calib');
catch ME
    warning('Could not save forest calibration cache: %s', ME.message);
end

disp(struct2table(local_flatten_calib(calib)));
end

function road_stats = local_extract_road_stats(roads_shp)
S = shaperead(roads_shp, 'UseGeoCoords', false, 'BoundingBox', [-125 32; -113 43]);
if isempty(S)
    S = shaperead(roads_shp, 'UseGeoCoords', false);
end

lengths_m = [];
curvature_vals = [];

for i = 1:min(numel(S), 1200)
    x = S(i).X(:);
    y = S(i).Y(:);
    mask = ~(isnan(x) | isnan(y));
    x = x(mask);
    y = y(mask);
    if numel(x) < 20
        continue;
    end
    xy = [x, y];
    lon0 = mean(xy(:,1));
    lat0 = mean(xy(:,2));
    xy = [(xy(:,1) - lon0) * 111320 * cosd(lat0), (xy(:,2) - lat0) * 111320];
    seg = hypot(diff(xy(:,1)), diff(xy(:,2)));
    lengths_m(end + 1, 1) = sum(seg); %#ok<AGROW>
    hd = atan2(diff(xy(:,2)), diff(xy(:,1)));
    turn = abs(mod(diff(hd) + pi, 2*pi) - pi);
    curvature_vals(end + 1, 1) = mean(turn); %#ok<AGROW>
end

road_stats.segment_length_p50_m = prctile(lengths_m, 50);
road_stats.segment_length_p75_m = prctile(lengths_m, 75);
road_stats.segment_length_p90_m = prctile(lengths_m, 90);
road_stats.curvature_mean = mean(curvature_vals);
road_stats.curvature_norm = min(max(road_stats.curvature_mean / 0.08, 0.0), 1.0);
end

function veg_stats = local_extract_vegetation_stats(tif_file)
[A, ~] = readgeoraster(tif_file);
sample_step = max(1, ceil(numel(A) / 2000000));
A = A(1:sample_step:end);
A = double(A(:));
A = A(isfinite(A));

if isempty(A)
    error('Vegetation raster has no finite samples: %s', tif_file);
end

veg_stats.cover_mean = mean(A);
veg_stats.cover_p75 = prctile(A, 75);
veg_stats.cover_p90 = prctile(A, 90);
veg_stats.cover_density_norm = min(max(veg_stats.cover_p75 / max(prctile(A, 99), 1.0e-6), 0.0), 1.0);
veg_stats.attenuation_norm = min(max(veg_stats.cover_p90 / max(prctile(A, 99), 1.0e-6), 0.0), 1.0);
end

function pcd_stats = local_extract_pointcloud_stats(pcd_file)
pc = pcread(pcd_file);
xyz = double(pc.Location);
if size(xyz, 1) > 200000
    idx = round(linspace(1, size(xyz, 1), 200000));
    xyz = xyz(idx, :);
end

z = xyz(:, 3);
z = z(~isnan(z));
pcd_stats.z_mean = mean(z);
pcd_stats.z_p75 = prctile(z, 75);
pcd_stats.z_p90 = prctile(z, 90);
pcd_stats.canopy_density_norm = min(max(pcd_stats.z_p75 / max(pcd_stats.z_p90, 1.0e-6), 0.0), 1.0);
end

function flat = local_flatten_calib(calib)
flat = struct();
names = {'link_distance_scale','pathloss_los_exponent','pathloss_nlos_exponent', ...
    'pathloss_los_offset_dB','pathloss_nlos_offset_dB','nlosv_extra_loss_dB', ...
    'blind_link_loss_scale_dB','blind_interference_scale_dB','interference_scale', ...
    'position_gnss_independent_noise_std','position_gnss_multipath_noise_std', ...
    'position_blind_zone_sigma_penalty','position_blind_zone_score_penalty', ...
    'position_rsu_relief_cap','confidence_regime_blind_threshold', ...
    'confidence_regime_qpos_threshold','utility_blind_protection_threshold', ...
    'utility_blind_pos_threshold','utility_blind_relay_threshold','deadline_coop', ...
    'deadline_emergency'};
for i = 1:numel(names)
    flat.(names{i}) = calib.(names{i});
end
end
