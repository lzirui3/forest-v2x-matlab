function config = get_default_step9_data_backed_config()
%GET_DEFAULT_STEP9_DATA_BACKED_CONFIG Default external-input configuration.

base_dir = fileparts(mfilename('fullpath'));
data_dir = fullfile(base_dir, 'step9_data_templates');

config.mode = "external";
config.strict_external = false;
config.interp_method = "linear";
config.template_name = "forest_demo";

config.trajectory_file = fullfile(data_dir, 'forest_demo_trajectory.csv');
config.rsu_layout_file = fullfile(data_dir, 'forest_demo_rsu_layout.csv');
config.blockage_profile_file = fullfile(data_dir, 'forest_demo_blockage_profile.csv');
config.gnss_config_file = fullfile(data_dir, 'forest_demo_gnss_config.csv');
config.message_profile_file = fullfile(data_dir, 'forest_demo_message_profile.csv');
end
