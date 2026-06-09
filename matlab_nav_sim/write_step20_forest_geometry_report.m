function write_step20_forest_geometry_report(T_summary, T_stage_summary, T_sig, T_stage_sig, out_path)
%WRITE_STEP20_FOREST_GEOMETRY_REPORT Focused report for Step20.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step20 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 20 Forest Geometry Report\n\n');
fprintf(fid, 'This report compares three configurations:\n');
fprintf(fid, '- `Generic`: default mainline scenario\n');
fprintf(fid, '- `ForestParam`: forest-calibrated parameter setting\n');
fprintf(fid, '- `ForestGeometryDemo`: forest geometry driven external inputs\n\n');

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

fprintf(fid, '\n## Confidence-driven vs Link-delay-aware Overall Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_sig)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_sig.Config(i), T_sig.Metric(i), ...
        T_sig.Baseline_Mean(i), T_sig.Proposed_Mean(i), T_sig.Delta_Mean(i), ...
        T_sig.CI_Lower(i), T_sig.CI_Upper(i), T_sig.P_Value(i), T_sig.Significant(i));
end

fprintf(fid, '\n## Confidence-driven vs Link-delay-aware PosDeg_Emerg Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_stage_sig)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_stage_sig.Config(i), T_stage_sig.Metric(i), ...
        T_stage_sig.Baseline_Mean(i), T_stage_sig.Proposed_Mean(i), T_stage_sig.Delta_Mean(i), ...
        T_stage_sig.CI_Lower(i), T_stage_sig.CI_Upper(i), T_stage_sig.P_Value(i), T_stage_sig.Significant(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- If `ForestGeometryDemo` remains harder than `ForestParam`, the geometry-driven inputs are imposing additional realism rather than merely renaming the calibrated setting.\n');
fprintf(fid, '- If the confidence-driven advantage persists under `ForestGeometryDemo`, the forest-specific contribution is strengthened.\n');
fprintf(fid, '- If cost rises sharply under `ForestGeometryDemo`, the next step is to redesign scheduling conservatism specifically for geometry-driven blind zones.\n');
end
