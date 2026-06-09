cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim');

prefix = 'step17_main3';
T_raw = readtable([prefix '_paper_statistics_raw.csv']);
T_stage_raw = readtable([prefix '_paper_statistics_stage_raw.csv']);
T_summary = readtable([prefix '_paper_statistics_summary.csv']);
T_stage_summary = readtable([prefix '_paper_statistics_stage_summary.csv']);

T_summary.Scene = string(T_summary.Scene);
T_summary.SceneRole = string(T_summary.SceneRole);
T_summary.GeometryType = string(T_summary.GeometryType);
T_summary.DensityClass = string(T_summary.DensityClass);
T_summary.VegetationClass = string(T_summary.VegetationClass);
T_summary.Config = string(T_summary.Config);
T_summary.Method = string(T_summary.Method);
T_stage_summary.Scene = string(T_stage_summary.Scene);
T_stage_summary.SceneRole = string(T_stage_summary.SceneRole);
T_stage_summary.GeometryType = string(T_stage_summary.GeometryType);
T_stage_summary.DensityClass = string(T_stage_summary.DensityClass);
T_stage_summary.VegetationClass = string(T_stage_summary.VegetationClass);
T_stage_summary.Config = string(T_stage_summary.Config);
T_stage_summary.Method = string(T_stage_summary.Method);
T_stage_summary.Stage = string(T_stage_summary.Stage);

T_raw.Scene = string(T_raw.Scene);
T_raw.Config = string(T_raw.Config);
T_raw.Method = string(T_raw.Method);
T_stage_raw.Scene = string(T_stage_raw.Scene);
T_stage_raw.Config = string(T_stage_raw.Config);
T_stage_raw.Method = string(T_stage_raw.Method);
T_stage_raw.Stage = string(T_stage_raw.Stage);

scenes = unique(T_raw.Scene, 'stable');
configs = unique(T_raw.Config, 'stable');

T_sig = [];
T_sig_posdeg = [];

for i = 1:numel(scenes)
    for j = 1:numel(configs)
        T_cfg = T_raw(T_raw.Scene == scenes(i) & T_raw.Config == configs(j), :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, "Link-delay-aware", "Confidence-driven");
        T_cfg_stat.Scene = repmat(scenes(i), height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(configs(j), height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');
        if isempty(T_sig)
            T_sig = T_cfg_stat;
        else
            T_sig = [T_sig; T_cfg_stat]; %#ok<AGROW>
        end

        T_pos = T_stage_raw(T_stage_raw.Scene == scenes(i) & T_stage_raw.Config == configs(j) & T_stage_raw.Stage == "PosDeg_Emerg", :);
        T_pos_stat = compute_step12_statistical_tests(T_pos, "Link-delay-aware", "Confidence-driven");
        T_pos_stat.Scene = repmat(scenes(i), height(T_pos_stat), 1);
        T_pos_stat.Config = repmat(configs(j), height(T_pos_stat), 1);
        T_pos_stat.Stage = repmat("PosDeg_Emerg", height(T_pos_stat), 1);
        T_pos_stat = movevars(T_pos_stat, {'Scene','Config','Stage'}, 'Before', 'Metric');
        if isempty(T_sig_posdeg)
            T_sig_posdeg = T_pos_stat;
        else
            T_sig_posdeg = [T_sig_posdeg; T_pos_stat]; %#ok<AGROW>
        end
    end
end

T_sig = apply_familywise_holm_to_stats_table(T_sig);
T_sig_posdeg = apply_familywise_holm_to_stats_table(T_sig_posdeg);

writetable(T_sig, [prefix '_paper_statistics_significance.csv']);
writetable(T_sig_posdeg, [prefix '_paper_statistics_posdeg_significance.csv']);

write_step17_paper_statistics_report(T_summary, T_stage_summary, T_sig, T_sig_posdeg, ...
    [prefix '_paper_statistics_report.md']);

disp(T_sig);
disp(T_sig_posdeg);
