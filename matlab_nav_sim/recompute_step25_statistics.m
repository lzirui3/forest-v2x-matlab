cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim');

rows = readtable('step25_literature_baselines_raw.csv');
stage_rows = readtable('step25_literature_baselines_stage_raw.csv');
T_summary = readtable('step25_literature_baselines_summary.csv');
T_stage_summary = readtable('step25_literature_baselines_stage_summary.csv');

T_summary.Config = string(T_summary.Config);
T_summary.Method = string(T_summary.Method);
T_stage_summary.Config = string(T_stage_summary.Config);
T_stage_summary.Method = string(T_stage_summary.Method);
T_stage_summary.Stage = string(T_stage_summary.Stage);

rows.Config = string(rows.Config);
rows.Method = string(rows.Method);
stage_rows.Config = string(stage_rows.Config);
stage_rows.Method = string(stage_rows.Method);
stage_rows.Stage = string(stage_rows.Stage);

T_sig_dcc = build_step25_significance(rows, "DCC-like", "Confidence-driven");
T_sig_aoi = build_step25_significance(rows, "AoI-aware", "Confidence-driven");
T_stage_sig_dcc = build_step25_stage_significance(stage_rows, "PosDeg_Emerg", "DCC-like", "Confidence-driven");
T_stage_sig_aoi = build_step25_stage_significance(stage_rows, "PosDeg_Emerg", "AoI-aware", "Confidence-driven");

T_sig_dcc = apply_familywise_holm_to_stats_table(T_sig_dcc);
T_sig_aoi = apply_familywise_holm_to_stats_table(T_sig_aoi);
T_stage_sig_dcc = apply_familywise_holm_to_stats_table(T_stage_sig_dcc);
T_stage_sig_aoi = apply_familywise_holm_to_stats_table(T_stage_sig_aoi);

writetable(T_sig_dcc, 'step25_literature_baselines_dcc_significance.csv');
writetable(T_sig_aoi, 'step25_literature_baselines_aoi_significance.csv');
writetable(T_stage_sig_dcc, 'step25_literature_baselines_dcc_posdeg_significance.csv');
writetable(T_stage_sig_aoi, 'step25_literature_baselines_aoi_posdeg_significance.csv');

write_step25_literature_baselines_report( ...
    T_summary, T_stage_summary, T_sig_dcc, T_sig_aoi, T_stage_sig_dcc, T_stage_sig_aoi, ...
    'step25_literature_baselines_report.md');

disp(T_sig_dcc);
disp(T_sig_aoi);
disp(T_stage_sig_dcc);
disp(T_stage_sig_aoi);
