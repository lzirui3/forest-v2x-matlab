clc;
clear;
close all;

raw_path = 'step21_forest_geometry_matrix_raw.csv';
stage_raw_path = 'step21_forest_geometry_matrix_stage_raw.csv';

if ~isfile(raw_path) || ~isfile(stage_raw_path)
    error('Step21 raw files are missing. Run main_step21_forest_geometry_matrix_multiseed first.');
end

T_raw = readtable(raw_path, 'TextType', 'string');
T_stage = readtable(stage_raw_path, 'TextType', 'string');

T_summary = build_step21_summary_table(T_raw);
T_stage_summary = build_step21_stage_summary_table(T_stage);
T_sig = build_step21_significance(T_raw, "Link-delay-aware", "Confidence-driven");
T_stage_sig = build_step21_stage_significance(T_stage, "PosDeg_Emerg", "Link-delay-aware", "Confidence-driven");

writetable(T_summary, 'step21_forest_geometry_matrix_summary.csv');
writetable(T_stage_summary, 'step21_forest_geometry_matrix_stage_summary.csv');
writetable(T_sig, 'step21_forest_geometry_matrix_significance.csv');
writetable(T_stage_sig, 'step21_forest_geometry_matrix_posdeg_significance.csv');

write_step21_forest_geometry_matrix_report( ...
    T_summary, T_stage_summary, T_sig, T_stage_sig, ...
    'step21_forest_geometry_matrix_report.md');

disp(T_summary);
disp(T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :));
disp(T_sig);
disp(T_stage_sig);
disp('Step 21 report complete: forest geometry matrix summary generated.');
