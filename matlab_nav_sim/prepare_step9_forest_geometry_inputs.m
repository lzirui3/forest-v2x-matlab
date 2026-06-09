function summary = prepare_step9_forest_geometry_inputs(profile_name, vegetation_level, veg_options, template_variant)
%PREPARE_STEP9_FOREST_GEOMETRY_INPUTS
% Build a geometry-driven forest scenario from packaged forestry datasets.

if nargin < 1 || strlength(string(profile_name)) == 0
    profile_name = "Blind";
end
if nargin < 2 || strlength(string(vegetation_level)) == 0
    vegetation_level = "Medium";
end
if nargin < 3 || isempty(veg_options)
    veg_options = struct();
end
if nargin < 4 || strlength(string(template_variant)) == 0
    template_variant = "base";
end

profile_name = string(profile_name);
vegetation_level = string(vegetation_level);
template_variant = string(template_variant);
template_tag = lower(char(profile_name)) + "_" + lower(char(vegetation_level));
if template_variant == "plus"
    template_stem = "forest_geometry_plus_" + template_tag;
else
    template_stem = "forest_geometry_" + template_tag;
end

base_dir = fileparts(mfilename('fullpath'));
repo_dir = fileparts(base_dir);
output_dir = fullfile(base_dir, 'step9_data_templates');

roads_shp = fullfile(repo_dir, 'external_data', 'Forest_Roads_USFS', 'S_USA.RoadCore_FS.shp');
paths_gpkg = fullfile(repo_dir, 'external_data', 'ForestPaths', 'ForestPaths_grid.gpkg');
tif_file = fullfile(repo_dir, 'external_data', 'ForestPaths', 'merged_pred_q050_ulx_5900_uly_1640.tif');
pcd_file = fullfile(repo_dir, 'external_data', 'Below_Canopy_Forestry', ...
    'Below_canopy_pointcloud_2024-11-15-08-45-11.pcd');

required_files = {roads_shp, paths_gpkg, tif_file, pcd_file};
for i = 1:numel(required_files)
    if ~isfile(required_files{i})
        error('Forest geometry resource missing: %s', required_files{i});
    end
end

try
    road_xy = local_extract_forest_road_polyline(roads_shp);
    road_xy = local_select_road_segment(road_xy, profile_name);
    [tx_xy, rx_xy, road_metrics] = local_build_two_vehicle_trajectory(road_xy, profile_name);
    road_source = "USFS_RoadCore";
catch ME
    warning('Forest road extraction fallback triggered: %s', ME.message);
    [tx_xy, rx_xy, road_metrics] = local_build_v2xseq_backbone(repo_dir, profile_name);
    road_xy = [tx_xy(:, 1), tx_xy(:, 2)];
    road_source = "V2XSeqBackbone";
end
[veg_scale, rsu_scale] = local_get_vegetation_scale(vegetation_level);
[occlusion_score, veg_score, raster_meta] = local_build_geometry_scores(tx_xy, rx_xy, tif_file, veg_scale, profile_name);
[n_sat, dop, sigma_pos, dt_upd, gnss_meta] = local_build_gnss_profile(veg_score, pcd_file, veg_scale);
[msg_type, relay_available] = local_build_message_profile(tx_xy, rx_xy, occlusion_score, profile_name);
[rsu_x, rsu_y, rsu_cov] = local_build_sparse_rsu_layout(tx_xy, rx_xy, occlusion_score, rsu_scale);
[is_nlos, nlosv, shadowing_dB, interference_dB, veg_atten_dB] = local_build_blockage_profile( ...
    tx_xy, rx_xy, occlusion_score, veg_score, relay_available, road_metrics, veg_scale, profile_name, veg_options);

defaults = paramsafe_defaults(veg_options);
use_veg_atten = defaults.use_veg_attenuation;
if ~use_veg_atten
    veg_atten_dB = zeros(size(veg_atten_dB));
end

N = size(tx_xy, 1);
t = linspace(0.0, 120.0, N)';

trajectory_table = table( ...
    t, tx_xy(:, 1), tx_xy(:, 2), rx_xy(:, 1), rx_xy(:, 2), relay_available, ...
    'VariableNames', {'t', 'tx_x', 'tx_y', 'rx_x', 'rx_y', 'relay_available'});
blockage_table = table( ...
    t, is_nlos, nlosv, shadowing_dB, interference_dB, veg_atten_dB, ...
    'VariableNames', {'t', 'is_nlos', 'nlosv', 'shadowing_dB', 'interference_dB', 'veg_atten_dB'});
rsu_table = table( ...
    rsu_x, rsu_y, rsu_cov, ...
    'VariableNames', {'rsu_x', 'rsu_y', 'coverage'});
gnss_table = table( ...
    t, n_sat, dop, sigma_pos, dt_upd, ...
    'VariableNames', {'t', 'n_sat', 'dop', 'sigma_pos', 'dt_upd'});
message_table = table( ...
    t, msg_type, relay_available, ...
    'VariableNames', {'t', 'msg_type', 'relay_available'});

trajectory_file = fullfile(output_dir, sprintf('%s_trajectory.csv', template_stem));
blockage_file = fullfile(output_dir, sprintf('%s_blockage_profile.csv', template_stem));
rsu_file = fullfile(output_dir, sprintf('%s_rsu_layout.csv', template_stem));
gnss_file = fullfile(output_dir, sprintf('%s_gnss_config.csv', template_stem));
message_file = fullfile(output_dir, sprintf('%s_message_profile.csv', template_stem));

writetable(trajectory_table, trajectory_file);
writetable(blockage_table, blockage_file);
writetable(rsu_table, rsu_file);
writetable(gnss_table, gnss_file);
writetable(message_table, message_file);

if template_variant == "base" && profile_name == "Blind" && vegetation_level == "Medium"
    writetable(trajectory_table, fullfile(output_dir, 'forest_geometry_demo_trajectory.csv'));
    writetable(blockage_table, fullfile(output_dir, 'forest_geometry_demo_blockage_profile.csv'));
    writetable(rsu_table, fullfile(output_dir, 'forest_geometry_demo_rsu_layout.csv'));
    writetable(gnss_table, fullfile(output_dir, 'forest_geometry_demo_gnss_config.csv'));
    writetable(message_table, fullfile(output_dir, 'forest_geometry_demo_message_profile.csv'));
end

summary = struct();
summary.num_samples = N;
summary.road_points = size(road_xy, 1);
summary.min_distance_m = min(hypot(tx_xy(:,1) - rx_xy(:,1), tx_xy(:,2) - rx_xy(:,2)));
summary.max_distance_m = max(hypot(tx_xy(:,1) - rx_xy(:,1), tx_xy(:,2) - rx_xy(:,2)));
summary.nlos_ratio = mean(is_nlos);
summary.mean_occlusion_score = mean(occlusion_score);
summary.mean_veg_score = mean(veg_score);
summary.mean_sigma_pos = mean(sigma_pos);
summary.mean_veg_atten_dB = mean(veg_atten_dB);
summary.road_source = road_source;
summary.profile_name = profile_name;
summary.vegetation_level = vegetation_level;
summary.template_variant = template_variant;
summary.template_stem = template_stem;
summary.raster_mean = raster_meta.mean_value;
summary.raster_p90 = raster_meta.p90_value;
summary.pcd_density_proxy = gnss_meta.density_proxy;
summary.trajectory_file = string(trajectory_file);
summary.blockage_file = string(blockage_file);
summary.rsu_file = string(rsu_file);
summary.gnss_file = string(gnss_file);
summary.message_file = string(message_file);

disp(struct2table(summary));
end

function [tx_xy, rx_xy, metrics] = local_build_v2xseq_backbone(repo_dir, profile_name)
switch char(profile_name)
    case 'Straight'
        scene_id = "10006";
    case 'Curved'
        scene_id = "10017";
    otherwise
        scene_id = "10014";
end
traj_file = fullfile(repo_dir, 'matlab_nav_sim', 'step9_data_templates', ...
    sprintf('v2xseq_scene%s_trajectory.csv', scene_id));
if ~isfile(traj_file)
    error('Fallback V2X-Seq backbone file missing: %s', traj_file);
end

T = readtable(traj_file);
tx_xy = [T.tx_x(:), T.tx_y(:)];
rx_xy = [T.rx_x(:), T.rx_y(:)];

dxy = diff(tx_xy, 1, 1);
heading = atan2(dxy(:,2), dxy(:,1));
heading = [heading; heading(end)];
turn = [0; abs(mod(diff(heading) + pi, 2*pi) - pi)];
metrics.heading = heading;
metrics.turn_rate = movmean(turn, 9);
end

function road_xy = local_select_road_segment(road_xy, profile_name)
xy_dense = local_resample_polyline(road_xy, 900);
dxy = diff(xy_dense, 1, 1);
heading = atan2(dxy(:, 2), dxy(:, 1));
turn = [0; abs(mod(diff(heading) + pi, 2*pi) - pi)];
turn = movmean(turn, 31);

win = 220;
half_win = floor(win / 2);
valid_idx = (1 + half_win):(size(xy_dense, 1) - half_win);
score = turn(valid_idx);

switch char(profile_name)
    case 'Straight'
        [~, rel_idx] = min(score);
    case 'Curved'
        target = prctile(score, 70);
        [~, rel_idx] = min(abs(score - target));
    otherwise
        [~, rel_idx] = max(score);
end

center_idx = valid_idx(rel_idx);
seg_idx = (center_idx - half_win):(center_idx + half_win);
road_xy = xy_dense(seg_idx, :);
road_xy = local_resample_polyline(road_xy, 140);
end

function road_xy = local_extract_forest_road_polyline(roads_shp)
S = shaperead(roads_shp, 'UseGeoCoords', false, 'BoundingBox', [-125 32; -113 43]);
if isempty(S)
    S = shaperead(roads_shp, 'UseGeoCoords', false);
end

best_score = -inf;
road_xy = [];

for i = 1:min(numel(S), 800)
    if ~isfield(S, 'X') || ~isfield(S, 'Y')
        continue;
    end
    x = S(i).X(:);
    y = S(i).Y(:);
    mask = ~(isnan(x) | isnan(y));
    x = x(mask);
    y = y(mask);
    if numel(x) < 50
        continue;
    end
    xy = [x, y];
    dxy = diff(xy, 1, 1);
    seg_len = hypot(dxy(:,1), dxy(:,2));
    total_len = sum(seg_len);
    if total_len < 0.02
        continue;
    end
    turn = abs(atan2(dxy(2:end,2), dxy(2:end,1)) - atan2(dxy(1:end-1,2), dxy(1:end-1,1)));
    turn = mod(turn + pi, 2*pi) - pi;
    curvature_score = mean(abs(turn));
    score = total_len + 0.8 * curvature_score;
    if score > best_score
        best_score = score;
        road_xy = xy;
    end
end

if isempty(road_xy)
    error('No usable forest road polyline found in shapefile.');
end

road_xy = local_resample_polyline(road_xy, 140);
road_xy = local_to_metric_xy(road_xy);
end

function [tx_xy, rx_xy, metrics] = local_build_two_vehicle_trajectory(road_xy, profile_name)
N = 601;
road_main = local_resample_polyline(road_xy, N);

seg = hypot(diff(road_main(:,1)), diff(road_main(:,2)));
s = [0; cumsum(seg)];
total_len = s(end);
if total_len <= 1.0e-6
    error('Forest road polyline length is too small.');
end

tx_s = linspace(0.10 * total_len, 0.82 * total_len, N)';
phase = linspace(0, 2*pi, N)';
switch char(profile_name)
    case 'Straight'
        sep = 40.0 + 14.0 * sin(phase) + 10.0 * (sin(0.5 * phase + 0.6) .^ 2);
        sep_min = 20.0; sep_max = 80.0;
    case 'Curved'
        sep = 50.0 + 18.0 * sin(phase) + 14.0 * (sin(0.5 * phase + 0.8) .^ 2);
        sep_min = 25.0; sep_max = 95.0;
    otherwise
        sep = 58.0 + 24.0 * sin(phase) + 18.0 * (sin(0.5 * phase + 0.9) .^ 2);
        sep_min = 28.0; sep_max = 120.0;
end
sep = min(max(sep, sep_min), sep_max);
rx_s = min(tx_s + sep, 0.97 * total_len);

tx_xy = [interp1(s, road_main(:,1), tx_s, 'linear'), interp1(s, road_main(:,2), tx_s, 'linear')];
rx_xy = [interp1(s, road_main(:,1), rx_s, 'linear'), interp1(s, road_main(:,2), rx_s, 'linear')];

dxy = diff(road_main, 1, 1);
heading = atan2(dxy(:,2), dxy(:,1));
heading = [heading; heading(end)];
turn = [0; abs(mod(diff(heading) + pi, 2*pi) - pi)];
metrics.heading = heading(1:N);
metrics.turn_rate = turn(1:N);
end

function [occlusion_score, veg_score, meta] = local_build_geometry_scores(tx_xy, rx_xy, tif_file, veg_scale, profile_name)
[A, ~] = readgeoraster(tif_file);
A = double(A);
A = A(~isnan(A));
if isempty(A)
    error('Forest raster is empty: %s', tif_file);
end

q50 = A / max(prctile(A, 99), 1.0e-6);
q50 = min(max(q50, 0.0), 1.0);

base_mean = mean(q50);
base_p90 = prctile(q50, 90);
meta.mean_value = base_mean;
meta.p90_value = base_p90;

dist = hypot(tx_xy(:,1) - rx_xy(:,1), tx_xy(:,2) - rx_xy(:,2));
mid_x = 0.5 * (tx_xy(:,1) + rx_xy(:,1));
mid_y = 0.5 * (tx_xy(:,2) + rx_xy(:,2));

curve_gate = local_normalize01(movmean(abs([0; diff(atan2(diff([mid_y; mid_y(end)]), diff([mid_x; mid_x(end)])))]), 9));
dist_gate = local_normalize01((dist - prctile(dist, 20)) / max(prctile(dist, 85) - prctile(dist, 20), 1.0e-6));

phase_1 = 0.5 * (1.0 + sin(linspace(0, 3.5*pi, numel(dist))')) ;
phase_2 = 0.5 * (1.0 + cos(linspace(0.3*pi, 2.8*pi, numel(dist))')) ;

switch char(profile_name)
    case 'Straight'
        curve_weight = 0.14;
        dist_weight = 0.18;
    case 'Curved'
        curve_weight = 0.24;
        dist_weight = 0.16;
    otherwise
        curve_weight = 0.34;
        dist_weight = 0.20;
end

veg_score = min(max((0.30 * base_mean + 0.25 * phase_1 + 0.15 * phase_2) * veg_scale, 0.0), 0.85);
occlusion_score = min(max(0.22 * veg_score + curve_weight * curve_gate + dist_weight * dist_gate, 0.0), 0.85);
end

function [n_sat, dop, sigma_pos, dt_upd, meta] = local_build_gnss_profile(veg_score, pcd_file, veg_scale)
info = dir(pcd_file);
pcd_bytes = double(info.bytes);
density_proxy = min(max(log10(max(pcd_bytes, 1)) / 8.0, 0.2), 1.4);
meta.density_proxy = density_proxy;

N = numel(veg_score);
veg_smooth = movmean(veg_score, 11);
canopy = min(max((0.45 * veg_smooth + 0.15 * density_proxy) * (0.85 + 0.15 * veg_scale), 0.0), 0.75);

n_sat = max(5.0, 11.5 - 4.0 * canopy);
dop = 1.1 + 2.2 * canopy;
sigma_pos = 0.9 + 2.2 * canopy;
dt_upd = 0.18 + 0.45 * canopy;

if N >= 2
    n_sat(1) = n_sat(2);
end
end

function [msg_type, relay_available] = local_build_message_profile(tx_xy, rx_xy, occlusion_score, profile_name)
dist = hypot(tx_xy(:,1) - rx_xy(:,1), tx_xy(:,2) - rx_xy(:,2));
msg_type = repmat("normal", numel(dist), 1);

switch char(profile_name)
    case 'Straight'
        coop_occ = 0.38;
        emerg_occ = 0.56;
    case 'Curved'
        coop_occ = 0.42;
        emerg_occ = 0.60;
    otherwise
        coop_occ = 0.45;
        emerg_occ = 0.62;
end

coop_mask = (dist <= prctile(dist, 45)) | (occlusion_score >= coop_occ);
emerg_mask = (dist <= prctile(dist, 18)) | (occlusion_score >= emerg_occ);

msg_type(coop_mask) = "coop";
msg_type(emerg_mask) = "emergency";

relay_available = double(occlusion_score >= coop_occ + 0.04);
relay_available = double(movmax(relay_available, [3, 3]) > 0);
end

function [rsu_x, rsu_y, rsu_cov] = local_build_sparse_rsu_layout(tx_xy, rx_xy, occlusion_score, rsu_scale)
mid_xy = [0.5 * (tx_xy(:,1) + rx_xy(:,1)), 0.5 * (tx_xy(:,2) + rx_xy(:,2))];
[~, idx_peak] = maxk(occlusion_score, 3);
anchors = mid_xy(sort(unique(idx_peak)), :);

if size(anchors, 1) < 2
    anchors = mid_xy(round(linspace(100, size(mid_xy, 1) - 100, 2)), :);
end

rsu_x = anchors(:, 1);
rsu_y = anchors(:, 2);
rsu_cov = (45.0 + 15.0 * local_normalize01(occlusion_score(sort(unique(idx_peak))))) * rsu_scale;
rsu_cov = rsu_cov(:);
if numel(rsu_cov) ~= numel(rsu_x)
    rsu_cov = 55.0 * ones(numel(rsu_x), 1);
end
end

function [is_nlos, nlosv, shadowing_dB, interference_dB, veg_atten_dB] = local_build_blockage_profile( ...
    tx_xy, rx_xy, occlusion_score, veg_score, relay_available, road_metrics, veg_scale, profile_name, veg_options)
dist = hypot(tx_xy(:,1) - rx_xy(:,1), tx_xy(:,2) - rx_xy(:,2));
turn_gate = local_normalize01(road_metrics.turn_rate(:));

switch char(profile_name)
    case 'Straight'
        curve_term = 0.12;
        q_nlos_pct = 76;
        q_hard_pct = 92;
    case 'Curved'
        curve_term = 0.20;
        q_nlos_pct = 72;
        q_hard_pct = 90;
    otherwise
        curve_term = 0.28;
        q_nlos_pct = 68;
        q_hard_pct = 88;
end

geom_score = min(max(0.44 * occlusion_score + 0.24 * veg_score + curve_term * turn_gate, 0.0), 0.95);
q_nlos = prctile(geom_score, q_nlos_pct);
q_hard = prctile(geom_score, q_hard_pct);
is_nlos = geom_score >= max(0.26, q_nlos);
nlosv = zeros(size(geom_score));
nlosv(is_nlos) = 1;
nlosv(geom_score >= max(0.42, q_hard)) = 2;

dist_scale = local_normalize01((dist - prctile(dist, 15)) / max(prctile(dist, 90) - prctile(dist, 15), 1.0e-6));
crossed_length_norm = min(max(dist / 120.0, 0.0), 1.0);
defaults = paramsafe_defaults(veg_options);
veg_atten_dB = defaults.veg_attenuation_scale * ( ...
    defaults.veg_attenuation_base_coeff * veg_scale ...
    + defaults.veg_attenuation_score_coeff * veg_score ...
    + defaults.veg_attenuation_length_coeff * crossed_length_norm);
veg_atten_dB = min(max(veg_atten_dB, 0.2), 3.8);

shadowing_dB = min(max((1.2 + 2.8 * geom_score + 0.9 * dist_scale ...
    + 1.1 * double(is_nlos) + 0.7 * double(nlosv >= 2)) * (0.85 + 0.15 * veg_scale), 0.0), 7.8);
interference_dB = min(max((0.5 + 1.4 * geom_score + 0.4 * relay_available ...
    + 0.5 * double(is_nlos)) * (0.90 + 0.10 * veg_scale), 0.0), 3.8);

is_nlos = double(is_nlos);
nlosv = nlosv(:);
shadowing_dB = shadowing_dB(:);
interference_dB = interference_dB(:);
veg_atten_dB = veg_atten_dB(:);
end

function [veg_scale, rsu_scale] = local_get_vegetation_scale(vegetation_level)
switch char(vegetation_level)
    case 'Sparse'
        veg_scale = 0.82;
        rsu_scale = 1.10;
    case 'Dense'
        veg_scale = 1.18;
        rsu_scale = 0.92;
    otherwise
        veg_scale = 1.00;
        rsu_scale = 1.00;
end
end

function defaults = paramsafe_defaults(overrides)
defaults = struct( ...
    'use_veg_attenuation', false, ...
    'veg_attenuation_scale', 1.0, ...
    'veg_attenuation_base_coeff', 0.8, ...
    'veg_attenuation_score_coeff', 1.6, ...
    'veg_attenuation_length_coeff', 1.0, ...
    'veg_attenuation_shadowing_coeff', 0.65, ...
    'veg_attenuation_interference_coeff', 0.18);
if nargin >= 1 && isstruct(overrides)
    fn = fieldnames(overrides);
    for i = 1:numel(fn)
        defaults.(fn{i}) = overrides.(fn{i});
    end
end
end

function xy_metric = local_to_metric_xy(xy_deg)
lon = xy_deg(:, 1);
lat = xy_deg(:, 2);
lon0 = mean(lon);
lat0 = mean(lat);
meters_per_deg_lat = 111320.0;
meters_per_deg_lon = meters_per_deg_lat * cosd(lat0);
xy_metric = [(lon - lon0) * meters_per_deg_lon, (lat - lat0) * meters_per_deg_lat];
end

function xy = local_resample_polyline(xy_in, N)
seg = hypot(diff(xy_in(:,1)), diff(xy_in(:,2)));
s = [0; cumsum(seg)];
if s(end) <= 1.0e-9
    xy = repmat(xy_in(1, :), N, 1);
    return;
end
s_target = linspace(0, s(end), N)';
xy = [interp1(s, xy_in(:,1), s_target, 'linear'), interp1(s, xy_in(:,2), s_target, 'linear')];
end

function x = local_normalize01(x)
x = double(x(:));
x_min = min(x);
x_max = max(x);
if x_max - x_min <= 1.0e-9
    x = zeros(size(x));
else
    x = (x - x_min) / (x_max - x_min);
end
end
