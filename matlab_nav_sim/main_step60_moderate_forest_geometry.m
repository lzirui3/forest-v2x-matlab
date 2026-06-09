clc;
clear;
close all;

% Step60: ModerateForestGeometry validation.
% Adds a deployable moderate forest-degradation setting without changing or
% overwriting the original ForestGeometry stress-test evidence.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP60_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP60_PREFIX_TAG', ...
    "step60_moderate_forest_geometry_" + string(num_seeds) + "seed");
cfg = "ModerateForestGeometry";
method_names = ["Link-delay-aware", "Confidence-heuristic", "Risk-constrained-v6", ...
    "Constrained Oracle", "DCC-like", "AoI-aware", "DCC-CBR-window", "AoI-greedy"];
all_scene_matrix = [get_paper_scene_matrix(), get_heldout_scene_matrix()];
scene_filter_raw = getenv('STEP60_SCENES');
run_scene_matrix = filter_scene_matrix_local(all_scene_matrix, scene_filter_raw);
seed_list = 1:num_seeds;

for scene_idx = 1:numel(run_scene_matrix)
    scene_meta = run_scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_meta.scene_id, cfg);
    stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg);
    [T_case_raw, T_case_stage] = read_existing_case_tables_local(raw_path, stage_path);

    if isempty(T_case_raw)
        existing_seeds = [];
    else
        existing_seeds = unique(T_case_raw.Seed).';
    end
    missing_seeds = setdiff(seed_list, existing_seeds, 'stable');
    fprintf('Step60 resume: scene=%s config=%s existing=%d missing=%d\n', ...
        scene_meta.scene_id, cfg, numel(existing_seeds), numel(missing_seeds));

    for seed = missing_seeds
        [T_seed, T_stage_seed] = simulate_moderate_seed_local(scene_meta, scene_cfg, cfg, seed, method_names);
        T_case_raw = append_table_local(T_case_raw, T_seed);
        T_case_stage = append_table_local(T_case_stage, T_stage_seed);
        writetable(T_case_raw, raw_path);
        writetable(T_case_stage, stage_path);
    end
end

if ~isempty(scene_filter_raw)
    fprintf('Step60 shard complete. Aggregate outputs are intentionally skipped while STEP60_SCENES is set.\n');
    return;
end

if ~all_case_tables_exist_local(prefix, all_scene_matrix, cfg)
    fprintf('Step60 partial shard complete. Full aggregate outputs are skipped until all scene files exist.\n');
    return;
end

[T_raw, T_stage] = merge_case_tables_local(prefix, all_scene_matrix, cfg);
summary = build_step17_summary_table(T_raw);
stage_summary = build_step17_stage_summary_table(T_stage);
coverage = build_coverage_table_local(T_raw, T_stage, all_scene_matrix, cfg, method_names, num_seeds);
assert_coverage_local(coverage, num_seeds);
decision = build_step60_decision_table_local(summary);

sig_dccw = compute_significance_matrix_local(T_raw, all_scene_matrix, cfg, ...
    "DCC-CBR-window", "Risk-constrained-v6");
sig_aoig = compute_significance_matrix_local(T_raw, all_scene_matrix, cfg, ...
    "AoI-greedy", "Risk-constrained-v6");
sig_h = compute_significance_matrix_local(T_raw, all_scene_matrix, cfg, ...
    "Confidence-heuristic", "Risk-constrained-v6");
sig_dccw = apply_familywise_holm_to_stats_table(sig_dccw);
sig_aoig = apply_familywise_holm_to_stats_table(sig_aoig);
sig_h = apply_familywise_holm_to_stats_table(sig_h);

writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage, prefix + "_stage_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(stage_summary, prefix + "_stage_summary.csv");
writetable(coverage, prefix + "_coverage.csv");
writetable(decision, prefix + "_decision_table.csv");
writetable(sig_dccw, prefix + "_dcc_cbr_window_vs_v6_significance.csv");
writetable(sig_aoig, prefix + "_aoi_greedy_vs_v6_significance.csv");
writetable(sig_h, prefix + "_heuristic_vs_v6_significance.csv");
write_step60_moderate_forest_geometry_report_cn(decision, coverage, ...
    sig_dccw, sig_aoig, sig_h, prefix + "_report_cn.md", num_seeds);

disp(decision);
disp(coverage);
fprintf('Step60 complete: ModerateForestGeometry validation generated with %d seeds.\n', num_seeds);

function [T_seed, T_stage_seed] = simulate_moderate_seed_local(scene_meta, scene_cfg, cfg, seed, method_names)
params = get_moderate_forest_geometry_mainline_params();
params.scenario_input = scene_cfg;
params.random_seed = seed;
params.physical_pdr_mode = "per_lookup";

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    run_step9_proposed_method(scenario, params), ...
    rename_result_local(run_step9_baseline_oracle(scenario, params), "Constrained Oracle"), ...
    run_step9_baseline_dcc_like(scenario, params), ...
    run_step9_baseline_aoi(scenario, params), ...
    run_step9_baseline_dcc_cbr_window(scenario, params), ...
    run_step9_baseline_aoi_greedy(scenario, params)};

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

function [T_raw, T_stage] = read_existing_case_tables_local(raw_path, stage_path)
if isfile(raw_path)
    T_raw = normalize_table_local(readtable(raw_path, 'TextType', 'string'));
else
    T_raw = [];
end

if isfile(stage_path)
    T_stage = normalize_table_local(readtable(stage_path, 'TextType', 'string'));
else
    T_stage = [];
end
end

function [T_raw, T_stage] = merge_case_tables_local(prefix, scene_matrix, cfg)
T_raw = [];
T_stage = [];
for scene_idx = 1:numel(scene_matrix)
    raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
    stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
    if ~isfile(raw_path) || ~isfile(stage_path)
        error('Missing Step60 case output: %s / %s', raw_path, stage_path);
    end
    T_raw = append_table_local(T_raw, normalize_table_local(readtable(raw_path, 'TextType', 'string')));
    T_stage = append_table_local(T_stage, normalize_table_local(readtable(stage_path, 'TextType', 'string')));
end
end

function ok = all_case_tables_exist_local(prefix, scene_matrix, cfg)
ok = true;
for scene_idx = 1:numel(scene_matrix)
    raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
    stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
    if ~isfile(raw_path) || ~isfile(stage_path)
        ok = false;
        return;
    end
end
end

function decision = build_step60_decision_table_local(summary)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];
for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    h = get_method_row_local(subT, "Confidence-heuristic");
    link = get_method_row_local(subT, "Link-delay-aware");
    oracle = get_method_row_local(subT, "Constrained Oracle");
    dccw = get_method_row_local(subT, "DCC-CBR-window");
    aoig = get_method_row_local(subT, "AoI-greedy");
    if isempty(v6)
        continue;
    end
    row = keys(i, :);
    row.V6Timely_pct = 100.0 * v6.TimelyRateMean;
    row.V6EmergencyTimely_pct = 100.0 * v6.EmergencyTimelyRateMean;
    row.V6Cost = v6.AvgTxCostMean;
    row.OracleEmergencyTimely_pct = safe_pct_metric_local(oracle, 'EmergencyTimelyRateMean');
    row.TimelyGainVsHeuristic_pp = safe_gain_local(v6, h, 'TimelyRateMean');
    row.EmgGainVsHeuristic_pp = safe_gain_local(v6, h, 'EmergencyTimelyRateMean');
    row.TimelyGainVsLink_pp = safe_gain_local(v6, link, 'TimelyRateMean');
    row.TimelyGainVsDCCWindow_pp = safe_gain_local(v6, dccw, 'TimelyRateMean');
    row.TimelyGainVsAoIGreedy_pp = safe_gain_local(v6, aoig, 'TimelyRateMean');
    row.ModerateForestDecision = classify_moderate_case_local(row);
    rows = append_table_local(rows, row);
end
decision = rows;
end

function value = safe_pct_metric_local(row, metric_name)
if isempty(row)
    value = NaN;
else
    value = 100.0 * row.(metric_name);
end
end

function value = safe_gain_local(v6, baseline, metric_name)
if isempty(baseline)
    value = NaN;
else
    value = 100.0 * (v6.(metric_name) - baseline.(metric_name));
end
end

function label = classify_moderate_case_local(row)
if row.OracleEmergencyTimely_pct < 10.0
    label = "ModerateHardEmergencyBoundary";
elseif row.V6EmergencyTimely_pct >= 50.0 && row.TimelyGainVsHeuristic_pp >= 1.0
    label = "ModerateEffective";
elseif row.TimelyGainVsHeuristic_pp >= 0.0 && row.EmgGainVsHeuristic_pp >= -0.1
    label = "ModerateNonnegative";
elseif row.TimelyGainVsHeuristic_pp >= -1.0
    label = "ModerateBoundary";
else
    label = "ModerateRisk";
end
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if height(row) > 1
    row = row(1, :);
end
end

function T_sig = compute_significance_matrix_local(T_raw, scene_matrix, cfg, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    T_case = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg, :);
    if isempty(T_case)
        continue;
    end
    T_case_sig = compute_step12_statistical_tests(T_case, baseline_name, proposed_name);
    T_case_sig.Scene = repmat(scene_id, height(T_case_sig), 1);
    T_case_sig.SceneRole = repmat(scene_matrix(scene_idx).scene_role, height(T_case_sig), 1);
    T_case_sig.Config = repmat(cfg, height(T_case_sig), 1);
    T_case_sig.BaselineMethod = repmat(baseline_name, height(T_case_sig), 1);
    T_case_sig.ProposedMethod = repmat(proposed_name, height(T_case_sig), 1);
    T_case_sig = movevars(T_case_sig, ...
        {'Scene','SceneRole','Config','BaselineMethod','ProposedMethod'}, 'Before', 'Metric');
    T_sig = append_table_local(T_sig, T_case_sig);
end
end

function coverage = build_coverage_table_local(T_raw, T_stage, scene_matrix, cfg, methods, num_seeds)
rows = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for method = methods
        raw_sub = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg & T_raw.Method == method, :);
        stage_sub = T_stage(T_stage.Scene == scene_id & T_stage.Config == cfg & T_stage.Method == method, :);
        row = table(scene_id, cfg, method, ...
            numel(unique(raw_sub.Seed)), numel(unique(stage_sub.Seed)), ...
            height(raw_sub), height(stage_sub), num_seeds, ...
            'VariableNames', {'Scene','Config','Method','RawSeeds','StageSeeds','RawRows','StageRows','ExpectedSeeds'});
        rows = append_table_local(rows, row);
    end
end
coverage = rows;
end

function assert_coverage_local(coverage, num_seeds)
bad = coverage(coverage.RawSeeds ~= num_seeds | coverage.StageSeeds ~= num_seeds, :);
if ~isempty(bad)
    disp(bad);
    error('Step60 coverage check failed.');
end
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage','BaselineMethod','ProposedMethod'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
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

function scene_matrix = filter_scene_matrix_local(scene_matrix, raw_filter)
if isempty(raw_filter)
    return;
end
requested = split(string(raw_filter), ",");
requested = strtrim(requested);
requested = requested(requested ~= "");
if isempty(requested)
    return;
end

scene_ids = string({scene_matrix.scene_id});
keep = ismember(scene_ids, requested);
missing = setdiff(requested, scene_ids, 'stable');
if ~isempty(missing)
    error('STEP60_SCENES contains unknown scene id(s): %s', strjoin(missing, ", "));
end
scene_matrix = scene_matrix(keep);
fprintf('Step60 scene filter active: %s\n', strjoin(string({scene_matrix.scene_id}), ", "));
end
