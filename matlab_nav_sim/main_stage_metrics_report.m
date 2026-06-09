clc;
clear;
close all;

% Generate paper-oriented stage statistics reports and tables.

results = run_all_navigation_methods();
stages = define_stage_masks(results.truth.t);

method_names = cell(1, numel(results.methods));
metrics_list = cell(1, numel(results.methods));
for i = 1:numel(results.methods)
    method_names{i} = results.methods(i).name;
    metrics_list{i} = compute_stage_metrics(results.methods(i).err, stages);
end

T = build_stage_metrics_table(method_names, metrics_list);
T_rmse = build_rmse_wide_table(T);
T_imp = build_improvement_table(T, 'Baseline fusion');

writetable(T, 'stage_metrics_table.csv');
writetable(T_rmse, 'stage_rmse_wide_table.csv');
writetable(T_imp, 'stage_improvement_vs_baseline.csv');
write_stage_metrics_report(T, T_imp, 'stage_metrics_report.md');

disp('Generated files:');
disp('  stage_metrics_table.csv');
disp('  stage_rmse_wide_table.csv');
disp('  stage_improvement_vs_baseline.csv');
disp('  stage_metrics_report.md');
