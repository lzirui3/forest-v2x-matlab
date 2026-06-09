cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim');

T = readtable('step19_per_lookup_validation_raw.csv');
Ts = build_step19_pdr_mode_significance(T, "Confidence-driven");
writetable(Ts, 'step19_per_lookup_validation_overall_significance.csv');

Tstage = readtable('step19_per_lookup_validation_stage_raw.csv');
Tps = build_step19_pdr_mode_significance( ...
    Tstage(Tstage.Stage == "PosDeg_Emerg", :), "Confidence-driven");
writetable(Tps, 'step19_per_lookup_validation_posdeg_significance.csv');

write_step19_per_lookup_validation_report( ...
    readtable('step19_per_lookup_validation_overall_delta.csv'), ...
    readtable('step19_per_lookup_validation_posdeg_delta.csv'), ...
    Ts, Tps, ...
    'step19_per_lookup_validation_report.md');

disp(Ts);
disp(Tps);
