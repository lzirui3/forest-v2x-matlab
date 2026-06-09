clc;
clear;
close all;

% Step 11:
% Sensitivity analysis for the confidence-driven scheduling method.

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

cases = get_default_step11_sensitivity_cases();
results = [];

for i = 1:numel(cases)
    for j = 1:numel(cases(i).values)
        result = run_single_step11_sensitivity_case(cases(i).param_name, cases(i).values(j));
        if isempty(results)
            results = result;
        else
            results(end + 1) = result; %#ok<AGROW>
        end
    end
end

T = build_step11_sensitivity_table(results);
disp(T);

writetable(T, 'step11_sensitivity_results.csv');
write_step11_sensitivity_report(T, 'step11_sensitivity_report.md');
plot_step11_sensitivity_results(T);

disp('Step 11 complete: sensitivity analysis generated.');
