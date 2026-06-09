clc;
clear;
close all;

% Step55: final statistical evidence closure.
% Read the final integrated PER-lookup evidence from Step54 and generate
% paired tests for all review-relevant baselines.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step55_final_statistical_evidence";
input_prefix = get_env_string_local('STEP55_INPUT_PREFIX', ...
    "step54_literature_baselines_per_lookup_50seed");

raw_path = input_prefix + "_raw.csv";
stage_path = input_prefix + "_stage_raw.csv";
coverage_path = input_prefix + "_coverage.csv";
if ~isfile(raw_path) || ~isfile(stage_path)
    error('Missing Step54 integrated evidence: %s / %s', raw_path, stage_path);
end

T_raw = normalize_table_local(readtable(raw_path, 'TextType', 'string'));
T_stage = normalize_table_local(readtable(stage_path, 'TextType', 'string'));
coverage = normalize_table_local(readtable(coverage_path, 'TextType', 'string'));

scene_table = unique(T_raw(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass'}), ...
    'rows', 'stable');
config_names = unique(T_raw.Config, 'stable');
comparisons = [
    "DCC-like", "Risk-constrained-v6";
    "AoI-aware", "Risk-constrained-v6";
    "Link-delay-aware", "Risk-constrained-v6";
    "Confidence-heuristic", "Risk-constrained-v6";
    "Risk-constrained-v6", "Constrained Oracle"];

T_sig = [];
for i = 1:size(comparisons, 1)
    T_part = compute_significance_matrix_local(T_raw, scene_table, config_names, ...
        comparisons(i, 1), comparisons(i, 2));
    T_sig = append_table_local(T_sig, T_part);
end
T_sig = apply_familywise_holm_to_stats_table(T_sig);

T_stage_sig = [];
for i = 1:size(comparisons, 1)
    T_part = compute_stage_significance_matrix_local(T_stage, scene_table, config_names, ...
        "PosDeg_Emerg", comparisons(i, 1), comparisons(i, 2));
    T_stage_sig = append_table_local(T_stage_sig, T_part);
end
T_stage_sig = apply_familywise_holm_to_stats_table(T_stage_sig);

T_core = build_core_result_table_local(T_raw);
T_interpretation = build_interpretation_table_local(T_sig);
assert_statistical_coverage_local(T_raw, comparisons);

writetable(T_core, prefix + "_core_results.csv");
writetable(T_sig, prefix + "_all_comparisons_significance.csv");
writetable(T_stage_sig, prefix + "_posdeg_emerg_significance.csv");
writetable(T_interpretation, prefix + "_interpretation_table.csv");
writetable(coverage, prefix + "_input_coverage_copy.csv");
write_step55_final_statistics_report_cn(T_core, T_sig, T_stage_sig, ...
    T_interpretation, coverage, prefix + "_report_cn.md");

disp(T_interpretation);
fprintf('Step55 complete: final statistical evidence generated from %s.\n', input_prefix);

function T_sig = compute_significance_matrix_local(T_raw, scene_table, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:height(scene_table)
    scene_id = scene_table.Scene(scene_idx);
    for cfg = config_names.'
        T_case = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg, :);
        if isempty(T_case)
            continue;
        end
        T_case_sig = compute_step12_statistical_tests(T_case, baseline_name, proposed_name);
        T_case_sig.Scene = repmat(scene_id, height(T_case_sig), 1);
        T_case_sig.SceneRole = repmat(scene_table.SceneRole(scene_idx), height(T_case_sig), 1);
        T_case_sig.GeometryType = repmat(scene_table.GeometryType(scene_idx), height(T_case_sig), 1);
        T_case_sig.Config = repmat(cfg, height(T_case_sig), 1);
        T_case_sig.BaselineMethod = repmat(baseline_name, height(T_case_sig), 1);
        T_case_sig.ProposedMethod = repmat(proposed_name, height(T_case_sig), 1);
        T_case_sig = movevars(T_case_sig, ...
            {'Scene','SceneRole','GeometryType','Config','BaselineMethod','ProposedMethod'}, 'Before', 'Metric');
        T_sig = append_table_local(T_sig, T_case_sig);
    end
end
end

function T_sig = compute_stage_significance_matrix_local(T_stage, scene_table, config_names, stage_name, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:height(scene_table)
    scene_id = scene_table.Scene(scene_idx);
    for cfg = config_names.'
        T_case = T_stage(T_stage.Scene == scene_id & T_stage.Config == cfg & T_stage.Stage == stage_name, :);
        if isempty(T_case)
            continue;
        end
        T_case_sig = compute_step12_statistical_tests(T_case, baseline_name, proposed_name);
        T_case_sig.Scene = repmat(scene_id, height(T_case_sig), 1);
        T_case_sig.SceneRole = repmat(scene_table.SceneRole(scene_idx), height(T_case_sig), 1);
        T_case_sig.GeometryType = repmat(scene_table.GeometryType(scene_idx), height(T_case_sig), 1);
        T_case_sig.Config = repmat(cfg, height(T_case_sig), 1);
        T_case_sig.Stage = repmat(stage_name, height(T_case_sig), 1);
        T_case_sig.BaselineMethod = repmat(baseline_name, height(T_case_sig), 1);
        T_case_sig.ProposedMethod = repmat(proposed_name, height(T_case_sig), 1);
        T_case_sig = movevars(T_case_sig, ...
            {'Scene','SceneRole','GeometryType','Config','Stage','BaselineMethod','ProposedMethod'}, 'Before', 'Metric');
        T_sig = append_table_local(T_sig, T_case_sig);
    end
end
end

function T_core = build_core_result_table_local(T_raw)
summary = build_step17_summary_table(T_raw);
T_core = summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Method','TimelyRateMean','TimelyRateCI95','EmergencyTimelyRateMean', ...
    'EmergencyTimelyRateCI95','LossRateMean','LossRateCI95','AvgDelayMean', ...
    'AvgDelayCI95','AvgTxCostMean','AvgTxCostCI95'});
end

function T = build_interpretation_table_local(T_sig)
rows = [];
keys = unique(T_sig(:, {'Scene','SceneRole','GeometryType','Config','BaselineMethod','ProposedMethod'}), ...
    'rows', 'stable');
for i = 1:height(keys)
    subT = T_sig(T_sig.Scene == keys.Scene(i) & T_sig.Config == keys.Config(i) ...
        & T_sig.BaselineMethod == keys.BaselineMethod(i) ...
        & T_sig.ProposedMethod == keys.ProposedMethod(i), :);
    timely = get_metric_local(subT, "TimelyRate");
    emg = get_metric_local(subT, "EmgTimely");
    cost = get_metric_local(subT, "AvgTxCost");
    row = keys(i, :);
    row.TimelyDelta_pp = get_delta_pct_local(timely);
    row.TimelyHolmP = get_p_display_local(timely);
    row.TimelyEffectRBC = get_effect_local(timely);
    row.EmgDelta_pp = get_delta_pct_local(emg);
    row.CostDelta_pct = get_delta_pct_local(cost);
    row.PracticalClass = classify_practical_local(row.TimelyDelta_pp, row.EmgDelta_pp, row.CostDelta_pct);
    rows = append_table_local(rows, row);
end
T = rows;
end

function row = get_metric_local(T, metric_name)
row = T(T.Metric == metric_name, :);
if height(row) > 1
    row = row(1, :);
end
end

function value = get_delta_pct_local(row)
if isempty(row)
    value = NaN;
else
    value = row.DeltaPct(1);
end
end

function value = get_p_display_local(row)
if isempty(row)
    value = "NA";
else
    value = row.P_Value_Holm_Display(1);
end
end

function value = get_effect_local(row)
if isempty(row)
    value = NaN;
else
    value = row.EffectSize_RBC(1);
end
end

function label = classify_practical_local(timely_pp, emg_pp, cost_pct)
if timely_pp >= 1.0 || emg_pp >= 1.0
    if cost_pct <= 15.0
        label = "MeaningfulGain";
    else
        label = "CostlyGain";
    end
elseif timely_pp >= 0.0 && emg_pp >= -0.1
    label = "WeakNonnegative";
elseif timely_pp >= -1.0 && emg_pp >= -1.0
    label = "Boundary";
else
    label = "Risk";
end
end

function assert_statistical_coverage_local(T_raw, comparisons)
for i = 1:size(comparisons, 1)
    for method = comparisons(i, :)
        if ~any(T_raw.Method == method)
            error('Missing method in Step55 input: %s', method);
        end
    end
end
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage','BaselineMethod','ProposedMethod', ...
    'Metric','PracticalNote','PracticalClass','Significant','Significant_Holm'};
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
