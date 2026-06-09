clc;
clear;
close all;

% Step54: final PER-lookup literature-baseline comparison.
% This script only simulates DCC-like and AoI-aware baselines, then merges
% them with frozen Step49/Step50 evidence for the existing four methods.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP54_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP54_PREFIX_TAG', ...
    "step54_literature_baselines_per_lookup_" + string(num_seeds) + "seed");
config_names = get_env_string_list_local('STEP54_CONFIGS', ["Default", "ForestGeometry"]);
method_names = ["DCC-like", "AoI-aware"];

main_prefix = "step49_per_lookup_final_validation_50seed";
heldout_prefix = "step50_per_lookup_heldout_validation_50seed";

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
        fprintf('Step54 resume: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_meta.scene_id, cfg, numel(existing_seeds), numel(missing_seeds));

        base_params = get_params_for_config_local(cfg);
        base_params.scenario_input = scene_cfg;
        base_params.physical_pdr_mode = "per_lookup";

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_literature_seed_local( ...
                scene_meta, cfg, seed, method_names, base_params);
            T_case_raw = append_table_local(T_case_raw, T_seed);
            T_case_stage = append_table_local(T_case_stage, T_stage_seed);
            writetable(T_case_raw, raw_path);
            writetable(T_case_stage, stage_path);
        end
    end
end

[T_lit_raw, T_lit_stage] = merge_case_tables_local(prefix, scene_matrix, config_names);
T_existing_raw = merge_existing_evidence_local(main_prefix, heldout_prefix, false, seed_list);
T_existing_stage = merge_existing_evidence_local(main_prefix, heldout_prefix, true, seed_list);

T_raw = append_table_local(T_existing_raw, T_lit_raw);
T_stage = append_table_local(T_existing_stage, T_lit_stage);
T_raw = normalize_table_local(T_raw);
T_stage = normalize_table_local(T_stage);

summary = build_step17_summary_table(T_raw);
stage_summary = build_step17_stage_summary_table(T_stage);
sig_dcc = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "DCC-like", "Risk-constrained-v6");
sig_aoi = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "AoI-aware", "Risk-constrained-v6");
sig_link = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "Link-delay-aware", "Risk-constrained-v6");
sig_heuristic = compute_significance_matrix_local(T_raw, scene_matrix, config_names, ...
    "Confidence-heuristic", "Risk-constrained-v6");

sig_dcc = apply_familywise_holm_to_stats_table(sig_dcc);
sig_aoi = apply_familywise_holm_to_stats_table(sig_aoi);
sig_link = apply_familywise_holm_to_stats_table(sig_link);
sig_heuristic = apply_familywise_holm_to_stats_table(sig_heuristic);

decision = build_step54_decision_table_local(summary);
coverage = build_coverage_table_local(T_raw, T_stage, scene_matrix, config_names, num_seeds);
assert_coverage_local(coverage, num_seeds);

writetable(T_lit_raw, prefix + "_literature_only_raw.csv");
writetable(T_lit_stage, prefix + "_literature_only_stage_raw.csv");
writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage, prefix + "_stage_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(stage_summary, prefix + "_stage_summary.csv");
writetable(sig_dcc, prefix + "_dcc_vs_v6_significance.csv");
writetable(sig_aoi, prefix + "_aoi_vs_v6_significance.csv");
writetable(sig_link, prefix + "_link_vs_v6_significance.csv");
writetable(sig_heuristic, prefix + "_heuristic_vs_v6_significance.csv");
writetable(decision, prefix + "_decision_table.csv");
writetable(coverage, prefix + "_coverage.csv");
write_step54_literature_baselines_report_cn(decision, coverage, ...
    sig_dcc, sig_aoi, prefix + "_report_cn.md", num_seeds);

disp(decision);
disp(coverage);
fprintf('Step54 complete: PER-lookup literature-baseline comparison generated with %d seeds.\n', num_seeds);

function [T_seed, T_stage_seed] = simulate_literature_seed_local(scene_meta, cfg, seed, method_names, base_params)
params = base_params;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_dcc_like(scenario, params), ...
    run_step9_baseline_aoi(scenario, params)};

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
    error('Unknown Step54 config: %s', cfg);
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
            error('Missing Step54 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table_local(T_raw, normalize_table_local(readtable(raw_path, 'TextType', 'string')));
        T_stage = append_table_local(T_stage, normalize_table_local(readtable(stage_path, 'TextType', 'string')));
    end
end
end

function T = merge_existing_evidence_local(main_prefix, heldout_prefix, is_stage, seed_list)
if is_stage
    suffix = "_stage_raw.csv";
else
    suffix = "_raw.csv";
end
paths = [main_prefix + suffix, heldout_prefix + suffix];
T = [];
for i = 1:numel(paths)
    if ~isfile(paths(i))
        error('Missing existing final PER lookup evidence: %s', paths(i));
    end
    T_part = normalize_table_local(readtable(paths(i), 'TextType', 'string'));
    T_part = T_part(ismember(T_part.Seed, seed_list), :);
    T = append_table_local(T, T_part);
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

function decision = build_step54_decision_table_local(summary)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];
for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    dcc = get_method_row_local(subT, "DCC-like");
    aoi = get_method_row_local(subT, "AoI-aware");
    h = get_method_row_local(subT, "Confidence-heuristic");
    link = get_method_row_local(subT, "Link-delay-aware");
    if isempty(v6) || isempty(dcc) || isempty(aoi)
        continue;
    end

    row = keys(i, :);
    row.TimelyGainVsDCC_pp = 100.0 * (v6.TimelyRateMean - dcc.TimelyRateMean);
    row.EmgGainVsDCC_pp = 100.0 * (v6.EmergencyTimelyRateMean - dcc.EmergencyTimelyRateMean);
    row.CostDeltaVsDCC_pct = pct_delta_local(v6.AvgTxCostMean, dcc.AvgTxCostMean);
    row.TimelyGainVsAoI_pp = 100.0 * (v6.TimelyRateMean - aoi.TimelyRateMean);
    row.EmgGainVsAoI_pp = 100.0 * (v6.EmergencyTimelyRateMean - aoi.EmergencyTimelyRateMean);
    row.CostDeltaVsAoI_pct = pct_delta_local(v6.AvgTxCostMean, aoi.AvgTxCostMean);
    row.TimelyGainVsHeuristic_pp = safe_gain_local(v6, h, 'TimelyRateMean');
    row.TimelyGainVsLink_pp = safe_gain_local(v6, link, 'TimelyRateMean');
    row.LiteratureBaselineDecision = classify_literature_case_local(row);
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

function label = classify_literature_case_local(row)
min_timely = min(row.TimelyGainVsDCC_pp, row.TimelyGainVsAoI_pp);
min_emg = min(row.EmgGainVsDCC_pp, row.EmgGainVsAoI_pp);
if min_timely >= 1.0 || min_emg >= 1.0
    label = "LiteratureStrong";
elseif min_timely >= 0.0 && min_emg >= -0.1
    label = "LiteratureNonnegative";
elseif min_timely >= -1.0 && min_emg >= -1.0
    label = "LiteratureBoundary";
else
    label = "LiteratureRisk";
end
end

function coverage = build_coverage_table_local(T_raw, T_stage, scene_matrix, config_names, num_seeds)
methods = ["Link-delay-aware", "Confidence-heuristic", "Risk-constrained-v6", ...
    "Constrained Oracle", "DCC-like", "AoI-aware"];
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
    error('Step54 coverage check failed.');
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
