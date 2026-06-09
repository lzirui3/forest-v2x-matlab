function config = get_step9_v2xseq_config_by_scene(scene_id)
%GET_STEP9_V2XSEQ_CONFIG_BY_SCENE Build a V2X-Seq-backed config for one scene.

if nargin < 1 || strlength(string(scene_id)) == 0
    scene_id = "10014";
end

scene_id = string(scene_id);
config = get_default_step9_data_backed_config();

base_dir = fileparts(mfilename('fullpath'));
data_dir = fullfile(base_dir, 'step9_data_templates');

config.template_name = "v2xseq_scene" + scene_id;
config.trajectory_file = fullfile(data_dir, sprintf('v2xseq_scene%s_trajectory.csv', scene_id));
config.rsu_layout_file = fullfile(data_dir, sprintf('v2xseq_scene%s_rsu_layout.csv', scene_id));
config.blockage_profile_file = fullfile(data_dir, sprintf('v2xseq_scene%s_blockage_profile.csv', scene_id));
config.message_profile_file = fullfile(data_dir, sprintf('v2xseq_scene%s_message_profile.csv', scene_id));

if ~isfile(config.trajectory_file) || ~isfile(config.message_profile_file) ...
        || ~isfile(config.rsu_layout_file) || ~isfile(config.blockage_profile_file)
    prepare_step9_v2xseq_inputs(scene_id);
end
end
