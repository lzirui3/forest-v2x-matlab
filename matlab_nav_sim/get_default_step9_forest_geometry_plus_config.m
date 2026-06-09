function config = get_default_step9_forest_geometry_plus_config(profile_name, vegetation_level)
%GET_DEFAULT_STEP9_FOREST_GEOMETRY_PLUS_CONFIG External-input config for realism-augmented forest geometry.

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
template_tag = lower(char(profile_name)) + "_" + lower(char(vegetation_level));
template_stem = "forest_geometry_plus_" + template_tag;

config.mode = "external";
config.strict_external = false;
config.interp_method = "linear";
config.template_name = template_stem;

config.trajectory_file = fullfile(data_dir, sprintf('%s_trajectory.csv', template_stem));
config.rsu_layout_file = fullfile(data_dir, sprintf('%s_rsu_layout.csv', template_stem));
config.blockage_profile_file = fullfile(data_dir, sprintf('%s_blockage_profile.csv', template_stem));
config.gnss_config_file = fullfile(data_dir, sprintf('%s_gnss_config.csv', template_stem));
config.message_profile_file = fullfile(data_dir, sprintf('%s_message_profile.csv', template_stem));
end
