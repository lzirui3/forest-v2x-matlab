function write_step16_mainline_evidence_report(T_overall, T_posdeg, output_path)
%WRITE_STEP16_MAINLINE_EVIDENCE_REPORT Write a focused evidence report.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 16 report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 16 Mainline Evidence Report\n\n');
fprintf(fid, 'This report summarizes the multi-seed evidence for the main comparison:\n');
fprintf(fid, '- `Confidence-driven` vs `Link-delay-aware`\n');
fprintf(fid, '- under `Default` and `ForestGeometry` parameter settings.\n\n');

fprintf(fid, '## Overall Statistical Comparison\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_overall)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_overall.Config(i), T_overall.Metric(i), ...
        T_overall.Baseline_Mean(i), T_overall.Proposed_Mean(i), T_overall.Delta_Mean(i), ...
        T_overall.CI_Lower(i), T_overall.CI_Upper(i), T_overall.P_Value(i), T_overall.Significant(i));
end

fprintf(fid, '\n## PosDeg_Emerg Statistical Comparison\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_posdeg)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_posdeg.Config(i), T_posdeg.Metric(i), ...
        T_posdeg.Baseline_Mean(i), T_posdeg.Proposed_Mean(i), T_posdeg.Delta_Mean(i), ...
        T_posdeg.CI_Lower(i), T_posdeg.CI_Upper(i), T_posdeg.P_Value(i), T_posdeg.Significant(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- If the overall `TimelyRate` and `LossRate` deltas are positive/negative with statistically meaningful confidence intervals, the mainline method has stable average benefit.\n');
fprintf(fid, '- If the `PosDeg_Emerg` deltas are stronger than the overall deltas, the method value is concentrated in the intended blind-zone degradation regime.\n');
fprintf(fid, '- The `ForestGeometry` configuration is the more application-relevant evidence for the current paper topic.\n');
end
