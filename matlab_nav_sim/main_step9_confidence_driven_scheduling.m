clc;
clear;
close all;

% Step 9:
% Rule-based confidence-driven adaptive scheduling prototype.

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
scenario = generate_step9_scenario(params);

fixed_result = run_step9_baseline_fixed(scenario, params);
priority_result = run_step9_baseline_priority_only(scenario, params);
link_result = run_step9_baseline_link_only(scenario, params);
link_delayaware_result = run_step9_baseline_link_delayaware(scenario, params);
position_result = run_step9_baseline_position_only(scenario, params);
fused_rule_result = run_step9_baseline_fused_rule(scenario, params);
event_result = run_step9_baseline_event_only(scenario, params);
oracle_result = run_step9_baseline_oracle(scenario, params);
conf_result = run_step9_confidence_driven(scenario, params);

results = { ...
    fixed_result, ...
    priority_result, ...
    link_result, ...
    link_delayaware_result, ...
    position_result, ...
    fused_rule_result, ...
    event_result, ...
    oracle_result, ...
    conf_result};
T = evaluate_step9_metrics(scenario, results);
disp(T);

stages = define_step9_stage_masks(scenario.t);
metrics_fixed = compute_step9_stage_metrics(scenario, fixed_result, stages);
metrics_priority = compute_step9_stage_metrics(scenario, priority_result, stages);
metrics_link = compute_step9_stage_metrics(scenario, link_result, stages);
metrics_link_delayaware = compute_step9_stage_metrics(scenario, link_delayaware_result, stages);
metrics_position = compute_step9_stage_metrics(scenario, position_result, stages);
metrics_fused_rule = compute_step9_stage_metrics(scenario, fused_rule_result, stages);
metrics_event = compute_step9_stage_metrics(scenario, event_result, stages);
metrics_oracle = compute_step9_stage_metrics(scenario, oracle_result, stages);
metrics_conf = compute_step9_stage_metrics(scenario, conf_result, stages);

T_stage = build_step9_stage_metrics_table( ...
    {'Fixed', 'Priority-only', 'Link-aware', 'Link-delay-aware', 'Position-only', 'Fused-rule', 'Blind-zone-event-only', 'Constrained Oracle', 'Confidence-driven'}, ...
    {metrics_fixed, metrics_priority, metrics_link, metrics_link_delayaware, metrics_position, metrics_fused_rule, metrics_event, metrics_oracle, metrics_conf});
disp(T_stage);

T_stage_imp = build_step9_stage_improvement_table(T_stage, 'Link-aware');
disp(T_stage_imp);

plot_step9_scheduling_results(scenario, fixed_result, link_result, conf_result, T);
write_step9_metrics_report(T, 'step9_metrics_report.md');
writetable(T, 'step9_metrics_table.csv');
writetable(T_stage, 'step9_stage_metrics_table.csv');
writetable(T_stage_imp, 'step9_stage_improvement_vs_link.csv');
write_step9_stage_report(T_stage, T_stage_imp, 'step9_stage_report.md');

disp('Step 9 complete: confidence-driven adaptive scheduling prototype generated.');
