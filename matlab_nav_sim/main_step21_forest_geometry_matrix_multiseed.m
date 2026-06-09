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

num_seeds = 10;
seed_list = 1:num_seeds;

T_cfg = list_available_forest_geometry_configs();
T_cfg = T_cfg(T_cfg.Ready, :);
if isempty(T_cfg)
    error('No ready forest geometry matrix templates found. Run prepare_step9_forest_geometry_matrix_inputs first.');
end

method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];
rows = [];
stage_rows = [];

for c = 1:height(T_cfg)
    profile_name = string(T_cfg.Profile(c));
    vegetation_level = string(T_cfg.Vegetation(c));
    config_label = "FG_" + profile_name + "_" + vegetation_level;

    for s = seed_list
        params = get_default_step9_mainline_params();
        params = get_forest_dataset_calibrated_params(params);
        params.scenario_input = get_default_step9_forest_geometry_config(profile_name, vegetation_level);
        params.random_seed = s;

        scenario = generate_step9_scenario(params);
        results = { ...
            run_step9_baseline_link_delayaware(scenario, params), ...
            run_step9_confidence_driven(scenario, params), ...
            run_step9_baseline_oracle(scenario, params)};

        T_seed = evaluate_step9_metrics(scenario, results);
        T_seed.Config = repmat(config_label, height(T_seed), 1);
        T_seed.Profile = repmat(profile_name, height(T_seed), 1);
        T_seed.Vegetation = repmat(vegetation_level, height(T_seed), 1);
        T_seed.Seed = repmat(s, height(T_seed), 1);
        T_seed = movevars(T_seed, {'Config','Profile','Vegetation','Seed'}, 'Before', 'Method');

        if isempty(rows)
            rows = T_seed;
        else
            rows = [rows; T_seed]; %#ok<AGROW>
        end

        stages = define_step9_stage_masks(scenario.t);
        metrics_list = cell(numel(results), 1);
        for i = 1:numel(results)
            metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
        end

        T_stage = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
        T_stage.Config = repmat(config_label, height(T_stage), 1);
        T_stage.Profile = repmat(profile_name, height(T_stage), 1);
        T_stage.Vegetation = repmat(vegetation_level, height(T_stage), 1);
        T_stage.Seed = repmat(s, height(T_stage), 1);
        T_stage = movevars(T_stage, {'Config','Profile','Vegetation','Seed'}, 'Before', 'Method');

        if isempty(stage_rows)
            stage_rows = T_stage;
        else
            stage_rows = [stage_rows; T_stage]; %#ok<AGROW>
        end
    end
end

writetable(rows, 'step21_forest_geometry_matrix_raw.csv');
writetable(stage_rows, 'step21_forest_geometry_matrix_stage_raw.csv');

disp(T_cfg);
disp('Step 21 complete: forest geometry matrix multiseed raw data generated.');
