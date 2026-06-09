clc;
clear;
close all;

% Step 9 external-input demo:
% Use data-backed trajectory / RSU / blockage / GNSS profiles.

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

params = get_default_step9_params();
params.scenario_input = get_default_step9_data_backed_config();

scenario = generate_step9_scenario(params);

fixed_result = run_step9_baseline_fixed(scenario, params);
link_result = run_step9_baseline_link_only(scenario, params);
conf_result = run_step9_confidence_driven(scenario, params);

T = evaluate_step9_metrics(scenario, {fixed_result, link_result, conf_result});
disp(T);

disp('Step 9 external demo complete.');
