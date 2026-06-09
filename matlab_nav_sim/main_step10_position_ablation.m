clc;
clear;
close all;

% Step 10:
% Position-confidence module ablation study.

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

params = get_default_step9_mainline_params();
cases = get_default_step10_ablation_cases();

scenario_cases = cell(numel(cases), 1);
results = cell(numel(cases) + 2, 1);
method_names = cell(numel(cases) + 2, 1);

base_scenario = generate_step9_scenario(params, cases(1).modules);
link_result = run_step9_baseline_link_only(base_scenario, params);
results{1} = link_result;
method_names{1} = char(link_result.name);

scenario_no_regime = generate_step9_scenario(params, cases(1).modules);
no_regime_result = run_step9_confidence_driven_no_regime_gate(scenario_no_regime, params);
results{2} = no_regime_result;
method_names{2} = char(no_regime_result.name);

for i = 1:numel(cases)
    scenario_cases{i} = generate_step9_scenario(params, cases(i).modules);
    result_case = run_step9_confidence_driven(scenario_cases{i}, params);
    result_case.name = string(cases(i).name);
    results{i + 2} = result_case;
    method_names{i + 2} = char(cases(i).name);
end

T = evaluate_step9_metrics(base_scenario, results);
disp(T);

stages = define_step9_stage_masks(base_scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(base_scenario, results{i}, stages);
end

T_stage = build_step9_stage_metrics_table(method_names, metrics_list);
disp(T_stage);

T_imp = build_step10_ablation_improvement_table(T, 'Full');
disp(T_imp);

T_stage_imp = build_step9_stage_improvement_table(T_stage, 'Full');
disp(T_stage_imp);

effective_threshold = 0.50;
scenario_for_effective = [{base_scenario}; {scenario_no_regime}; scenario_cases];
T_effective = build_step10_effective_warning_table(method_names, scenario_for_effective, results, effective_threshold);
T_effective_imp = build_step10_effective_warning_improvement_table(T_effective, 'Full');
disp(T_effective);
disp(T_effective_imp);

plot_step10_ablation_results(base_scenario, scenario_cases, T, T_stage);
writetable(T, 'step10_ablation_metrics_table.csv');
writetable(T_stage, 'step10_ablation_stage_metrics_table.csv');
writetable(T_imp, 'step10_ablation_vs_full.csv');
writetable(T_stage_imp, 'step10_ablation_stage_vs_full.csv');
writetable(T_effective, 'step10_effective_warning_table.csv');
writetable(T_effective_imp, 'step10_effective_warning_vs_full.csv');
write_step10_ablation_report(T, T_imp, T_stage, T_stage_imp, T_effective, T_effective_imp, 'step10_position_ablation_report.md');

disp('Step 10 complete: position-confidence ablation study generated.');
