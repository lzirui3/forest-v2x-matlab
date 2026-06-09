function write_step21_forest_geometry_matrix_report(T_summary, T_stage_summary, T_sig, T_stage_sig, out_path)
%WRITE_STEP21_FOREST_GEOMETRY_MATRIX_REPORT Write focused matrix report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step21 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 21 Forest Geometry Matrix Report\n\n');
fprintf(fid, 'This report summarizes the 3x3 forest geometry matrix:\n');
fprintf(fid, '- Profiles: `straight`, `curved`, `blind`\n');
fprintf(fid, '- Vegetation: `sparse`, `medium`, `dense`\n');
fprintf(fid, '- Main comparison: `Confidence-driven` vs `Link-delay-aware`\n\n');

fprintf(fid, '## Overall Mean Summary\n\n');
fprintf(fid, '| Config | Profile | Vegetation | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        T_summary.Config(i), T_summary.Profile(i), T_summary.Vegetation(i), T_summary.Method(i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), T_summary.AvgDelayMean(i), ...
        T_summary.AvgTxCostMean(i), T_summary.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## PosDeg_Emerg Mean Summary\n\n');
fprintf(fid, '| Config | Profile | Vegetation | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|---:|\n');
T_pos = T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :);
for i = 1:height(T_pos)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        T_pos.Config(i), T_pos.Profile(i), T_pos.Vegetation(i), T_pos.Method(i), ...
        T_pos.TimelyRateMean(i), T_pos.LossRateMean(i), T_pos.AvgDelayMean(i), ...
        T_pos.AvgTxCostMean(i), T_pos.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Confidence-driven vs Link-delay-aware Overall Significance\n\n');
fprintf(fid, '| Config | Profile | Vegetation | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_sig)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_sig.Config(i), T_sig.Profile(i), T_sig.Vegetation(i), T_sig.Metric(i), ...
        T_sig.Baseline_Mean(i), T_sig.Proposed_Mean(i), T_sig.Delta_Mean(i), ...
        T_sig.CI_Lower(i), T_sig.CI_Upper(i), T_sig.P_Value(i), T_sig.Significant(i));
end

fprintf(fid, '\n## Confidence-driven vs Link-delay-aware PosDeg_Emerg Significance\n\n');
fprintf(fid, '| Config | Profile | Vegetation | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_stage_sig)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_stage_sig.Config(i), T_stage_sig.Profile(i), T_stage_sig.Vegetation(i), T_stage_sig.Metric(i), ...
        T_stage_sig.Baseline_Mean(i), T_stage_sig.Proposed_Mean(i), T_stage_sig.Delta_Mean(i), ...
        T_stage_sig.CI_Lower(i), T_stage_sig.CI_Upper(i), T_stage_sig.P_Value(i), T_stage_sig.Significant(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- If gains concentrate in `curved/blind + medium/dense` settings, the method value is specifically tied to high-risk forest geometry rather than generic easy scenarios.\n');
fprintf(fid, '- If gains vanish in `straight + sparse`, this is expected and can be framed as a targeted rather than universal scheduling advantage.\n');
fprintf(fid, '- The matrix should be used to argue forest-scene specificity and geometry-aware robustness.\n');
end
