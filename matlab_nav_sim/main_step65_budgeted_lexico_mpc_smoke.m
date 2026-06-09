clc;
clear;
close all;

% Step65: Budgeted lexicographic chance-constrained MPC side-copy.
% Candidate method only. It tests whether Step64's gains can be kept while
% reducing communication-cost inflation.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP65_NUM_SEEDS', 10);
prefix = get_env_string_local('STEP65_PREFIX_TAG', ...
    "step65_budgeted_lexico_mpc_smoke_" + string(num_seeds) + "seed");
cfg = "ModerateForestGeometry";
method_names = ["Link-delay-aware", "Risk-constrained-v6", "Lexico-Chance-MPC", ...
    "Budgeted-Lexico-MPC", "DCC-CBR-window", "AoI-greedy"];

all_scene_matrix = [get_paper_scene_matrix(), get_heldout_scene_matrix()];
scene_filter_raw = getenv('STEP65_SCENES');
run_scene_matrix = filter_scene_matrix_local(all_scene_matrix, scene_filter_raw);
seed_list = 1:num_seeds;

T_raw = [];
T_stage = [];
T_diag = [];

for scene_idx = 1:numel(run_scene_matrix)
    scene_meta = run_scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);
    fprintf('Step65: scene=%s config=%s seeds=%d\n', scene_meta.scene_id, cfg, num_seeds);

    for seed = seed_list
        [T_seed, T_stage_seed, T_diag_seed] = simulate_step65_seed_local( ...
            scene_meta, scene_cfg, cfg, seed, method_names);
        T_raw = append_table_local(T_raw, T_seed);
        T_stage = append_table_local(T_stage, T_stage_seed);
        T_diag = append_table_local(T_diag, T_diag_seed);
    end
end

summary = build_step17_summary_table(T_raw);
stage_summary = build_step17_stage_summary_table(T_stage);
decision = build_step65_decision_table_local(summary, T_diag);
sig_v6 = compute_step65_significance_local(T_raw, run_scene_matrix, cfg, ...
    "Risk-constrained-v6", "Budgeted-Lexico-MPC");
sig_step64 = compute_step65_significance_local(T_raw, run_scene_matrix, cfg, ...
    "Lexico-Chance-MPC", "Budgeted-Lexico-MPC");
sig_link = compute_step65_significance_local(T_raw, run_scene_matrix, cfg, ...
    "Link-delay-aware", "Budgeted-Lexico-MPC");
sig_v6 = apply_familywise_holm_to_stats_table(sig_v6);
sig_step64 = apply_familywise_holm_to_stats_table(sig_step64);
sig_link = apply_familywise_holm_to_stats_table(sig_link);

writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage, prefix + "_stage_raw.csv");
writetable(T_diag, prefix + "_diagnostics.csv");
writetable(summary, prefix + "_summary.csv");
writetable(stage_summary, prefix + "_stage_summary.csv");
writetable(decision, prefix + "_decision_table.csv");
writetable(sig_v6, prefix + "_v6_vs_budgeted_lexico_mpc_significance.csv");
writetable(sig_step64, prefix + "_step64_vs_budgeted_lexico_mpc_significance.csv");
writetable(sig_link, prefix + "_link_vs_budgeted_lexico_mpc_significance.csv");
write_step65_report_local(decision, sig_v6, sig_step64, prefix + "_report_cn.md", num_seeds);

disp(decision);
fprintf('Step65 complete: Budgeted-Lexico-MPC validation generated with %d seeds.\n', num_seeds);

function [T_seed, T_stage_seed, T_diag_seed] = simulate_step65_seed_local( ...
    scene_meta, scene_cfg, cfg, seed, method_names)

params = get_moderate_forest_geometry_mainline_params();
params.scenario_input = scene_cfg;
params.random_seed = seed;
params.physical_pdr_mode = "per_lookup";
params.step64_horizon = get_env_int_local('STEP65_HORIZON', 2);
params.step65_horizon = params.step64_horizon;
params.step65_safety_epsilon_band = get_env_double_local('STEP65_SAFETY_EPSILON_BAND', 0.020);

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_risk_constrained_v6(scenario, params), ...
    run_step9_lexico_chance_mpc_scheduler(scenario, params), ...
    run_step9_budgeted_lexico_chance_mpc_scheduler(scenario, params), ...
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

T_diag_seed = build_step65_diagnostics_row_local(scene_meta, cfg, seed, results{4});
end

function T = build_step65_diagnostics_row_local(scene_meta, cfg, seed, result)
policy = result.policy;
safety_viol = policy.constraint_violation_trace;
budget_viol = policy.budget_violation_trace;
feas = policy.feasible_sequence_ratio_trace;

T = table( ...
    scene_meta.scene_id, scene_meta.scene_role, scene_meta.geometry_type, ...
    scene_meta.density_class, scene_meta.vegetation_class, cfg, seed, ...
    mean(safety_viol > 1.0e-9), mean(safety_viol, 'omitnan'), max(safety_viol), ...
    mean(budget_viol > 1.0e-9), mean(budget_viol, 'omitnan'), max(budget_viol), ...
    mean(feas, 'omitnan'), mean(policy.no_feasible_sequence_trace), ...
    mean(policy.aoi_age_trace, 'omitnan'), ...
    'VariableNames', {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Seed','SafetyViolationRate','MeanSafetyViolation','MaxSafetyViolation', ...
    'BudgetViolationRate','MeanBudgetViolation','MaxBudgetViolation', ...
    'MeanFeasibleSequenceRatio','NoFeasibleSequenceRate','MeanAoIAge'});
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

function decision = build_step65_decision_table_local(summary, T_diag)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];
for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    bmpc = get_method_row_local(subT, "Budgeted-Lexico-MPC");
    mpc = get_method_row_local(subT, "Lexico-Chance-MPC");
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    link = get_method_row_local(subT, "Link-delay-aware");
    dsub = T_diag(T_diag.Scene == keys.Scene(i) & T_diag.Config == keys.Config(i), :);
    if isempty(bmpc)
        continue;
    end

    row = keys(i, :);
    row.BudgetedTimely_pct = 100.0 * bmpc.TimelyRateMean;
    row.BudgetedEmgTimely_pct = 100.0 * bmpc.EmergencyTimelyRateMean;
    row.BudgetedCost = bmpc.AvgTxCostMean;
    row.TimelyGainVsV6_pp = safe_gain_local(bmpc, v6, 'TimelyRateMean');
    row.EmgGainVsV6_pp = safe_gain_local(bmpc, v6, 'EmergencyTimelyRateMean');
    row.CostDeltaVsV6 = safe_raw_delta_local(bmpc, v6, 'AvgTxCostMean');
    row.TimelyDeltaVsStep64_pp = safe_gain_local(bmpc, mpc, 'TimelyRateMean');
    row.EmgDeltaVsStep64_pp = safe_gain_local(bmpc, mpc, 'EmergencyTimelyRateMean');
    row.CostReductionVsStep64 = -safe_raw_delta_local(bmpc, mpc, 'AvgTxCostMean');
    row.TimelyGainVsLink_pp = safe_gain_local(bmpc, link, 'TimelyRateMean');
    row.SafetyViolationRate_pct = 100.0 * mean(dsub.SafetyViolationRate, 'omitnan');
    row.BudgetViolationRate_pct = 100.0 * mean(dsub.BudgetViolationRate, 'omitnan');
    row.NoFeasibleSequenceRate_pct = 100.0 * mean(dsub.NoFeasibleSequenceRate, 'omitnan');
    row.Decision = classify_step65_case_local(row);
    rows = append_table_local(rows, row);
end
decision = rows;
end

function label = classify_step65_case_local(row)
if row.CostReductionVsStep64 > 0.20 && row.TimelyGainVsV6_pp >= 0.0 && row.EmgGainVsV6_pp >= -0.2
    label = "BudgetImprovedCandidate";
elseif row.CostReductionVsStep64 > 0.20 && row.TimelyGainVsV6_pp >= -0.2
    label = "BudgetImprovedButRisky";
elseif row.TimelyGainVsV6_pp >= 0.5 && row.EmgGainVsV6_pp >= -0.2 && row.CostDeltaVsV6 <= 0.30
    label = "PromisingCandidate";
else
    label = "NoClearBudgetBenefit";
end
end

function T_sig = compute_step65_significance_local(T_raw, scene_matrix, cfg, baseline_name, proposed_name)
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

function write_step65_report_local(decision, sig_v6, sig_step64, out_path, num_seeds)
fid = fopen(out_path, 'w');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '# Step65 Budgeted-Lexico-MPC 副本检验报告\n\n');
fprintf(fid, '本步骤为候选方法副本检验，不替换 Risk-constrained-v6 主线。\n\n');
fprintf(fid, '## 运行规模\n\n');
fprintf(fid, '- Seeds: %d\n', num_seeds);
fprintf(fid, '- Config: ModerateForestGeometry\n');
fprintf(fid, '- Candidate: Budgeted-Lexico-MPC\n\n');
fprintf(fid, '## 判定结果\n\n');
for i = 1:height(decision)
    fprintf(fid, '- Scene %s: %s, TimelyGainVsV6=%.3f pp, EmgGainVsV6=%.3f pp, CostDeltaVsV6=%.3f, CostReductionVsStep64=%.3f\n', ...
        decision.Scene(i), decision.Decision(i), decision.TimelyGainVsV6_pp(i), ...
        decision.EmgGainVsV6_pp(i), decision.CostDeltaVsV6(i), decision.CostReductionVsStep64(i));
end
fprintf(fid, '\n## 统计检验\n\n');
fprintf(fid, 'V6 对比统计行数: %d\n', height(sig_v6));
fprintf(fid, 'Step64 对比统计行数: %d\n', height(sig_step64));
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if height(row) > 1
    row = row(1, :);
end
end

function value = safe_gain_local(candidate, baseline, metric_name)
if isempty(baseline)
    value = NaN;
else
    value = 100.0 * (candidate.(metric_name) - baseline.(metric_name));
end
end

function value = safe_raw_delta_local(candidate, baseline, metric_name)
if isempty(baseline)
    value = NaN;
else
    value = candidate.(metric_name) - baseline.(metric_name);
end
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

function value = get_env_int_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    parsed = str2double(raw);
    if isnan(parsed)
        error('Environment variable %s must be numeric.', name);
    end
    value = round(parsed);
end
end

function value = get_env_double_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = str2double(raw);
    if isnan(value)
        error('Environment variable %s must be numeric.', name);
    end
end
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = string(default_value);
else
    value = string(raw);
end
end

function scene_matrix = filter_scene_matrix_local(scene_matrix, raw_filter)
if isempty(raw_filter)
    return;
end
wanted = split(string(raw_filter), ",");
wanted = strtrim(wanted);
keep = false(size(scene_matrix));
for i = 1:numel(scene_matrix)
    keep(i) = any(scene_matrix(i).scene_id == wanted);
end
scene_matrix = scene_matrix(keep);
end
