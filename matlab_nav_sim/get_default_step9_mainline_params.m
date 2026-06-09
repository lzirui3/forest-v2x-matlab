function params = get_default_step9_mainline_params()
%GET_DEFAULT_STEP9_MAINLINE_PARAMS Default Step 9-13 experiment parameters.

params = get_default_step9_params();
params.scenario_input = get_default_step9_v2xseq_config();
params.dt = 0.2;
params.deadline_normal = params.deadline_normal_physical;
params.deadline_coop = params.deadline_coop_physical;
params.deadline_emergency = params.deadline_emergency_physical;
params.use_physical_delivery = true;
params = local_apply_physical_delivery_guard(params);
end

function params = local_apply_physical_delivery_guard(params)
if local_has_per_curves(params)
    return;
end

warning(['PERcurves resource not found in the packaged workspace. ' ...
    'Fallback to abstract delivery model for reproducible execution.']);
params.use_physical_delivery = false;
end

function tf = local_has_per_curves(params)
tf = false;
candidate_dirs = {};

if isfield(params, 'per_curves_dir') && strlength(string(params.per_curves_dir)) > 0
    candidate_dirs{end + 1} = char(string(params.per_curves_dir)); %#ok<AGROW>
end

env_dir = getenv('STEP9_PER_CURVES_DIR');
if ~isempty(env_dir)
    candidate_dirs{end + 1} = env_dir; %#ok<AGROW>
end

this_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(this_dir);
candidate_dirs{end + 1} = fullfile(project_root, 'external_data', 'WiLabV2Xsim', 'PERcurves'); %#ok<AGROW>
candidate_dirs{end + 1} = fullfile(project_root, 'external_data', 'WiLabV2Xsim-main', 'PERcurves'); %#ok<AGROW>
candidate_dirs{end + 1} = fullfile(project_root, 'external_data', 'CV2X-LOCA', 'PERcurves'); %#ok<AGROW>

for i = 1:numel(candidate_dirs)
    per_los = fullfile(candidate_dirs{i}, 'G5-UrbanLOS', 'PER_LTE_MCS7_350B.txt');
    per_nlos = fullfile(candidate_dirs{i}, 'G5-UrbanNLOS', 'PER_NR_MCS7_100B.txt');
    if isfile(per_los) && isfile(per_nlos)
        tf = true;
        return;
    end
end
end
