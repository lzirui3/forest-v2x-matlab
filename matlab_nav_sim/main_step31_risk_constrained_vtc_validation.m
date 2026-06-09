clc;
clear;
close all;

% Step31 validates a risk-constrained side-copy scheduler on the VTC scene matrix.
% It does not overwrite Step17/Step29/Step30 evidence chains.

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

num_seeds = get_num_seeds_from_env(1);
prefix = "step31_risk_constrained_vtc_" + string(num_seeds) + "seed";
seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
config_names = ["Default", "ForestGeometry"];
method_names = ["Link-delay-aware", "Confidence-heuristic", ...
    "Risk-constrained", "Confidence-lyapunov", "Constrained Oracle"];

rows = [];
stage_rows = [];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        fprintf('Step31 risk-constrained validation: scene=%s config=%s seeds=%d\n', ...
            scene_meta.scene_id, cfg_name, num_seeds);

        for seed = seed_list
            [T_seed, T_stage_seed] = simulate_step31_case_seed( ...
                scene_meta, scene_cfg, cfg_name, seed, method_names);

            rows = append_table(rows, T_seed);
            stage_rows = append_table(stage_rows, T_stage_seed);
        end
    end
end

T_summary = build_step17_summary_table(rows);
T_stage_summary = build_step17_stage_summary_table(stage_rows);
T_sig_h_vs_r = compute_step31_significance(rows, scene_matrix, config_names, ...
    "Confidence-heuristic", "Risk-constrained");
T_sig_link_vs_r = compute_step31_significance(rows, scene_matrix, config_names, ...
    "Link-delay-aware", "Risk-constrained");
T_sig_lyap_vs_r = compute_step31_significance(rows, scene_matrix, config_names, ...
    "Confidence-lyapunov", "Risk-constrained");
T_eff = build_cost_efficiency_table(T_summary, "Link-delay-aware");
T_decision = build_step31_decision_table(T_summary);

T_sig_h_vs_r = apply_familywise_holm_to_stats_table(T_sig_h_vs_r);
T_sig_link_vs_r = apply_familywise_holm_to_stats_table(T_sig_link_vs_r);
T_sig_lyap_vs_r = apply_familywise_holm_to_stats_table(T_sig_lyap_vs_r);

writetable(rows, prefix + "_raw.csv");
writetable(stage_rows, prefix + "_stage_raw.csv");
writetable(T_summary, prefix + "_summary.csv");
writetable(T_stage_summary, prefix + "_stage_summary.csv");
writetable(T_sig_h_vs_r, prefix + "_heuristic_vs_risk_significance.csv");
writetable(T_sig_link_vs_r, prefix + "_link_vs_risk_significance.csv");
writetable(T_sig_lyap_vs_r, prefix + "_lyapunov_vs_risk_significance.csv");
writetable(T_eff, prefix + "_cost_efficiency.csv");
writetable(T_decision, prefix + "_decision_table.csv");

write_step31_risk_constrained_vtc_report( ...
    T_summary, T_stage_summary, T_sig_h_vs_r, T_sig_link_vs_r, ...
    T_sig_lyap_vs_r, T_decision, prefix + "_report.md");

disp(T_summary);
disp(T_decision);
fprintf('Step 31 complete: risk-constrained validation generated with %d seeds.\n', num_seeds);

function num_seeds = get_num_seeds_from_env(default_value)
env_value = str2double(getenv('STEP31_NUM_SEEDS'));
if isnan(env_value) || env_value < 1
    num_seeds = default_value;
else
    num_seeds = round(env_value);
end
end

function [T_seed, T_stage_seed] = simulate_step31_case_seed(scene_meta, scene_cfg, cfg_name, seed, method_names)
if cfg_name == "Default"
    params = get_default_step9_mainline_params();
else
    params = get_forest_geometry_mainline_params();
end

params.scenario_input = scene_cfg;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    run_step9_confidence_driven_risk_constrained(scenario, params), ...
    run_step9_confidence_driven_lyapunov(scenario, params), ...
    run_step9_baseline_oracle(scenario, params)};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_step31_meta_columns(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_step31_meta_columns(T_stage_seed, scene_meta, cfg_name, seed);
end

function T = add_step31_meta_columns(T, scene_meta, cfg_name, seed)
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

function T_sig = compute_step31_significance(T_raw, scene_matrix, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        T_cfg = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, baseline_name, proposed_name);
        T_cfg_stat.Scene = repmat(scene_id, height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(cfg_name, height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table(T_sig, T_cfg_stat);
    end
end
end

function T_decision = build_step31_decision_table(T_summary)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i);
    subT = T_summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    r = subT(subT.Method == "Risk-constrained", :);
    l = subT(subT.Method == "Confidence-lyapunov", :);
    if isempty(h) || isempty(r)
        continue;
    end

    timely_gap_pp = 100.0 * (r.TimelyRateMean - h.TimelyRateMean);
    emg_gap_pp = 100.0 * (r.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
    cost_delta_pct = 100.0 * (r.AvgTxCostMean - h.AvgTxCostMean) / max(abs(h.AvgTxCostMean), 1.0e-12);
    delay_delta_pct = 100.0 * (r.AvgDelayMean - h.AvgDelayMean) / max(abs(h.AvgDelayMean), 1.0e-12);

    if timely_gap_pp >= -0.05 && emg_gap_pp >= -0.50
        decision = "CandidateMainMethod";
        interpretation = "Risk-constrained preserves timely/emergency delivery relative to heuristic.";
    elseif timely_gap_pp >= -0.50 && emg_gap_pp >= -0.50
        decision = "ComparableTheoryVariant";
        interpretation = "Risk-constrained is close enough to heuristic to justify a 10-seed follow-up.";
    elseif timely_gap_pp >= -1.00 && emg_gap_pp >= -1.00
        decision = "NeedsTuning";
        interpretation = "Risk-constrained has theory value but needs weight calibration before mainline use.";
    else
        decision = "NotCompetitive";
        interpretation = "Risk-constrained loses too much timely or emergency performance in this row.";
    end

    if isempty(l)
        lyap_timely = NaN;
    else
        lyap_timely = l.TimelyRateMean;
    end

    row = table( ...
        keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), ...
        h.TimelyRateMean, r.TimelyRateMean, lyap_timely, timely_gap_pp, ...
        h.EmergencyTimelyRateMean, r.EmergencyTimelyRateMean, emg_gap_pp, ...
        h.AvgTxCostMean, r.AvgTxCostMean, cost_delta_pct, ...
        h.AvgDelayMean, r.AvgDelayMean, delay_delta_pct, ...
        string(decision), string(interpretation), ...
        'VariableNames', { ...
        'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
        'HeuristicTimely','RiskTimely','LyapunovTimely','RiskMinusHeuristicTimely_pp', ...
        'HeuristicEmgTimely','RiskEmgTimely','RiskMinusHeuristicEmg_pp', ...
        'HeuristicTxCost','RiskTxCost','RiskCostDeltaPct', ...
        'HeuristicDelay','RiskDelay','RiskDelayDeltaPct', ...
        'DecisionClass','Interpretation'});
    rows = append_table(rows, row);
end

T_decision = rows;
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
