clc;
clear;
close all;

% Step37 targeted validation for cost-calibrated emergency-safe v5.

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);

base_dir = 'D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim';
cd(base_dir);

num_seeds = get_num_seeds_from_env(5);
prefix = "step37_risk_constrained_v5_targeted_" + string(num_seeds) + "seed";
seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
target_cases = build_target_cases();
method_names = ["Confidence-heuristic", "V4Cost0060", "Risk-constrained-v5"];

rows = [];
stage_rows = [];
policy_rows = [];

for case_idx = 1:numel(target_cases)
    target = target_cases(case_idx);
    scene_meta = get_scene_meta(scene_matrix, target.scene_id);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for seed = seed_list
        fprintf('Step37 v5 targeted: scene=%s config=%s seed=%d/%d\n', ...
            target.scene_id, target.config, seed, num_seeds);
        [T_seed, T_stage_seed, T_policy_seed] = simulate_step37_case_seed( ...
            scene_meta, scene_cfg, target.config, seed, method_names);
        rows = append_table(rows, T_seed);
        stage_rows = append_table(stage_rows, T_stage_seed);
        policy_rows = append_table(policy_rows, T_policy_seed);
    end
end

T_summary = build_step17_summary_table(rows);
T_stage_summary = build_step17_stage_summary_table(stage_rows);
T_policy_summary = build_step37_policy_summary_table(policy_rows);
T_decision = build_step37_decision_table(T_summary);
T_score = build_step37_score_table(T_decision);

writetable(rows, prefix + "_raw.csv");
writetable(stage_rows, prefix + "_stage_raw.csv");
writetable(policy_rows, prefix + "_policy_raw.csv");
writetable(T_summary, prefix + "_summary.csv");
writetable(T_stage_summary, prefix + "_stage_summary.csv");
writetable(T_policy_summary, prefix + "_policy_summary.csv");
writetable(T_decision, prefix + "_decision_table.csv");
writetable(T_score, prefix + "_score.csv");
write_step37_report(T_decision, T_score, T_policy_summary, prefix + "_report.md");

disp(T_decision);
disp(T_score);
fprintf('Step 37 complete: v5 targeted validation generated with %d seeds.\n', num_seeds);

function num_seeds = get_num_seeds_from_env(default_value)
env_value = str2double(getenv('STEP37_NUM_SEEDS'));
if isnan(env_value) || env_value < 1
    num_seeds = default_value;
else
    num_seeds = round(env_value);
end
end

function target_cases = build_target_cases()
target_cases(1).scene_id = "10017";
target_cases(1).config = "Default";
target_cases(2).scene_id = "10017";
target_cases(2).config = "ForestGeometry";
target_cases(3).scene_id = "10019";
target_cases(3).config = "ForestGeometry";
end

function scene_meta = get_scene_meta(scene_matrix, scene_id)
for i = 1:numel(scene_matrix)
    if scene_matrix(i).scene_id == scene_id
        scene_meta = scene_matrix(i);
        return;
    end
end
error('Unknown Step37 scene id: %s', scene_id);
end

function [T_seed, T_stage_seed, T_policy_seed] = simulate_step37_case_seed( ...
    scene_meta, scene_cfg, cfg_name, seed, method_names)
if cfg_name == "Default"
    params = get_default_step9_mainline_params();
else
    params = get_forest_geometry_mainline_params();
end

params.scenario_input = scene_cfg;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
v4_params = params;
v4_params.risk_v4_actual_cost_weight = 0.060;

results = { ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    rename_result(run_step9_confidence_driven_risk_constrained_v4(scenario, v4_params), "V4Cost0060"), ...
    run_step9_confidence_driven_risk_constrained_v5(scenario, params)};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_step37_meta_columns(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_step37_meta_columns(T_stage_seed, scene_meta, cfg_name, seed);

T_policy_seed = build_step37_policy_table(scenario, results);
T_policy_seed = add_step37_meta_columns(T_policy_seed, scene_meta, cfg_name, seed);
end

function result = rename_result(result, name)
result.name = name;
end

function T = add_step37_meta_columns(T, scene_meta, cfg_name, seed)
T.Scene = repmat(scene_meta.scene_id, height(T), 1);
T.SceneRole = repmat(scene_meta.scene_role, height(T), 1);
T.GeometryType = repmat(scene_meta.geometry_type, height(T), 1);
T.DensityClass = repmat(scene_meta.density_class, height(T), 1);
T.VegetationClass = repmat(scene_meta.vegetation_class, height(T), 1);
T.Config = repmat(cfg_name, height(T), 1);
T.Seed = repmat(seed, height(T), 1);
T = movevars(T, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, ...
    'Before', 'Method');
end

function T_policy = build_step37_policy_table(scenario, results)
rows = [];
idx_emg = scenario.msg_type == "emergency";

for i = 1:numel(results)
    result = results{i};
    policy = result.policy;
    emergency_guard_share = NaN;
    if isfield(policy, 'selection_reason')
        emergency_guard_share = mean(policy.selection_reason == "emergency_guard");
    end
    row = table(string(result.name), mean(policy.mode == 0), mean(policy.mode == 1), ...
        mean(policy.mode == 2), mean(policy.priority), mean(policy.tx_rate), ...
        mean(policy.priority(idx_emg)), mean(policy.tx_rate(idx_emg)), emergency_guard_share, ...
        'VariableNames', {'Method','DirectShare','RedundantShare','RelayShare', ...
        'AvgPriority','AvgTxRate','EmergencyAvgPriority','EmergencyAvgTxRate', ...
        'EmergencyGuardShare'});
    rows = append_table(rows, row);
end

T_policy = rows;
end

function T_summary = build_step37_policy_summary_table(T_raw)
keys = unique(T_raw(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method'}), ...
    'rows', 'stable');
rows = [];

for i = 1:height(keys)
    subT = T_raw(T_raw.Scene == keys.Scene(i) & T_raw.Config == keys.Config(i) ...
        & T_raw.Method == keys.Method(i), :);
    row = table(keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), ...
        keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), keys.Method(i), ...
        mean(subT.DirectShare, 'omitnan'), mean(subT.RedundantShare, 'omitnan'), ...
        mean(subT.RelayShare, 'omitnan'), mean(subT.AvgPriority, 'omitnan'), ...
        mean(subT.AvgTxRate, 'omitnan'), mean(subT.EmergencyAvgPriority, 'omitnan'), ...
        mean(subT.EmergencyAvgTxRate, 'omitnan'), mean(subT.EmergencyGuardShare, 'omitnan'), ...
        'VariableNames', {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
        'Config','Method','DirectShareMean','RedundantShareMean','RelayShareMean', ...
        'AvgPriorityMean','AvgTxRateMean','EmergencyAvgPriorityMean','EmergencyAvgTxRateMean', ...
        'EmergencyGuardShareMean'});
    rows = append_table(rows, row);
end

T_summary = rows;
end

function T_decision = build_step37_decision_table(T_summary)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
methods = ["V4Cost0060", "Risk-constrained-v5"];
rows = [];

for i = 1:height(keys)
    mask = T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i);
    subT = T_summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    if isempty(h) || isnan(h.TimelyRateMean)
        continue;
    end

    for j = 1:numel(methods)
        r = subT(subT.Method == methods(j), :);
        if isempty(r) || isnan(r.TimelyRateMean)
            continue;
        end

        timely_gap_pp = 100.0 * (r.TimelyRateMean - h.TimelyRateMean);
        emg_gap_pp = 100.0 * (r.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
        cost_delta_pct = 100.0 * (r.AvgTxCostMean - h.AvgTxCostMean) / max(abs(h.AvgTxCostMean), 1.0e-12);
        delay_delta_pct = 100.0 * (r.AvgDelayMean - h.AvgDelayMean) / max(abs(h.AvgDelayMean), 1.0e-12);

        row = table(keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), ...
            keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), methods(j), ...
            h.TimelyRateMean, r.TimelyRateMean, timely_gap_pp, ...
            h.EmergencyTimelyRateMean, r.EmergencyTimelyRateMean, emg_gap_pp, ...
            h.AvgTxCostMean, r.AvgTxCostMean, cost_delta_pct, ...
            h.AvgDelayMean, r.AvgDelayMean, delay_delta_pct, ...
            'VariableNames', {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
            'Config','Method','HeuristicTimely','MethodTimely','MethodMinusHeuristicTimely_pp', ...
            'HeuristicEmgTimely','MethodEmgTimely','MethodMinusHeuristicEmg_pp', ...
            'HeuristicTxCost','MethodTxCost','MethodCostDeltaPct', ...
            'HeuristicDelay','MethodDelay','MethodDelayDeltaPct'});
        rows = append_table(rows, row);
    end
end

T_decision = rows;
end

function T_score = build_step37_score_table(T_decision)
methods = unique(T_decision.Method, 'stable');
rows = [];

for i = 1:numel(methods)
    name = methods(i);
    T = T_decision(T_decision.Method == name, :);
    default_10017 = T(T.Scene == "10017" & T.Config == "Default", :);
    forest_10017 = T(T.Scene == "10017" & T.Config == "ForestGeometry", :);
    forest_10019 = T(T.Scene == "10019" & T.Config == "ForestGeometry", :);

    mean_timely = mean(T.MethodMinusHeuristicTimely_pp, 'omitnan');
    mean_emg = mean(T.MethodMinusHeuristicEmg_pp, 'omitnan');
    mean_cost = mean(T.MethodCostDeltaPct, 'omitnan');
    max_cost = max(T.MethodCostDeltaPct);
    min_timely = min(T.MethodMinusHeuristicTimely_pp);
    min_emg = min(T.MethodMinusHeuristicEmg_pp);

    emg_guard = scalar_or_false(default_10017.MethodMinusHeuristicEmg_pp >= -0.25);
    cost_guard = scalar_or_false(forest_10017.MethodCostDeltaPct <= 30.0);
    boundary_guard = scalar_or_false(forest_10019.MethodMinusHeuristicTimely_pp >= -0.50 ...
        && forest_10019.MethodMinusHeuristicEmg_pp >= -0.50);
    timely_guard = min_timely >= -0.50;

    if emg_guard && cost_guard && boundary_guard && timely_guard
        status = "Step37Candidate";
    elseif timely_guard && boundary_guard
        status = "NeedsCalibration";
    else
        status = "Reject";
    end

    score = mean_timely + 0.5 * mean_emg ...
        - 0.03 * max(mean_cost, 0.0) ...
        - 0.02 * max(max_cost - 30.0, 0.0) ...
        - 2.0 * max(-0.25 - safe_scalar(default_10017.MethodMinusHeuristicEmg_pp), 0.0);

    row = table(name, mean_timely, mean_emg, mean_cost, max_cost, min_timely, min_emg, ...
        safe_scalar(default_10017.MethodMinusHeuristicEmg_pp), ...
        safe_scalar(forest_10017.MethodCostDeltaPct), ...
        safe_scalar(forest_10019.MethodMinusHeuristicTimely_pp), ...
        safe_scalar(forest_10019.MethodMinusHeuristicEmg_pp), ...
        emg_guard, cost_guard, boundary_guard, timely_guard, score, string(status), ...
        'VariableNames', {'Method','MeanTimelyDelta_pp','MeanEmgDelta_pp','MeanCostDeltaPct', ...
        'MaxCostDeltaPct','MinTimelyDelta_pp','MinEmgDelta_pp', ...
        'Scene10017DefaultEmgDelta_pp','Scene10017ForestCostDeltaPct', ...
        'Scene10019ForestTimelyDelta_pp','Scene10019ForestEmgDelta_pp', ...
        'EmgGuard','CostGuard','BoundaryGuard','TimelyGuard','SelectionScore','Status'});
    rows = append_table(rows, row);
end

T_score = sortrows(rows, {'Status','SelectionScore'}, {'ascend','descend'});
end

function write_step37_report(T_decision, T_score, T_policy_summary, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step37 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 37 Risk-Constrained V5 Targeted Validation Report\n\n');
fprintf(fid, 'Step37 tests the Step36-selected actual-cost weight (`0.060`) plus an emergency safeguard. ');
fprintf(fid, 'The target is to keep the 10017 ForestGeometry cost below 30%% while reducing emergency loss in 10017 Default.\n\n');

fprintf(fid, '## Method Score\n\n');
fprintf(fid, '| Method | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%%) | 10019 Forest Timely Gap (pp) | Status |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_score)
    fprintf(fid, '| %s | %.3f | %.3f | %.2f | %.3f | %.2f | %.3f | %s |\n', ...
        text_value(T_score.Method, i), T_score.MeanTimelyDelta_pp(i), ...
        T_score.MeanEmgDelta_pp(i), T_score.MeanCostDeltaPct(i), ...
        T_score.Scene10017DefaultEmgDelta_pp(i), T_score.Scene10017ForestCostDeltaPct(i), ...
        T_score.Scene10019ForestTimelyDelta_pp(i), text_value(T_score.Status, i));
end

fprintf(fid, '\n## Per-Case Decision Table\n\n');
fprintf(fid, '| Scene | Config | Method | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%%) | Delay Delta (%%) |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.2f | %.2f |\n', ...
        text_value(T_decision.Scene, i), text_value(T_decision.Config, i), ...
        text_value(T_decision.Method, i), T_decision.MethodMinusHeuristicTimely_pp(i), ...
        T_decision.MethodMinusHeuristicEmg_pp(i), T_decision.MethodCostDeltaPct(i), ...
        T_decision.MethodDelayDeltaPct(i));
end

fprintf(fid, '\n## Policy Diagnostics\n\n');
fprintf(fid, '| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate | Emergency Guard Share |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_policy_summary)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        text_value(T_policy_summary.Scene, i), text_value(T_policy_summary.Config, i), ...
        text_value(T_policy_summary.Method, i), T_policy_summary.DirectShareMean(i), ...
        T_policy_summary.RedundantShareMean(i), T_policy_summary.RelayShareMean(i), ...
        T_policy_summary.AvgTxRateMean(i), T_policy_summary.EmergencyGuardShareMean(i));
end
end

function tf = scalar_or_false(value)
tf = false;
if ~isempty(value)
    tf = logical(value(1));
end
end

function value = safe_scalar(x)
if isempty(x)
    value = NaN;
else
    value = x(1);
end
end

function value = text_value(col, idx)
value = char(string(col(idx)));
end

function T = append_table(T, rows)
if isempty(rows)
    return;
end

if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
