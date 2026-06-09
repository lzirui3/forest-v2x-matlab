clc;
clear;
close all;

% Resumable side-copy validation for the Lyapunov scheduler on the VTC scene matrix.
% It writes each scene/config after every seed to avoid losing long-running progress.

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

prefix = "step30_lyapunov_vtc_10seed";
num_seeds = get_num_seeds_from_env(10);
seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
config_names = ["Default", "ForestGeometry"];
method_names = ["Link-delay-aware", "Confidence-heuristic", "Confidence-lyapunov", "Constrained Oracle"];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_meta.scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg_name);
        [T_case_raw, T_case_stage] = read_existing_case_tables(raw_path, stage_path);

        if isempty(T_case_raw)
            existing_seeds = [];
        else
            existing_seeds = unique(T_case_raw.Seed).';
        end
        missing_seeds = setdiff(seed_list, existing_seeds, 'stable');

        fprintf('Step30 resume: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_meta.scene_id, cfg_name, numel(existing_seeds), numel(missing_seeds));

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_step30_case_seed( ...
                scene_meta, scene_cfg, cfg_name, seed, method_names);

            T_case_raw = append_table(T_case_raw, T_seed);
            T_case_stage = append_table(T_case_stage, T_stage_seed);
            writetable(T_case_raw, raw_path);
            writetable(T_case_stage, stage_path);
        end
    end
end

[T_raw, T_stage_raw] = merge_step30_case_tables(prefix, scene_matrix, config_names);
T_summary = build_step17_summary_table(T_raw);
T_stage_summary = build_step17_stage_summary_table(T_stage_raw);
T_sig_h_vs_l = compute_step30_significance(T_raw, scene_matrix, config_names, ...
    "Confidence-heuristic", "Confidence-lyapunov");
T_sig_pos_h_vs_l = compute_step30_posdeg_significance(T_stage_raw, scene_matrix, config_names, ...
    "Confidence-heuristic", "Confidence-lyapunov");
T_sig_link_vs_l = compute_step30_significance(T_raw, scene_matrix, config_names, ...
    "Link-delay-aware", "Confidence-lyapunov");
T_eff = build_cost_efficiency_table(T_summary, "Link-delay-aware");
T_decision = build_step30_decision_table(T_summary);

T_sig_h_vs_l = apply_familywise_holm_to_stats_table(T_sig_h_vs_l);
T_sig_pos_h_vs_l = apply_familywise_holm_to_stats_table(T_sig_pos_h_vs_l);
T_sig_link_vs_l = apply_familywise_holm_to_stats_table(T_sig_link_vs_l);

writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage_raw, prefix + "_stage_raw.csv");
writetable(T_summary, prefix + "_summary.csv");
writetable(T_stage_summary, prefix + "_stage_summary.csv");
writetable(T_sig_h_vs_l, prefix + "_heuristic_vs_lyapunov_significance.csv");
writetable(T_sig_pos_h_vs_l, prefix + "_heuristic_vs_lyapunov_posdeg_significance.csv");
writetable(T_sig_link_vs_l, prefix + "_link_vs_lyapunov_significance.csv");
writetable(T_eff, prefix + "_cost_efficiency.csv");
writetable(T_decision, prefix + "_decision_table.csv");

write_step30_lyapunov_vtc_report( ...
    T_summary, T_stage_summary, T_sig_h_vs_l, T_sig_pos_h_vs_l, ...
    T_sig_link_vs_l, T_decision, prefix + "_report.md");

disp(T_summary);
disp(T_decision);
fprintf('Step 30 resumable validation complete: %d seeds x %d scenes x %d configs.\n', ...
    num_seeds, numel(scene_matrix), numel(config_names));

function num_seeds = get_num_seeds_from_env(default_value)
env_value = str2double(getenv('STEP30_NUM_SEEDS'));
if isnan(env_value) || env_value < 1
    num_seeds = default_value;
else
    num_seeds = round(env_value);
end
end

function [T_raw, T_stage] = read_existing_case_tables(raw_path, stage_path)
if isfile(raw_path)
    T_raw = normalize_step30_case_table(readtable(raw_path));
else
    T_raw = [];
end

if isfile(stage_path)
    T_stage = normalize_step30_case_table(readtable(stage_path));
else
    T_stage = [];
end
end

function T = normalize_step30_case_table(T)
if isempty(T)
    return;
end

string_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method','Stage'};
for i = 1:numel(string_vars)
    name = string_vars{i};
    if ismember(name, T.Properties.VariableNames)
        T.(name) = string(T.(name));
    end
end
end

function [T_seed, T_stage_seed] = simulate_step30_case_seed(scene_meta, scene_cfg, cfg_name, seed, method_names)
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
    run_step9_confidence_driven_lyapunov(scenario, params), ...
    run_step9_baseline_oracle(scenario, params)};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_step30_meta_columns(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_step30_meta_columns(T_stage_seed, scene_meta, cfg_name, seed);
end

function T = add_step30_meta_columns(T, scene_meta, cfg_name, seed)
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

function [T_raw, T_stage_raw] = merge_step30_case_tables(prefix, scene_matrix, config_names)
T_raw = [];
T_stage_raw = [];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg_name);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing Step30 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table(T_raw, normalize_step30_case_table(readtable(raw_path)));
        T_stage_raw = append_table(T_stage_raw, normalize_step30_case_table(readtable(stage_path)));
    end
end
end

function T_sig = compute_step30_significance(T_raw, scene_matrix, config_names, baseline_name, proposed_name)
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

function T_sig = compute_step30_posdeg_significance(T_stage_raw, scene_matrix, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        T_pos = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name ...
            & T_stage_raw.Stage == "PosDeg_Emerg", :);
        T_pos_stat = compute_step12_statistical_tests(T_pos, baseline_name, proposed_name);
        T_pos_stat.Scene = repmat(scene_id, height(T_pos_stat), 1);
        T_pos_stat.Config = repmat(cfg_name, height(T_pos_stat), 1);
        T_pos_stat.Stage = repmat("PosDeg_Emerg", height(T_pos_stat), 1);
        T_pos_stat = movevars(T_pos_stat, {'Scene','Config','Stage'}, 'Before', 'Metric');
        T_sig = append_table(T_sig, T_pos_stat);
    end
end
end

function T_decision = build_step30_decision_table(T_summary)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i);
    subT = T_summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    l = subT(subT.Method == "Confidence-lyapunov", :);
    if isempty(h) || isempty(l)
        continue;
    end

    timely_gap_pp = 100.0 * (l.TimelyRateMean - h.TimelyRateMean);
    emg_gap_pp = 100.0 * (l.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
    cost_delta_pct = 100.0 * (l.AvgTxCostMean - h.AvgTxCostMean) / max(abs(h.AvgTxCostMean), 1.0e-12);
    delay_delta_pct = 100.0 * (l.AvgDelayMean - h.AvgDelayMean) / max(abs(h.AvgDelayMean), 1.0e-12);

    if timely_gap_pp >= -0.5 && cost_delta_pct <= -5.0
        decision = "PromisingCostVariant";
        interpretation = "Lyapunov stays within 0.5 pp of heuristic and reduces cost by at least 5%.";
    elseif timely_gap_pp >= -1.0 && cost_delta_pct <= -10.0
        decision = "CostVariantWithPenalty";
        interpretation = "Lyapunov saves substantial cost but loses up to 1 pp timely rate.";
    elseif timely_gap_pp < -1.0 && cost_delta_pct < 0.0
        decision = "CostOnlyVariant";
        interpretation = "Lyapunov saves cost but loses too much timely performance for the main method.";
    else
        decision = "NotCompetitive";
        interpretation = "Lyapunov does not provide a favorable timely-cost tradeoff in this row.";
    end

    row = table( ...
        keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), ...
        h.TimelyRateMean, l.TimelyRateMean, timely_gap_pp, ...
        h.EmergencyTimelyRateMean, l.EmergencyTimelyRateMean, emg_gap_pp, ...
        h.AvgTxCostMean, l.AvgTxCostMean, cost_delta_pct, ...
        h.AvgDelayMean, l.AvgDelayMean, delay_delta_pct, ...
        string(decision), string(interpretation), ...
        'VariableNames', { ...
        'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
        'HeuristicTimely','LyapunovTimely','LyapunovMinusHeuristicTimely_pp', ...
        'HeuristicEmgTimely','LyapunovEmgTimely','LyapunovMinusHeuristicEmg_pp', ...
        'HeuristicTxCost','LyapunovTxCost','LyapunovCostDeltaPct', ...
        'HeuristicDelay','LyapunovDelay','LyapunovDelayDeltaPct', ...
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
