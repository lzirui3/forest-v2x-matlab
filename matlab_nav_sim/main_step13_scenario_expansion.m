clc;
clear;
close all;

% Step 13:
% Scenario expansion study across GNSS degradation, RSU sparsity, and load.

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
set(groot, 'defaultTextColor', 'k');
set(groot, 'defaultLegendTextColor', 'k');
set(groot, 'defaultColorBarColor', 'k');

profiles = get_default_step13_scenario_profiles();
T_raw = [];

for i = 1:numel(profiles.gnss_levels)
    for j = 1:numel(profiles.rsu_levels)
        for k = 1:numel(profiles.load_levels)
            scenario_id = sprintf('G%s_R%s_L%s', ...
                extractBefore(profiles.gnss_levels(i), 2), ...
                extractBefore(profiles.rsu_levels(j), 2), ...
                extractBefore(profiles.load_levels(k), 2));

            for seed = 1:profiles.num_seeds
                params = get_default_step9_mainline_params();
                params.random_seed = seed;
                params = apply_step13_scenario_profile(params, ...
                    profiles.gnss_levels(i), profiles.rsu_levels(j), profiles.load_levels(k));

                base_scenario = generate_step9_scenario(params);

                result_link = run_step9_baseline_link_only(base_scenario, params);
                result_full = run_step9_confidence_driven(base_scenario, params);

                no_rsu_modules = get_default_position_module_config();
                no_rsu_modules.use_rsu = false;
                no_rsu_modules.name = "No-RSU";
                no_rsu_scenario = generate_step9_scenario(params, no_rsu_modules);
                result_no_rsu = run_step9_confidence_driven(no_rsu_scenario, params);
                result_no_rsu.name = "No-RSU";

                results = {result_link, result_full, result_no_rsu};
                method_names = ["Link-aware", "Full", "No-RSU"];
                stage_source = {base_scenario, base_scenario, no_rsu_scenario};

                for m = 1:numel(results)
                    T_one = evaluate_step9_metrics(stage_source{m}, results(m));
                    stages = define_step9_stage_masks(stage_source{m}.t);
                    metrics = compute_step9_stage_metrics(stage_source{m}, results{m}, stages);
                    posdeg_metric = get_stage_metric(metrics, 'PosDeg_Emerg');

                    row = T_one(:, :);
                    row.ScenarioID = string(scenario_id);
                    row.GNSSLevel = profiles.gnss_levels(i);
                    row.RSULevel = profiles.rsu_levels(j);
                    row.LoadLevel = profiles.load_levels(k);
                    row.Seed = seed;
                    row.Method = method_names(m);
                    row.PosDegEmergencyTimelyRate = posdeg_metric.emergency_timely_rate;
                    row.PosDegAvgTxCost = posdeg_metric.avg_tx_cost;
                    effective_metric = compute_step9_effective_warning_metrics(stage_source{m}, results{m}, 0.50);
                    row.EffectiveWarningRate = effective_metric.posdeg_effective_warning_rate;
                    row.EffectiveCoverage = effective_metric.posdeg_effective_coverage;
                    row.EffectiveCount = effective_metric.posdeg_effective_count;
                    row = movevars(row, {'ScenarioID', 'GNSSLevel', 'RSULevel', 'LoadLevel', 'Seed'}, 'Before', 'Method');

                    if isempty(T_raw)
                        T_raw = row;
                    else
                        T_raw = [T_raw; row]; %#ok<AGROW>
                    end
                end
            end
        end
    end
end

T_summary = build_step13_summary_table(T_raw);

disp(T_summary);

writetable(T_raw, 'step13_scenario_metrics_raw.csv');
writetable(T_summary, 'step13_scenario_summary.csv');
write_step13_scenario_report(T_summary, 'step13_scenario_report.md', profiles);
plot_step13_scenario_expansion(T_summary, profiles);

disp('Step 13 complete: scenario expansion study generated.');

function metric = get_stage_metric(metrics, stage_name)
metric = struct('stage', stage_name, 'avg_delay_s', NaN, 'timely_rate', NaN, ...
    'loss_rate', NaN, 'avg_tx_cost', NaN, 'emergency_timely_rate', NaN);
for ii = 1:numel(metrics)
    if strcmp(metrics(ii).stage, stage_name)
        metric = metrics(ii);
        return;
    end
end
end
