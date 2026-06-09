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

num_seeds = 30;
seed_list = 1:num_seeds;
config_names = ["Default", "ForestGeometry"];
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

rows = [];
stage_rows = [];

for c = 1:numel(config_names)
    for s = seed_list
        if config_names(c) == "Default"
            params = get_default_step9_mainline_params();
        else
            params = get_forest_geometry_mainline_params();
        end
        params.random_seed = s;

        scenario = generate_step9_scenario(params);
        results = { ...
            run_step9_baseline_link_delayaware(scenario, params), ...
            run_step9_confidence_driven(scenario, params), ...
            run_step9_baseline_oracle(scenario, params)};

        T_seed = evaluate_step9_metrics(scenario, results);
        T_seed.Config = repmat(config_names(c), height(T_seed), 1);
        T_seed.Seed = repmat(s, height(T_seed), 1);
        T_seed = movevars(T_seed, {'Config','Seed'}, 'Before', 'Method');

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
        T_stage.Config = repmat(config_names(c), height(T_stage), 1);
        T_stage.Seed = repmat(s, height(T_stage), 1);
        T_stage = movevars(T_stage, {'Config','Seed'}, 'Before', 'Method');

        if isempty(stage_rows)
            stage_rows = T_stage;
        else
            stage_rows = [stage_rows; T_stage]; %#ok<AGROW>
        end
    end
end

T_summary = build_step15_summary_table(rows);
T_stage_summary = build_step15_stage_summary_table(stage_rows);

disp(T_summary);
disp(T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :));

writetable(rows, 'step15_default_vs_forest_multiseed_raw.csv');
writetable(stage_rows, 'step15_default_vs_forest_multiseed_stage_raw.csv');
writetable(T_summary, 'step15_default_vs_forest_multiseed_summary.csv');
writetable(T_stage_summary, 'step15_default_vs_forest_multiseed_stage_summary.csv');

plot_step15_default_vs_forest_multiseed(T_summary, T_stage_summary);

disp('Step 15 complete: default vs forest-geometry multiseed comparison generated.');
