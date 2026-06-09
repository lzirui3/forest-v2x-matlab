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
profiles = ["Blind", "Curved", "Straight"];
vegetation_levels = ["Medium", "Dense", "Sparse"];
pair_labels = ["Blind_Medium", "Curved_Dense", "Straight_Sparse"];
variants = ["Base", "Plus"];
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

rows = [];
stage_rows = [];

for i = 1:numel(pair_labels)
    profile_name = profiles(i);
    vegetation_level = vegetation_levels(i);

    for v = 1:numel(variants)
        for s = seed_list
            params = get_default_step9_mainline_params();
            params = get_forest_dataset_calibrated_params(params);

            if variants(v) == "Plus"
                params.use_veg_attenuation = true;
                params.scenario_input = get_default_step9_forest_geometry_plus_config(profile_name, vegetation_level);
            else
                params.use_veg_attenuation = false;
                params.scenario_input = get_default_step9_forest_geometry_config(profile_name, vegetation_level);
            end
            params.random_seed = s;

            scenario = generate_step9_scenario(params);
            results = { ...
                run_step9_baseline_link_delayaware(scenario, params), ...
                run_step9_confidence_driven(scenario, params), ...
                run_step9_baseline_oracle(scenario, params)};

            config_label = "FG_" + pair_labels(i) + "_" + variants(v);
            T_seed = evaluate_step9_metrics(scenario, results);
            T_seed.Config = repmat(config_label, height(T_seed), 1);
            T_seed.Profile = repmat(profile_name, height(T_seed), 1);
            T_seed.Vegetation = repmat(vegetation_level, height(T_seed), 1);
            T_seed.Variant = repmat(variants(v), height(T_seed), 1);
            T_seed.Seed = repmat(s, height(T_seed), 1);
            T_seed = movevars(T_seed, {'Config','Profile','Vegetation','Variant','Seed'}, 'Before', 'Method');

            if isempty(rows)
                rows = T_seed;
            else
                rows = [rows; T_seed]; %#ok<AGROW>
            end

            stages = define_step9_stage_masks(scenario.t);
            metrics_list = cell(numel(results), 1);
            for m = 1:numel(results)
                metrics_list{m} = compute_step9_stage_metrics(scenario, results{m}, stages);
            end

            T_stage = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
            T_stage.Config = repmat(config_label, height(T_stage), 1);
            T_stage.Profile = repmat(profile_name, height(T_stage), 1);
            T_stage.Vegetation = repmat(vegetation_level, height(T_stage), 1);
            T_stage.Variant = repmat(variants(v), height(T_stage), 1);
            T_stage.Seed = repmat(s, height(T_stage), 1);
            T_stage = movevars(T_stage, {'Config','Profile','Vegetation','Variant','Seed'}, 'Before', 'Method');

            if isempty(stage_rows)
                stage_rows = T_stage;
            else
                stage_rows = [stage_rows; T_stage]; %#ok<AGROW>
            end
        end
    end
end

T_summary = build_step22_summary_table(rows);
T_stage_summary = build_step22_stage_summary_table(stage_rows);
T_sig = build_step22_significance(rows, "Link-delay-aware", "Confidence-driven");
T_stage_sig = build_step22_stage_significance(stage_rows, "PosDeg_Emerg", "Link-delay-aware", "Confidence-driven");

writetable(rows, 'step22_forest_geometry_plus_raw.csv');
writetable(stage_rows, 'step22_forest_geometry_plus_stage_raw.csv');
writetable(T_summary, 'step22_forest_geometry_plus_summary.csv');
writetable(T_stage_summary, 'step22_forest_geometry_plus_stage_summary.csv');
writetable(T_sig, 'step22_forest_geometry_plus_significance.csv');
writetable(T_stage_sig, 'step22_forest_geometry_plus_posdeg_significance.csv');

write_step22_forest_geometry_plus_report( ...
    T_summary, T_stage_summary, T_sig, T_stage_sig, ...
    'step22_forest_geometry_plus_report.md');

disp(T_summary);
disp(T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :));
disp(T_sig);
disp(T_stage_sig);
disp('Step 22 complete: forest geometry plus validation generated.');
