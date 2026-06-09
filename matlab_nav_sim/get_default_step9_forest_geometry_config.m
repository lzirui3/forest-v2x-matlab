function config = get_default_step9_forest_geometry_config(profile_name, vegetation_level)
%GET_DEFAULT_STEP9_FOREST_GEOMETRY_CONFIG External-input config for forest geometry demo.

if nargin < 1 || strlength(string(profile_name)) == 0
    profile_name = "Blind";
end
if nargin < 2 || strlength(string(vegetation_level)) == 0
    vegetation_level = "Medium";
end

profile_name = string(profile_name);
vegetation_level = string(vegetation_level);

base_dir = fileparts(mfilename('fullpath'));
data_dir = fullfile(base_dir, 'step9_data_templates');

config.mode = "external";
config.strict_external = false;
config.interp_method = "linear";

if profile_name == "Blind" && vegetation_level == "Medium"
    config.template_name = "forest_geometry_demo";
    config.trajectory_file = fullfile(data_dir, 'forest_geometry_demo_trajectory.csv');
    config.rsu_layout_file = fullfile(data_dir, 'forest_geometry_demo_rsu_layout.csv');
    config.blockage_profile_file = fullfile(data_dir, 'forest_geometry_demo_blockage_profile.csv');
    config.gnss_config_file = fullfile(data_dir, 'forest_geometry_demo_gnss_config.csv');
    config.message_profile_file = fullfile(data_dir, 'forest_geometry_demo_message_profile.csv');
else
    template_tag = lower(char(profile_name)) + "_" + lower(char(vegetation_level));
    config.template_name = "forest_geometry_" + template_tag;
    config.trajectory_file = fullfile(data_dir, sprintf('forest_geometry_%s_trajectory.csv', template_tag));
    config.rsu_layout_file = fullfile(data_dir, sprintf('forest_geometry_%s_rsu_layout.csv', template_tag));
    config.blockage_profile_file = fullfile(data_dir, sprintf('forest_geometry_%s_blockage_profile.csv', template_tag));
    config.gnss_config_file = fullfile(data_dir, sprintf('forest_geometry_%s_gnss_config.csv', template_tag));
    config.message_profile_file = fullfile(data_dir, sprintf('forest_geometry_%s_message_profile.csv', template_tag));
end
end
