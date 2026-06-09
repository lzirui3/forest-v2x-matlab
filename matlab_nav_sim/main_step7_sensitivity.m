clc;
clear;
close all;

% Step 7:
% Parameter sensitivity analysis for the residual-adaptive + NHC method.

cases = {};

cases{end+1}.param_name = 'residual_bad_threshold';
cases{end}.values = [3.0, 4.5, 6.0, 8.0];

cases{end+1}.param_name = 'residual_ema_decay';
cases{end}.values = [0.80, 0.88, 0.92, 0.96];

cases{end+1}.param_name = 'zupt_velocity_gain';
cases{end}.values = [0.05, 0.15, 0.30, 0.50];

cases{end+1}.param_name = 'nhc_velocity_gain';
cases{end}.values = [0.50, 0.70, 0.90, 0.98];

results = [];

for i = 1:numel(cases)
    for j = 1:numel(cases{i}.values)
        result = run_single_sensitivity_case(cases{i}.param_name, cases{i}.values(j));
        if isempty(results)
            results = result;
        else
            results(end+1) = result; %#ok<AGROW>
        end
    end
end

T = build_sensitivity_table(results);
writetable(T, 'sensitivity_results.csv');
write_sensitivity_report(T, 'sensitivity_report.md');

disp('Generated files:');
disp('  sensitivity_results.csv');
disp('  sensitivity_report.md');
