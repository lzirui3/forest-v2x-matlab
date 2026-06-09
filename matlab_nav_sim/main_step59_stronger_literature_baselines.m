clc;
clear;
close all;

% Step59: strengthened literature-inspired baselines under PER lookup.
% This step adds DCC-CBR-window and AoI-greedy baselines, then merges them
% with frozen Step54 evidence. It does not overwrite Step54-58 outputs or
% retune Risk-constrained-v6.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP59_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP59_PREFIX_TAG', ...
    "step59_stronger_literature_baselines_" + string(num_seeds) + "seed");
config_names = get_env_string_list_local('STEP59_CONFIGS', ["Default", "ForestGeometry"]);
method_names = ["DCC-CBR-window", "AoI-greedy"];
all_methods = ["Link-delay-aware", "Confidence-heuristic", "Risk-constrained-v6", ...
    "Constrained Oracle", "DCC-like", "AoI-aware", "DCC-CBR-window", "AoI-greedy"];

scene_matrix = [get_paper_scene_matrix(), get_heldout_scene_matrix()];
seed_list = 1:num_seeds;

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_meta.scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg);
        [T_case_raw, T_case_stage] = read_existing_case_tables_local(raw_path, stage_path);

        if isempty(T_case_raw)
            existing_seeds = [];
        else
            existing_seeds = unique(T_case_raw.Seed).';
        end
        missing_seeds = setdiff(seed_list, existing_seeds, 'stable');
        fprintf('Step59 resume: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_meta.scene_id, cfg, numel(existing_seeds), numel(missing_seeds));

        base_params = get_params_for_config_local(cfg);
        base_params.scenario_input = scene_cfg;
        base_params.physical_pdr_mode = "per_lookup";

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_stronger_seed_local( ...
                scene_meta, cfg, seed, method_names, base_params);
            T_case_raw = append_table_local(T_case_raw, T_seed);
            T_case_stage = append_table_local(T_case_stage, T_stage_seed);
            writetable(T_case_raw, raw_path);
            writetable(T_case_stage, stage_path);
        end
    end
end

[T_strong_raw, T_strong_stage] = merge_case_tables_local(prefix, scene_matrix, config_names);
T_step54_raw = normalize_table_local(readtable("step54_literature_baselines_per_lookup_50seed_raw.csv", 'TextType', 'string'));
T_step54_stage = normalize_table_local(readtable("step54_literature_baselines_per_lookup_50seed_stage_raw.csv", 'TextType', 'string'));
T_step54_raw = T_step54_raw(ismember(T_step54_raw.Seed, seed_list), :);
T_step54_stage = T_step54_stage(ismember(T_step54_stage.Seed, seed_list), :);

T_raw = normalize_table_local(append_table_local(T_step54_raw, T_strong_raw));
T_stage = normalize_table_local(append_table_local(T_step54_stage, T_strong_stage));

summary = build_step17_summary_table(T_raw);
stage_summary = build_step17_stage_summary_table(T_stage);
sig_dcc_window = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "DCC-CBR-window", "Risk-constrained-v6");
sig_aoi_greedy = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "AoI-greedy", "Risk-constrained-v6");
sig_dcc_window = apply_familywise_holm_to_stats_table(sig_dcc_window);
sig_aoi_greedy = apply_familywise_holm_to_stats_table(sig_aoi_greedy);

decision = build_step59_decision_table_local(summary);
coverage = build_coverage_table_local(T_raw, T_stage, scene_matrix, config_names, all_methods, num_seeds);
assert_coverage_local(coverage, num_seeds);

writetable(T_strong_raw, prefix + "_stronger_only_raw.csv");
writetable(T_strong_stage, prefix + "_stronger_only_stage_raw.csv");
writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage, prefix + "_stage_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(stage_summary, prefix + "_stage_summary.csv");
writetable(sig_dcc_window, prefix + "_dcc_cbr_window_vs_v6_significance.csv");
writetable(sig_aoi_greedy, prefix + "_aoi_greedy_vs_v6_significance.csv");
writetable(decision, prefix + "_decision_table.csv");
writetable(coverage, prefix + "_coverage.csv");
write_step59_stronger_literature_baselines_report_cn(decision, coverage, ...
    sig_dcc_window, sig_aoi_greedy, prefix + "_report_cn.md", num_seeds);

disp(decision);
disp(coverage);
fprintf('Step59 complete: strengthened literature baselines generated with %d seeds.\n', num_seeds);

function [T_seed, T_stage_seed] = simulate_stronger_seed_local(scene_meta, cfg, seed, method_names, base_params)
params = base_params;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
results = { ...
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

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step59 config: %s', cfg);
end
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

function [T_raw, T_stage] = merge_case_tables_local(prefix, scene_matrix, config_names)
T_raw = [];
T_stage = [];
for scene_idx = 1:numel(scene_matrix)
    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing Step59 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table_local(T_raw, normalize_table_local(readtable(raw_path, 'TextType', 'string')));
        T_stage = append_table_local(T_stage, normalize_table_local(readtable(stage_path, 'TextType', 'string')));
    end
end
end

function T_sig = compute_significance_matrix_local(T_raw, scene_matrix, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
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
end

function decision = build_step59_decision_table_local(summary)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];
for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    dccw = get_method_row_local(subT, "DCC-CBR-window");
    aoig = get_method_row_local(subT, "AoI-greedy");
    dcc = get_method_row_local(subT, "DCC-like");
    aoi = get_method_row_local(subT, "AoI-aware");
    h = get_method_row_local(subT, "Confidence-heuristic");
    link = get_method_row_local(subT, "Link-delay-aware");
    if isempty(v6) || isempty(dccw) || isempty(aoig)
        continue;
    end

    row = keys(i, :);
    row.TimelyGainVsDCCWindow_pp = 100.0 * (v6.TimelyRateMean - dccw.TimelyRateMean);
    row.EmgGainVsDCCWindow_pp = 100.0 * (v6.EmergencyTimelyRateMean - dccw.EmergencyTimelyRateMean);
    row.CostDeltaVsDCCWindow_pct = pct_delta_local(v6.AvgTxCostMean, dccw.AvgTxCostMean);
    row.TimelyGainVsAoIGreedy_pp = 100.0 * (v6.TimelyRateMean - aoig.TimelyRateMean);
    row.EmgGainVsAoIGreedy_pp = 100.0 * (v6.EmergencyTimelyRateMean - aoig.EmergencyTimelyRateMean);
    row.CostDeltaVsAoIGreedy_pct = pct_delta_local(v6.AvgTxCostMean, aoig.AvgTxCostMean);
    row.TimelyGainVsDCCLike_pp = safe_gain_local(v6, dcc, 'TimelyRateMean');
    row.TimelyGainVsAoIAware_pp = safe_gain_local(v6, aoi, 'TimelyRateMean');
    row.TimelyGainVsHeuristic_pp = safe_gain_local(v6, h, 'TimelyRateMean');
    row.TimelyGainVsLink_pp = safe_gain_local(v6, link, 'TimelyRateMean');
    row.StrongerBaselineDecision = classify_stronger_case_local(row);
    rows = append_table_local(rows, row);
end
decision = rows;
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if height(row) > 1
    row = row(1, :);
end
end

function value = safe_gain_local(v6, baseline, metric_name)
if isempty(baseline)
    value = NaN;
else
    value = 100.0 * (v6.(metric_name) - baseline.(metric_name));
end
end

function label = classify_stronger_case_local(row)
min_timely = min(row.TimelyGainVsDCCWindow_pp, row.TimelyGainVsAoIGreedy_pp);
min_emg = min(row.EmgGainVsDCCWindow_pp, row.EmgGainVsAoIGreedy_pp);
if min_timely >= 1.0 || min_emg >= 1.0
    label = "StrongerBaselineGain";
elseif min_timely >= 0.0 && min_emg >= -0.1
    label = "StrongerBaselineNonnegative";
elseif min_timely >= -1.0 && min_emg >= -1.0
    label = "StrongerBaselineBoundary";
else
    label = "StrongerBaselineRisk";
end
end

function coverage = build_coverage_table_local(T_raw, T_stage, scene_matrix, config_names, methods, num_seeds)
rows = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
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
end
coverage = rows;
end

function assert_coverage_local(coverage, num_seeds)
bad = coverage(coverage.RawSeeds ~= num_seeds | coverage.StageSeeds ~= num_seeds, :);
if ~isempty(bad)
    disp(bad);
    error('Step59 coverage check failed.');
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

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
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

function values = get_env_string_list_local(name, default_values)
raw = getenv(name);
if isempty(raw)
    values = string(default_values);
else
    parts = split(string(raw), ',');
    values = strtrim(parts(:)).';
    values = values(strlength(values) > 0);
end
end
