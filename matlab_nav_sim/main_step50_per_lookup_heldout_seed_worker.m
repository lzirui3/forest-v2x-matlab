clc;
clear;
close all;

% Step50 seed worker: simulate a fixed seed list for one scene/config and
% write isolated shard files. It never writes the main case CSV, so multiple
% workers can run safely and later be merged.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP50_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP50_PREFIX_TAG', ...
    "step50_per_lookup_heldout_validation_" + string(num_seeds) + "seed");
scene_id = get_env_string_local('STEP50_WORKER_SCENE', "");
cfg = get_env_string_local('STEP50_WORKER_CONFIG', "");
seed_values = get_env_int_list_local('STEP50_WORKER_SEEDS', []);
shard_tag = get_env_string_local('STEP50_SHARD_TAG', "");

if strlength(scene_id) == 0 || strlength(cfg) == 0 || isempty(seed_values)
    error('STEP50_WORKER_SCENE, STEP50_WORKER_CONFIG, and STEP50_WORKER_SEEDS must be set.');
end
if strlength(shard_tag) == 0
    shard_tag = "seeds" + string(seed_values(1)) + "to" + string(seed_values(end));
end

scene_matrix = filter_scene_matrix_local(get_heldout_scene_matrix(), scene_id);
scene_meta = scene_matrix(1);
scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);
method_names = ["Link-delay-aware", "Confidence-heuristic", ...
    "Risk-constrained-v6", "Constrained Oracle"];

raw_path = sprintf('%s_%s_%s_shard_%s_raw.csv', prefix, scene_meta.scene_id, cfg, shard_tag);
stage_path = sprintf('%s_%s_%s_shard_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg, shard_tag);

if isfile(raw_path)
    T_raw = normalize_table_local(readtable(raw_path, 'TextType', 'string'));
    existing_seeds = unique(T_raw.Seed).';
else
    T_raw = [];
    existing_seeds = [];
end
if isfile(stage_path)
    T_stage = normalize_table_local(readtable(stage_path, 'TextType', 'string'));
else
    T_stage = [];
end

missing_seeds = setdiff(seed_values, existing_seeds, 'stable');
fprintf('Step50 seed worker: scene=%s config=%s shard=%s existing=%d missing=%d\n', ...
    scene_meta.scene_id, cfg, shard_tag, numel(existing_seeds), numel(missing_seeds));

base_params = get_params_for_config_local(cfg);
base_params.scenario_input = scene_cfg;
base_params.physical_pdr_mode = "per_lookup";

for seed = missing_seeds
    [T_seed, T_stage_seed] = simulate_seed_local(scene_meta, cfg, seed, method_names, base_params);
    T_raw = append_table_local(T_raw, T_seed);
    T_stage = append_table_local(T_stage, T_stage_seed);
    writetable(T_raw, raw_path);
    writetable(T_stage, stage_path);
end

fprintf('Step50 seed worker complete: scene=%s config=%s shard=%s.\n', ...
    scene_meta.scene_id, cfg, shard_tag);

function [T_seed, T_stage_seed] = simulate_seed_local(scene_meta, cfg, seed, method_names, base_params)
params = base_params;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    run_step9_proposed_method(scenario, params), ...
    rename_result_local(run_step9_baseline_oracle(scenario, params), "Constrained Oracle")};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_meta_columns_local(T_seed, scene_meta, cfg, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_meta_columns_local(T_stage_seed, scene_meta, cfg, seed);
end

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step50 seed worker config: %s', cfg);
end
end

function result = rename_result_local(result, name)
result.name = name;
end

function T = add_meta_columns_local(T, scene_meta, cfg, seed)
T.Scene = repmat(scene_meta.scene_id, height(T), 1);
T.SceneRole = repmat(scene_meta.scene_role, height(T), 1);
T.GeometryType = repmat(scene_meta.geometry_type, height(T), 1);
T.DensityClass = repmat(scene_meta.density_class, height(T), 1);
T.VegetationClass = repmat(scene_meta.vegetation_class, height(T), 1);
T.Config = repmat(cfg, height(T), 1);
T.PdrMode = repmat("per_lookup", height(T), 1);
T.Seed = repmat(seed, height(T), 1);
T = movevars(T, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Seed'}, 'Before', 'Method');
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function scenes = filter_scene_matrix_local(scene_matrix, scene_id)
scenes = scene_matrix([]);
for j = 1:numel(scene_matrix)
    if scene_matrix(j).scene_id == scene_id
        scenes(end + 1) = scene_matrix(j); %#ok<AGROW>
        return;
    end
end
error('Unknown Step50 held-out scene id: %s', scene_id);
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = string(raw);
end
end

function value = get_env_int_local(name, default_value)
raw = str2double(getenv(name));
if isnan(raw) || raw < 1
    value = default_value;
else
    value = round(raw);
end
end

function values = get_env_int_list_local(name, default_values)
raw = getenv(name);
if isempty(raw)
    values = default_values;
    return;
end
parts = split(string(raw), ',');
values = [];
for i = 1:numel(parts)
    token = strtrim(parts(i));
    if contains(token, ':')
        range_parts = split(token, ':');
        if numel(range_parts) ~= 2
            error('Invalid integer range token: %s', token);
        end
        a = str2double(range_parts(1));
        b = str2double(range_parts(2));
        values = [values, a:b]; %#ok<AGROW>
    else
        values = [values, str2double(token)]; %#ok<AGROW>
    end
end
values = unique(round(values(~isnan(values))), 'stable');
end

function T = append_table_local(T, rows)
if isempty(rows)
    return;
end

if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
