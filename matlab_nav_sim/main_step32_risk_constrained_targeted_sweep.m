clc;
clear;
close all;

% Step32 targeted sweep for the Step31 risk-constrained scheduler.
% It does not modify the Step31 objective defaults. Candidate parameters
% are injected only inside this experiment.

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
prefix = "step32_risk_constrained_targeted_" + string(num_seeds) + "seed";
seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
target_cases = build_target_cases();
candidates = build_candidate_set();

rows = [];
stage_rows = [];

for case_idx = 1:numel(target_cases)
    target = target_cases(case_idx);
    scene_meta = get_scene_meta(scene_matrix, target.scene_id);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for seed = seed_list
        fprintf('Step32 sweep: scene=%s config=%s seed=%d/%d\n', ...
            target.scene_id, target.config, seed, num_seeds);
        [T_seed, T_stage_seed] = simulate_step32_case_seed( ...
            scene_meta, scene_cfg, target.config, seed, candidates);
        rows = append_table(rows, T_seed);
        stage_rows = append_table(stage_rows, T_stage_seed);
    end
end

T_summary = build_step17_summary_table(rows);
T_stage_summary = build_step17_stage_summary_table(stage_rows);
T_decision = build_step32_decision_table(T_summary, candidates);
T_score = build_step32_candidate_score_table(T_decision);

writetable(rows, prefix + "_raw.csv");
writetable(stage_rows, prefix + "_stage_raw.csv");
writetable(T_summary, prefix + "_summary.csv");
writetable(T_stage_summary, prefix + "_stage_summary.csv");
writetable(T_decision, prefix + "_decision_table.csv");
writetable(T_score, prefix + "_candidate_score.csv");
write_step32_report(T_decision, T_score, prefix + "_report.md");

disp(T_decision);
disp(T_score);
fprintf('Step 32 complete: targeted risk-constrained sweep generated with %d seeds.\n', num_seeds);

function num_seeds = get_num_seeds_from_env(default_value)
env_value = str2double(getenv('STEP32_NUM_SEEDS'));
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

function candidates = build_candidate_set()
candidates = make_candidate("RiskBase", 0.055, 3.20, 2.20, 1.25, 0.70, 0.24);
candidates(end + 1) = make_candidate("RiskCost075", 0.075, 3.20, 2.20, 1.25, 0.70, 0.24);
candidates(end + 1) = make_candidate("RiskCost095", 0.095, 3.20, 2.20, 1.25, 0.70, 0.24);
candidates(end + 1) = make_candidate("RiskEmgGuard", 0.055, 3.80, 2.80, 1.60, 0.90, 0.30);
candidates(end + 1) = make_candidate("RiskBal075", 0.075, 3.80, 2.80, 1.60, 0.90, 0.30);
candidates(end + 1) = make_candidate("RiskBal095", 0.095, 3.80, 2.80, 1.60, 0.90, 0.30);
end

function candidate = make_candidate(name, cost_weight, timely_lambda, success_lambda, deadline_lambda, voi_urgency, success_urgency)
candidate.name = name;
candidate.cost_weight = cost_weight;
candidate.timely_lambda = timely_lambda;
candidate.success_lambda = success_lambda;
candidate.deadline_lambda = deadline_lambda;
candidate.voi_urgency = voi_urgency;
candidate.success_urgency = success_urgency;
end

function scene_meta = get_scene_meta(scene_matrix, scene_id)
for i = 1:numel(scene_matrix)
    if scene_matrix(i).scene_id == scene_id
        scene_meta = scene_matrix(i);
        return;
    end
end
error('Unknown Step32 scene id: %s', scene_id);
end

function [T_seed, T_stage_seed] = simulate_step32_case_seed(scene_meta, scene_cfg, cfg_name, seed, candidates)
if cfg_name == "Default"
    params = get_default_step9_mainline_params();
else
    params = get_forest_geometry_mainline_params();
end

params.scenario_input = scene_cfg;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
results = cell(numel(candidates) + 1, 1);
method_names = strings(numel(results), 1);

results{1} = run_step9_confidence_driven_heuristic(scenario, params);
method_names(1) = "Confidence-heuristic";

for i = 1:numel(candidates)
    candidate_params = apply_candidate_params(params, candidates(i));
    result = run_step9_confidence_driven_risk_constrained(scenario, candidate_params);
    result.name = candidates(i).name;
    results{i + 1} = result;
    method_names(i + 1) = candidates(i).name;
end

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_step32_meta_columns(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_step32_meta_columns(T_stage_seed, scene_meta, cfg_name, seed);
end

function params = apply_candidate_params(params, candidate)
params.risk_constrained_cost_weight = candidate.cost_weight;
params.risk_constrained_timely_lambda = candidate.timely_lambda;
params.risk_constrained_success_lambda = candidate.success_lambda;
params.risk_constrained_deadline_lambda = candidate.deadline_lambda;
params.risk_constrained_voi_urgency_scale = candidate.voi_urgency;
params.risk_constrained_success_urgency_scale = candidate.success_urgency;
end

function T = add_step32_meta_columns(T, scene_meta, cfg_name, seed)
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

function T_decision = build_step32_decision_table(T_summary, candidates)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i);
    subT = T_summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    if isempty(h)
        continue;
    end

    for j = 1:numel(candidates)
        r = subT(subT.Method == candidates(j).name, :);
        if isempty(r)
            continue;
        end

        timely_gap_pp = 100.0 * (r.TimelyRateMean - h.TimelyRateMean);
        emg_gap_pp = 100.0 * (r.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
        cost_delta_pct = 100.0 * (r.AvgTxCostMean - h.AvgTxCostMean) / max(abs(h.AvgTxCostMean), 1.0e-12);
        delay_delta_pct = 100.0 * (r.AvgDelayMean - h.AvgDelayMean) / max(abs(h.AvgDelayMean), 1.0e-12);

        row = table( ...
            keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), ...
            string(candidates(j).name), candidates(j).cost_weight, candidates(j).timely_lambda, ...
            candidates(j).success_lambda, candidates(j).deadline_lambda, candidates(j).voi_urgency, candidates(j).success_urgency, ...
            h.TimelyRateMean, r.TimelyRateMean, timely_gap_pp, ...
            h.EmergencyTimelyRateMean, r.EmergencyTimelyRateMean, emg_gap_pp, ...
            h.AvgTxCostMean, r.AvgTxCostMean, cost_delta_pct, ...
            h.AvgDelayMean, r.AvgDelayMean, delay_delta_pct, ...
            'VariableNames', { ...
            'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
            'Candidate','CostWeight','TimelyLambda','SuccessLambda','DeadlineLambda','VoiUrgency','SuccessUrgency', ...
            'HeuristicTimely','RiskTimely','RiskMinusHeuristicTimely_pp', ...
            'HeuristicEmgTimely','RiskEmgTimely','RiskMinusHeuristicEmg_pp', ...
            'HeuristicTxCost','RiskTxCost','RiskCostDeltaPct', ...
            'HeuristicDelay','RiskDelay','RiskDelayDeltaPct'});
        rows = append_table(rows, row);
    end
end

T_decision = rows;
end

function T_score = build_step32_candidate_score_table(T_decision)
candidates = unique(T_decision.Candidate, 'stable');
rows = [];

for i = 1:numel(candidates)
    name = candidates(i);
    T = T_decision(T_decision.Candidate == name, :);
    default_10017 = T(T.Scene == "10017" & T.Config == "Default", :);
    forest_10017 = T(T.Scene == "10017" & T.Config == "ForestGeometry", :);
    forest_10019 = T(T.Scene == "10019" & T.Config == "ForestGeometry", :);

    mean_timely = mean(T.RiskMinusHeuristicTimely_pp, 'omitnan');
    mean_emg = mean(T.RiskMinusHeuristicEmg_pp, 'omitnan');
    mean_cost = mean(T.RiskCostDeltaPct, 'omitnan');
    max_cost = max(T.RiskCostDeltaPct);
    min_timely = min(T.RiskMinusHeuristicTimely_pp);
    min_emg = min(T.RiskMinusHeuristicEmg_pp);

    emg_guard = default_10017.RiskMinusHeuristicEmg_pp >= -0.25;
    cost_guard = forest_10017.RiskCostDeltaPct <= 30.0;
    boundary_guard = forest_10019.RiskMinusHeuristicTimely_pp >= -0.50 ...
        && forest_10019.RiskMinusHeuristicEmg_pp >= -0.50;
    timely_guard = min_timely >= -0.50;

    if emg_guard && cost_guard && boundary_guard && timely_guard
        status = "Step33Candidate";
    elseif timely_guard && boundary_guard
        status = "NeedsCalibration";
    else
        status = "Reject";
    end

    score = mean_timely + 0.5 * mean_emg ...
        - 0.03 * max(mean_cost, 0.0) ...
        - 0.02 * max(max_cost - 30.0, 0.0) ...
        - 2.0 * max(-0.25 - default_10017.RiskMinusHeuristicEmg_pp, 0.0);

    row = table(name, mean_timely, mean_emg, mean_cost, max_cost, min_timely, min_emg, ...
        default_10017.RiskMinusHeuristicEmg_pp, forest_10017.RiskCostDeltaPct, ...
        forest_10019.RiskMinusHeuristicTimely_pp, forest_10019.RiskMinusHeuristicEmg_pp, ...
        emg_guard, cost_guard, boundary_guard, timely_guard, score, status, ...
        'VariableNames', { ...
        'Candidate','MeanTimelyDelta_pp','MeanEmgDelta_pp','MeanCostDeltaPct','MaxCostDeltaPct', ...
        'MinTimelyDelta_pp','MinEmgDelta_pp','Scene10017DefaultEmgDelta_pp', ...
        'Scene10017ForestCostDeltaPct','Scene10019ForestTimelyDelta_pp','Scene10019ForestEmgDelta_pp', ...
        'EmgGuard','CostGuard','BoundaryGuard','TimelyGuard','SelectionScore','Status'});
    rows = append_table(rows, row);
end

T_score = sortrows(rows, {'Status','SelectionScore'}, {'ascend','descend'});
end

function write_step32_report(T_decision, T_score, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step32 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 32 Risk-Constrained Targeted Sweep Report\n\n');
fprintf(fid, 'This experiment targets two Step31 issues: emergency timely loss in `10017 Default` and excessive cost in `10017 ForestGeometry`. ');
fprintf(fid, '`10019 ForestGeometry` is included as a boundary guard because Step31 was only comparable there.\n\n');

fprintf(fid, '## Candidate Score\n\n');
fprintf(fid, '| Candidate | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%%) | 10019 Forest Timely Gap (pp) | Status |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_score)
    fprintf(fid, '| %s | %.3f | %.3f | %.2f | %.3f | %.2f | %.3f | %s |\n', ...
        text_value(T_score.Candidate, i), T_score.MeanTimelyDelta_pp(i), ...
        T_score.MeanEmgDelta_pp(i), T_score.MeanCostDeltaPct(i), ...
        T_score.Scene10017DefaultEmgDelta_pp(i), T_score.Scene10017ForestCostDeltaPct(i), ...
        T_score.Scene10019ForestTimelyDelta_pp(i), text_value(T_score.Status, i));
end

fprintf(fid, '\n## Per-Case Decision Table\n\n');
fprintf(fid, '| Scene | Config | Candidate | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%%) | Delay Delta (%%) |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.2f | %.2f |\n', ...
        text_value(T_decision.Scene, i), text_value(T_decision.Config, i), ...
        text_value(T_decision.Candidate, i), T_decision.RiskMinusHeuristicTimely_pp(i), ...
        T_decision.RiskMinusHeuristicEmg_pp(i), T_decision.RiskCostDeltaPct(i), ...
        T_decision.RiskDelayDeltaPct(i));
end

fprintf(fid, '\n## Guard Rules\n\n');
fprintf(fid, '- `EmgGuard`: `10017 Default` emergency timely gap must be at least -0.25 pp.\n');
fprintf(fid, '- `CostGuard`: `10017 ForestGeometry` cost delta must not exceed 30%%.\n');
fprintf(fid, '- `BoundaryGuard`: `10019 ForestGeometry` timely and emergency gaps must both be at least -0.50 pp.\n');
fprintf(fid, '- `TimelyGuard`: no targeted case may lose more than 0.50 pp timely rate.\n');
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
