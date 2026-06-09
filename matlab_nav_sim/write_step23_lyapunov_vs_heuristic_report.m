function write_step23_lyapunov_vs_heuristic_report(T_summary, T_stage_summary, T_sig, T_stage_sig, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step23 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 23 Lyapunov vs Heuristic Report\n\n');
fprintf(fid, 'This report compares the legacy heuristic confidence scheduler with the Lyapunov drift-plus-penalty scheduler.\n\n');

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

fprintf(fid, '\n## Lyapunov vs Heuristic Overall Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_sig)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_sig.Config(i), T_sig.Metric(i), ...
        T_sig.Baseline_Mean(i), T_sig.Proposed_Mean(i), T_sig.Delta_Mean(i), ...
        T_sig.CI_Lower(i), T_sig.CI_Upper(i), T_sig.P_Value(i), T_sig.Significant(i));
end

fprintf(fid, '\n## Lyapunov vs Heuristic PosDeg_Emerg Significance\n\n');
fprintf(fid, '| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95%% CI | p-value | Significance |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_stage_sig)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | [%.4f, %.4f] | %.4g | %s |\n', ...
        T_stage_sig.Config(i), T_stage_sig.Metric(i), ...
        T_stage_sig.Baseline_Mean(i), T_stage_sig.Proposed_Mean(i), T_stage_sig.Delta_Mean(i), ...
        T_stage_sig.CI_Lower(i), T_stage_sig.CI_Upper(i), T_stage_sig.P_Value(i), T_stage_sig.Significant(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- The Lyapunov scheduler provides a mathematically grounded drift-plus-penalty control law instead of a purely heuristic score combiner.\n');
fprintf(fid, '- If performance remains comparable while cost-performance tradeoff becomes tunable through `V`, the formalized scheduler resolves the main theoretical criticism.\n');
fprintf(fid, '- If Lyapunov significantly underperforms in specific scenes, the paper should present it as a theoretically grounded variant and discuss the gap to the heuristic baseline.\n');
end
