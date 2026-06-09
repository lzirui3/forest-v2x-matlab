clc;
clear;
close all;

% Resume and finalize the VTC-level Step 17 evidence chain.
% It reuses completed per-scene CSV files and only simulates missing seeds.

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

prefix = "step17_vtc_final";
num_seeds = 50;
seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
config_names = ["Default", "ForestGeometry"];
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_id);

    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg_name);
        [T_cfg_raw, T_cfg_stage] = read_existing_case_tables(raw_path, stage_path);
        if isempty(T_cfg_raw)
            existing_seeds = [];
        else
            existing_seeds = unique(T_cfg_raw.Seed).';
        end
        missing_seeds = setdiff(seed_list, existing_seeds, 'stable');

        fprintf('Step17 resume: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_id, cfg_name, numel(existing_seeds), numel(missing_seeds));

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_step17_case_seed( ...
                scene_matrix(scene_idx), scene_cfg, cfg_name, seed, method_names);

            T_cfg_raw = append_table(T_cfg_raw, T_seed);
            T_cfg_stage = append_table(T_cfg_stage, T_stage_seed);
            writetable(T_cfg_raw, raw_path);
            writetable(T_cfg_stage, stage_path);
        end
    end
end

[T_raw, T_stage_raw] = merge_step17_case_tables(prefix, scene_matrix, config_names);
[T_sig, T_sig_posdeg] = compute_step17_final_significance(T_raw, T_stage_raw, scene_matrix, config_names);

T_summary = build_step17_summary_table(T_raw);
T_stage_summary = build_step17_stage_summary_table(T_stage_raw);
T_sig = apply_familywise_holm_to_stats_table(T_sig);
T_sig_posdeg = apply_familywise_holm_to_stats_table(T_sig_posdeg);
T_eff = build_cost_efficiency_table(T_summary, "Link-delay-aware");

writetable(T_raw, sprintf('%s_paper_statistics_raw.csv', prefix));
writetable(T_stage_raw, sprintf('%s_paper_statistics_stage_raw.csv', prefix));
writetable(T_summary, sprintf('%s_paper_statistics_summary.csv', prefix));
writetable(T_stage_summary, sprintf('%s_paper_statistics_stage_summary.csv', prefix));
writetable(T_sig, sprintf('%s_paper_statistics_significance.csv', prefix));
writetable(T_sig_posdeg, sprintf('%s_paper_statistics_posdeg_significance.csv', prefix));
writetable(T_eff, sprintf('%s_cost_efficiency.csv', prefix));

plot_step17_paper_statistics(T_summary, T_stage_summary, prefix);
plot_cost_efficiency_pareto(T_summary, prefix);
write_step17_paper_statistics_report(T_summary, T_stage_summary, T_sig, T_sig_posdeg, ...
    sprintf('%s_paper_statistics_report.md', prefix));

disp(T_summary);
disp(T_sig);
disp(T_sig_posdeg);
fprintf('Step 17 VTC resume complete: %d seeds x %d scenes x %d configs.\n', ...
    num_seeds, numel(scene_matrix), numel(config_names));

function [T_raw, T_stage] = read_existing_case_tables(raw_path, stage_path)
if isfile(raw_path)
    T_raw = normalize_step17_case_table(readtable(raw_path));
else
    T_raw = [];
end

if isfile(stage_path)
    T_stage = normalize_step17_case_table(readtable(stage_path));
else
    T_stage = [];
end
end

function T = normalize_step17_case_table(T)
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

function [T_seed, T_stage_seed] = simulate_step17_case_seed(scene_meta, scene_cfg, cfg_name, seed, method_names)
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
    run_step9_confidence_driven(scenario, params), ...
    run_step9_baseline_oracle(scenario, params)};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_step17_meta_columns(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_step17_meta_columns(T_stage_seed, scene_meta, cfg_name, seed);
end

function T = add_step17_meta_columns(T, scene_meta, cfg_name, seed)
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

function [T_raw, T_stage_raw] = merge_step17_case_tables(prefix, scene_matrix, config_names)
T_raw = [];
T_stage_raw = [];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg_name);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing resumed Step17 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table(T_raw, normalize_step17_case_table(readtable(raw_path)));
        T_stage_raw = append_table(T_stage_raw, normalize_step17_case_table(readtable(stage_path)));
    end
end
end

function [T_sig, T_sig_posdeg] = compute_step17_final_significance(T_raw, T_stage_raw, scene_matrix, config_names)
T_sig = [];
T_sig_posdeg = [];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);

        T_cfg = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, "Link-delay-aware", "Confidence-driven");
        T_cfg_stat.Scene = repmat(scene_id, height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(cfg_name, height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table(T_sig, T_cfg_stat);

        T_pos = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name ...
            & T_stage_raw.Stage == "PosDeg_Emerg", :);
        T_pos_stat = compute_step12_statistical_tests(T_pos, "Link-delay-aware", "Confidence-driven");
        T_pos_stat.Scene = repmat(scene_id, height(T_pos_stat), 1);
        T_pos_stat.Config = repmat(cfg_name, height(T_pos_stat), 1);
        T_pos_stat.Stage = repmat("PosDeg_Emerg", height(T_pos_stat), 1);
        T_pos_stat = movevars(T_pos_stat, {'Scene','Config','Stage'}, 'Before', 'Metric');
        T_sig_posdeg = append_table(T_sig_posdeg, T_pos_stat);
    end
end
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
