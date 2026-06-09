function write_step25_literature_baselines_report(T_summary, T_stage_summary, T_sig_dcc, T_sig_aoi, T_stage_sig_dcc, T_stage_sig_aoi, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step25 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 25 Literature Baselines Report\n\n');
fprintf(fid, 'This report compares the proposed confidence-driven scheduler against two literature-inspired baselines:\n');
fprintf(fid, '- `DCC-like`: ETSI DCC style congestion-responsive rate control\n');
fprintf(fid, '- `AoI-aware`: Age-of-Information aware priority scheduling\n\n');

fprintf(fid, '## Overall Mean Summary\n\n');
fprintf(fid, '| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        T_summary.Config(i), T_summary.Method(i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), ...
        T_summary.AvgDelayMean(i), T_summary.AvgTxCostMean(i), ...
        T_summary.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## PosDeg_Emerg Mean Summary\n\n');
fprintf(fid, '| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|\n');
T_pos = T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :);
for i = 1:height(T_pos)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        T_pos.Config(i), T_pos.Method(i), ...
        T_pos.TimelyRateMean(i), T_pos.LossRateMean(i), ...
        T_pos.AvgDelayMean(i), T_pos.AvgTxCostMean(i), ...
        T_pos.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Confidence-driven vs DCC-like Overall Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_sig_dcc)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        T_sig_dcc.Config(i), T_sig_dcc.Metric(i), ...
        T_sig_dcc.Baseline_Mean(i), T_sig_dcc.Proposed_Mean(i), T_sig_dcc.Delta_Mean(i), T_sig_dcc.DeltaPct(i), ...
        T_sig_dcc.CI_Lower(i), T_sig_dcc.CI_Upper(i), T_sig_dcc.P_Value_Display(i), ...
        T_sig_dcc.P_Value_Holm_Family_Display(i), T_sig_dcc.EffectSize_RBC(i), T_sig_dcc.PracticalNote(i));
end

fprintf(fid, '\n## Confidence-driven vs AoI-aware Overall Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_sig_aoi)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        T_sig_aoi.Config(i), T_sig_aoi.Metric(i), ...
        T_sig_aoi.Baseline_Mean(i), T_sig_aoi.Proposed_Mean(i), T_sig_aoi.Delta_Mean(i), T_sig_aoi.DeltaPct(i), ...
        T_sig_aoi.CI_Lower(i), T_sig_aoi.CI_Upper(i), T_sig_aoi.P_Value_Display(i), ...
        T_sig_aoi.P_Value_Holm_Family_Display(i), T_sig_aoi.EffectSize_RBC(i), T_sig_aoi.PracticalNote(i));
end

fprintf(fid, '\n## Confidence-driven vs DCC-like PosDeg_Emerg Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_stage_sig_dcc)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        T_stage_sig_dcc.Config(i), T_stage_sig_dcc.Metric(i), ...
        T_stage_sig_dcc.Baseline_Mean(i), T_stage_sig_dcc.Proposed_Mean(i), T_stage_sig_dcc.Delta_Mean(i), T_stage_sig_dcc.DeltaPct(i), ...
        T_stage_sig_dcc.CI_Lower(i), T_stage_sig_dcc.CI_Upper(i), T_stage_sig_dcc.P_Value_Display(i), ...
        T_stage_sig_dcc.P_Value_Holm_Family_Display(i), T_stage_sig_dcc.EffectSize_RBC(i), T_stage_sig_dcc.PracticalNote(i));
end

fprintf(fid, '\n## Confidence-driven vs AoI-aware PosDeg_Emerg Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_stage_sig_aoi)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        T_stage_sig_aoi.Config(i), T_stage_sig_aoi.Metric(i), ...
        T_stage_sig_aoi.Baseline_Mean(i), T_stage_sig_aoi.Proposed_Mean(i), T_stage_sig_aoi.Delta_Mean(i), T_stage_sig_aoi.DeltaPct(i), ...
        T_stage_sig_aoi.CI_Lower(i), T_stage_sig_aoi.CI_Upper(i), T_stage_sig_aoi.P_Value_Display(i), ...
        T_stage_sig_aoi.P_Value_Holm_Family_Display(i), T_stage_sig_aoi.EffectSize_RBC(i), T_stage_sig_aoi.PracticalNote(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- If the confidence-driven scheduler still dominates DCC-like and AoI-aware baselines in the harder forest-relevant scenes, the lack of literature baselines is no longer a critical weakness.\n');
fprintf(fid, '- DCC-like should be interpreted as a communication-standard baseline focused on congestion control rather than blind-zone awareness.\n');
fprintf(fid, '- AoI-aware should be interpreted as a freshness-driven scheduling baseline that ignores cooperative positioning uncertainty.\n');
fprintf(fid, '- Rows marked `Below1pp` or `Sub-ms` should be discussed as statistically detectable but potentially weak in engineering significance.\n');
end
