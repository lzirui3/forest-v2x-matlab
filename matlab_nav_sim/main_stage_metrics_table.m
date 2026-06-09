clc;
clear;
close all;

% Build a stage-wise error statistics table for all current methods.

results = run_all_navigation_methods();
truth = results.truth;

stages = define_stage_masks(truth.t);
method_names = cell(1, numel(results.methods));
metrics_list = cell(1, numel(results.methods));
for i = 1:numel(results.methods)
    method_names{i} = results.methods(i).name;
    metrics_list{i} = compute_stage_metrics(results.methods(i).err, stages);
end

T = build_stage_metrics_table(method_names, metrics_list);
print_stage_metrics_table(T);

writetable(T, 'stage_metrics_table.csv');

disp('Stage metrics table exported to stage_metrics_table.csv');
