clc;
clear;
close all;

% Stage-wise statistics for Step 8 fixed vs adaptive constraint scheduling.

results = run_step8_fixed_vs_adaptive_constraints();
stages = define_stage_masks(results.truth.t);

method_names = {'Fixed constraints', 'Adaptive constraints'};
metrics_list = { ...
    compute_stage_metrics(results.fixed_nhc.pos_err, stages), ...
    compute_stage_metrics(results.adaptive_nhc.pos_err, stages)};

T = build_stage_metrics_table(method_names, metrics_list);
T_rmse = build_rmse_wide_table(T);
T_imp = build_improvement_table(T, 'Fixed constraints');

writetable(T, 'step8_stage_metrics_table.csv');
writetable(T_rmse, 'step8_stage_rmse_wide_table.csv');
writetable(T_imp, 'step8_stage_improvement_vs_fixed.csv');

disp('Generated files:');
disp('  step8_stage_metrics_table.csv');
disp('  step8_stage_rmse_wide_table.csv');
disp('  step8_stage_improvement_vs_fixed.csv');
