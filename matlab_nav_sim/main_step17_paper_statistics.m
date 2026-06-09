clc;
clear;
close all;

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

mode_name = getenv('STEP17_MODE');
if isempty(mode_name)
    mode_name = 'preview';
end

if strcmpi(mode_name, 'full') || strcmpi(mode_name, 'full5')
    num_seeds = 50;
elseif strcmpi(mode_name, 'main3')
    num_seeds = 50;
else
    num_seeds = 10;
end

seed_override = getenv('STEP17_NUM_SEEDS');
if ~isempty(seed_override)
    num_seeds = str2double(seed_override);
end

seed_list = 1:num_seeds;
scene_matrix = get_paper_scene_matrix();
if strcmpi(mode_name, 'main3')
    scene_matrix = scene_matrix([scene_matrix.is_primary_set]);
elseif strcmpi(mode_name, 'preview_main3')
    scene_matrix = scene_matrix([scene_matrix.is_primary_set]);
    num_seeds = 10;
end
config_names = ["Default", "ForestGeometry"];
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

prefix = sprintf('step17_%s', lower(mode_name));
prefix_override = strtrim(string(getenv('STEP17_PREFIX')));
if strlength(prefix_override) > 0
    prefix = char(prefix_override);
end

T_raw = [];
T_stage_raw = [];
T_sig = [];
T_sig_posdeg = [];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    scene_role = scene_matrix(scene_idx).scene_role;
    geometry_type = scene_matrix(scene_idx).geometry_type;
    density_class = scene_matrix(scene_idx).density_class;
    vegetation_class = scene_matrix(scene_idx).vegetation_class;
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_id);

    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);

        for seed = seed_list
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
            T_seed.Scene = repmat(scene_id, height(T_seed), 1);
            T_seed.SceneRole = repmat(scene_role, height(T_seed), 1);
            T_seed.GeometryType = repmat(geometry_type, height(T_seed), 1);
            T_seed.DensityClass = repmat(density_class, height(T_seed), 1);
            T_seed.VegetationClass = repmat(vegetation_class, height(T_seed), 1);
            T_seed.Config = repmat(cfg_name, height(T_seed), 1);
            T_seed.Seed = repmat(seed, height(T_seed), 1);
            T_seed = movevars(T_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');

            if isempty(T_raw)
                T_raw = T_seed;
            else
                T_raw = [T_raw; T_seed]; %#ok<AGROW>
            end

            stages = define_step9_stage_masks(scenario.t);
            metrics_list = cell(numel(results), 1);
            for i = 1:numel(results)
                metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
            end

            T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
            T_stage_seed.Scene = repmat(scene_id, height(T_stage_seed), 1);
            T_stage_seed.SceneRole = repmat(scene_role, height(T_stage_seed), 1);
            T_stage_seed.GeometryType = repmat(geometry_type, height(T_stage_seed), 1);
            T_stage_seed.DensityClass = repmat(density_class, height(T_stage_seed), 1);
            T_stage_seed.VegetationClass = repmat(vegetation_class, height(T_stage_seed), 1);
            T_stage_seed.Config = repmat(cfg_name, height(T_stage_seed), 1);
            T_stage_seed.Seed = repmat(seed, height(T_stage_seed), 1);
            T_stage_seed = movevars(T_stage_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');

            if isempty(T_stage_raw)
                T_stage_raw = T_stage_seed;
            else
                T_stage_raw = [T_stage_raw; T_stage_seed]; %#ok<AGROW>
            end

            interim_raw = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
            interim_stage = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name, :);
            writetable(interim_raw, sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg_name));
            writetable(interim_stage, sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg_name));
        end

        T_cfg = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, "Link-delay-aware", "Confidence-driven");
        T_cfg_stat.Scene = repmat(scene_id, height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(cfg_name, height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');

        if isempty(T_sig)
            T_sig = T_cfg_stat;
        else
            T_sig = [T_sig; T_cfg_stat]; %#ok<AGROW>
        end

        T_pos = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name & T_stage_raw.Stage == "PosDeg_Emerg", :);
        T_pos_stat = compute_step12_statistical_tests(T_pos, "Link-delay-aware", "Confidence-driven");
        T_pos_stat.Scene = repmat(scene_id, height(T_pos_stat), 1);
        T_pos_stat.Config = repmat(cfg_name, height(T_pos_stat), 1);
        T_pos_stat.Stage = repmat("PosDeg_Emerg", height(T_pos_stat), 1);
        T_pos_stat = movevars(T_pos_stat, {'Scene','Config','Stage'}, 'Before', 'Metric');

        if isempty(T_sig_posdeg)
            T_sig_posdeg = T_pos_stat;
        else
            T_sig_posdeg = [T_sig_posdeg; T_pos_stat]; %#ok<AGROW>
        end
    end
end

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
fprintf('Step 17 complete (%s mode, %d seeds): paper-level statistics package generated.\n', mode_name, num_seeds);
