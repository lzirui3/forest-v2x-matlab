function pdr = step9_wilab_like_sinr_to_pdr(sinr_dB, scenario_tag, params)
%STEP9_WILAB_LIKE_SINR_TO_PDR Map SINR to PDR using WiLabV2Xsim PER curves.
if nargin < 3 || isempty(params)
    params = struct();
end

persistent table_cache
if isempty(table_cache)
    table_cache = containers.Map('KeyType', 'char', 'ValueType', 'any');
end

base_dir = resolve_per_curves_dir(params);
scenario_tag = char(string(scenario_tag));
cache_key = [base_dir '|' scenario_tag];

if ~isKey(table_cache, cache_key)
    [file_name, ~] = resolve_curve_file(base_dir, scenario_tag);
    [~, ~, sinr_tab_dB, per_tab, ~, ~] = step9_read_per_table(file_name, 2000);
    table_data.pdr_interp = griddedInterpolant( ...
        sinr_tab_dB(:), (1.0 - per_tab(:)), 'linear', 'linear');
    table_cache(cache_key) = table_data;
end

table_data = table_cache(cache_key);
pdr = table_data.pdr_interp(sinr_dB);
pdr = min(max(pdr, 0.0), 1.0);
end

function base_dir = resolve_per_curves_dir(params)
persistent cached_default_dir

has_param_dir = nargin >= 1 && ~isempty(params) && isstruct(params) ...
    && isfield(params, 'per_curves_dir') && strlength(string(params.per_curves_dir)) > 0;

env_dir = getenv('STEP9_PER_CURVES_DIR');
if has_param_dir
    candidate_dirs = {char(string(params.per_curves_dir))};
elseif ~isempty(env_dir)
    candidate_dirs = {env_dir};
elseif ~isempty(cached_default_dir) && isfolder(cached_default_dir)
    base_dir = cached_default_dir;
    return;
else
    this_dir = fileparts(mfilename('fullpath'));
    project_root = fileparts(this_dir);
    candidate_dirs = { ...
        fullfile(project_root, 'external_data', 'WiLabV2Xsim', 'PERcurves'), ...
        fullfile(project_root, 'external_data', 'WiLabV2Xsim-main', 'PERcurves'), ...
        fullfile(project_root, 'external_data', 'CV2X-LOCA', 'PERcurves')};
end

for i = 1:numel(candidate_dirs)
    if isfolder(candidate_dirs{i})
        base_dir = candidate_dirs{i};
        if ~has_param_dir && isempty(env_dir)
            cached_default_dir = base_dir;
        end
        return;
    end
end

error(['WiLabV2Xsim PERcurves directory not found. Set params.per_curves_dir ' ...
    'or env STEP9_PER_CURVES_DIR, or place PERcurves under external_data.']);
end

function [file_name, key] = resolve_curve_file(base_dir, scenario_tag)
switch char(string(scenario_tag))
    case 'urban_nlos'
        file_name = fullfile(base_dir, 'G5-UrbanNLOS', 'PER_NR_MCS7_100B.txt');
        key = 'urban_nlos_nr_mcs7_100b';
    case 'urban_los'
        file_name = fullfile(base_dir, 'G5-UrbanLOS', 'PER_LTE_MCS7_350B.txt');
        key = 'urban_los_lte_mcs7_350b';
    otherwise
        file_name = fullfile(base_dir, 'G5-HighwayLOS', 'PER_LTE_MCS7_350B.txt');
        key = 'highway_los_lte_mcs7_350b';
end

if ~isfile(file_name)
    error('PER curve file not found: %s', file_name);
end
end
