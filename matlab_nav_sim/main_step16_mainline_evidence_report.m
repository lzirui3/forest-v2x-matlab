clc;
clear;
close all;

raw_path = 'step15_default_vs_forest_multiseed_raw.csv';
stage_raw_path = 'step15_default_vs_forest_multiseed_stage_raw.csv';

if ~isfile(raw_path) || ~isfile(stage_raw_path)
    error('Step15 raw files are missing. Run main_step15_default_vs_forest_multiseed first.');
end

T_raw = readtable(raw_path, 'TextType', 'string');
T_stage = readtable(stage_raw_path, 'TextType', 'string');

configs = ["Default", "ForestGeometry"];
rows_all = [];
rows_posdeg = [];

for i = 1:numel(configs)
    cfg = configs(i);

    T_cfg = T_raw(T_raw.Config == cfg, :);
    T_stat = compute_step12_statistical_tests(T_cfg, "Link-delay-aware", "Confidence-driven");
    T_stat.Config = repmat(cfg, height(T_stat), 1);
    T_stat = movevars(T_stat, 'Config', 'Before', 'Metric');

    if isempty(rows_all)
        rows_all = T_stat;
    else
        rows_all = [rows_all; T_stat]; %#ok<AGROW>
    end

    T_pos = T_stage(T_stage.Config == cfg & T_stage.Stage == "PosDeg_Emerg", :);
    T_pos_stat = compute_step12_statistical_tests(T_pos, "Link-delay-aware", "Confidence-driven");
    T_pos_stat.Config = repmat(cfg, height(T_pos_stat), 1);
    T_pos_stat.Stage = repmat("PosDeg_Emerg", height(T_pos_stat), 1);
    T_pos_stat = movevars(T_pos_stat, {'Config','Stage'}, 'Before', 'Metric');

    if isempty(rows_posdeg)
        rows_posdeg = T_pos_stat;
    else
        rows_posdeg = [rows_posdeg; T_pos_stat]; %#ok<AGROW>
    end
end

writetable(rows_all, 'step16_mainline_significance_overall.csv');
writetable(rows_posdeg, 'step16_mainline_significance_posdeg.csv');

write_step16_mainline_evidence_report(rows_all, rows_posdeg, 'step16_mainline_evidence_report.md');

disp(rows_all);
disp(rows_posdeg);
disp('Step 16 complete: mainline evidence report generated.');
