function params = get_forest_dataset_calibrated_params(base_params)
%GET_FOREST_DATASET_CALIBRATED_PARAMS
% Apply a conservative forest-scene calibration using the packaged forest
% road / below-canopy / forest-path datasets under external_data.

if nargin < 1 || isempty(base_params)
    params = get_default_step9_params();
else
    params = base_params;
end

this_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(this_dir);
forest_roads_dir = fullfile(project_root, 'external_data', 'Forest_Roads_USFS');
below_canopy_dir = fullfile(project_root, 'external_data', 'Below_Canopy_Forestry');
forest_paths_dir = fullfile(project_root, 'external_data', 'ForestPaths');

required_files = { ...
    fullfile(forest_roads_dir, 'S_USA.RoadCore_FS.shp'), ...
    fullfile(below_canopy_dir, 'Below_canopy_pointcloud_2024-11-15-08-45-11.pcd'), ...
    fullfile(forest_paths_dir, 'ForestPaths_grid.gpkg')};

for i = 1:numel(required_files)
    if ~isfile(required_files{i})
        error('Forest calibration resource missing: %s', required_files{i});
    end
end

calib = calibrate_forest_scene_params();

params.link_distance_scale = calib.link_distance_scale;

params.tx_power_dBm = 22.0;
params.noise_floor_dBm = -94.0;
params.pathloss_los_offset_dB = calib.pathloss_los_offset_dB;
params.pathloss_los_exponent = calib.pathloss_los_exponent;
params.pathloss_nlos_offset_dB = calib.pathloss_nlos_offset_dB;
params.pathloss_nlos_exponent = calib.pathloss_nlos_exponent;
params.nlosv_extra_loss_dB = calib.nlosv_extra_loss_dB;
params.interference_scale = calib.interference_scale;
params.blind_link_loss_scale_dB = calib.blind_link_loss_scale_dB;
params.blind_interference_scale_dB = calib.blind_interference_scale_dB;

params.position_gnss_independent_noise_std = calib.position_gnss_independent_noise_std;
params.position_gnss_independent_temporal_len = 15;
params.position_gnss_multipath_noise_std = calib.position_gnss_multipath_noise_std;
params.position_gnss_multipath_temporal_len = 10;

params.position_blind_zone_sigma_penalty = calib.position_blind_zone_sigma_penalty;
params.position_blind_zone_score_penalty = calib.position_blind_zone_score_penalty;
params.position_rsu_relief_cap = calib.position_rsu_relief_cap;
params.position_alpha_blind_scale = 0.28;
params.position_alpha_max = 0.97;

params.blind_zone_trigger_threshold = 0.50;
params.rsu_event_trigger_threshold = 0.48;
params.env_event_trigger_threshold = 0.18;

params.confidence_regime_blind_threshold = calib.confidence_regime_blind_threshold;
params.confidence_regime_qpos_threshold = calib.confidence_regime_qpos_threshold;

params.utility_blind_protection_threshold = calib.utility_blind_protection_threshold;
params.utility_blind_pos_threshold = calib.utility_blind_pos_threshold;
params.utility_blind_min_priority = 2;
params.utility_blind_force_mode = 1;
params.utility_blind_relay_threshold = calib.utility_blind_relay_threshold;
params.utility_low_risk_guard_threshold = calib.utility_low_risk_guard_threshold;
params.utility_low_risk_blind_threshold = calib.utility_low_risk_blind_threshold;

params.deadline_coop = calib.deadline_coop;
params.deadline_emergency = calib.deadline_emergency;
params.deadline_coop_physical = calib.deadline_coop;
params.deadline_emergency_physical = calib.deadline_emergency;

params.forest_calibration.enabled = true;
params.forest_calibration.source_dirs = struct( ...
    'forest_roads', forest_roads_dir, ...
    'below_canopy', below_canopy_dir, ...
    'forest_paths', forest_paths_dir);
params.forest_calibration.stats = calib;
end
