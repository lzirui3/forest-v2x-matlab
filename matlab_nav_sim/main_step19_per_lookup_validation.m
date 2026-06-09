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
configs = ["Default", "ForestGeometry"];
pdr_modes = ["sigmoid", "per_lookup"];
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

rows = [];
stage_rows = [];

for c = 1:numel(configs)
    for p = 1:numel(pdr_modes)
        for s = seed_list
            fprintf('Step19: Config=%s, PdrMode=%s, Seed=%d\n', configs(c), pdr_modes(p), s);
            if configs(c) == "Default"
                params = get_default_step9_mainline_params();
            else
                params = get_forest_geometry_mainline_params();
            end
            params.random_seed = s;
            params.physical_pdr_mode = pdr_modes(p);

            scenario = generate_step9_scenario(params);
            results = { ...
                run_step9_baseline_link_delayaware(scenario, params), ...
                run_step9_confidence_driven(scenario, params), ...
                run_step9_baseline_oracle(scenario, params)};

            T_seed = evaluate_step9_metrics(scenario, results);
            T_seed.Config = repmat(configs(c), height(T_seed), 1);
            T_seed.PdrMode = repmat(pdr_modes(p), height(T_seed), 1);
            T_seed.Seed = repmat(s, height(T_seed), 1);
            T_seed = movevars(T_seed, {'Config','PdrMode','Seed'}, 'Before', 'Method');

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
            T_stage.Config = repmat(configs(c), height(T_stage), 1);
            T_stage.PdrMode = repmat(pdr_modes(p), height(T_stage), 1);
            T_stage.Seed = repmat(s, height(T_stage), 1);
            T_stage = movevars(T_stage, {'Config','PdrMode','Seed'}, 'Before', 'Method');

            if isempty(stage_rows)
                stage_rows = T_stage;
            else
                stage_rows = [stage_rows; T_stage]; %#ok<AGROW>
            end
        end
    end
end

T_overall = build_step19_pdr_mode_delta_table(rows, "Confidence-driven");
T_posdeg = build_step19_pdr_mode_delta_table(stage_rows(stage_rows.Stage == "PosDeg_Emerg", :), "Confidence-driven");
T_sig = build_step19_pdr_mode_significance(rows, "Confidence-driven");
T_posdeg_sig = build_step19_pdr_mode_significance(stage_rows(stage_rows.Stage == "PosDeg_Emerg", :), "Confidence-driven");

writetable(rows, 'step19_per_lookup_validation_raw.csv');
writetable(stage_rows, 'step19_per_lookup_validation_stage_raw.csv');
writetable(T_overall, 'step19_per_lookup_validation_overall_delta.csv');
writetable(T_posdeg, 'step19_per_lookup_validation_posdeg_delta.csv');
writetable(T_sig, 'step19_per_lookup_validation_overall_significance.csv');
writetable(T_posdeg_sig, 'step19_per_lookup_validation_posdeg_significance.csv');

write_step19_per_lookup_validation_report( ...
    T_overall, T_posdeg, T_sig, T_posdeg_sig, 'step19_per_lookup_validation_report.md');

disp(T_overall);
disp(T_posdeg);
disp(T_sig);
disp(T_posdeg_sig);
disp('Step 19 complete: PER lookup vs sigmoid validation generated.');
