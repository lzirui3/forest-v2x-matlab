function write_step30_lyapunov_vtc_report( ...
    T_summary, T_stage_summary, T_sig_h_vs_l, T_sig_pos_h_vs_l, ...
    T_sig_link_vs_l, T_decision, out_path)
%WRITE_STEP30_LYAPUNOV_VTC_REPORT Write side-copy Lyapunov validation report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step30 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 30 Lyapunov VTC Validation Report\n\n');
fprintf(fid, 'This side-copy experiment validates the Lyapunov drift-plus-penalty scheduler on the same 5-scene VTC matrix used by Step17. ');
fprintf(fid, 'It does not modify the main confidence-driven heuristic scheduler.\n\n');

fprintf(fid, '## Overall Mean Summary\n\n');
fprintf(fid, '| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(T_summary.Scene, i), text_value(T_summary.Config, i), text_value(T_summary.Method, i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), T_summary.AvgDelayMean(i), ...
        T_summary.AvgTxCostMean(i), T_summary.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Decision Table: Lyapunov vs Heuristic\n\n');
fprintf(fid, '| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%%) | Delay Delta (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.2f | %s |\n', ...
        text_value(T_decision.Scene, i), text_value(T_decision.Config, i), ...
        T_decision.LyapunovMinusHeuristicTimely_pp(i), ...
        T_decision.LyapunovMinusHeuristicEmg_pp(i), ...
        T_decision.LyapunovCostDeltaPct(i), ...
        T_decision.LyapunovDelayDeltaPct(i), ...
        text_value(T_decision.DecisionClass, i));
end

fprintf(fid, '\n## Heuristic vs Lyapunov: Overall Significance\n\n');
write_sig_table(fid, T_sig_h_vs_l);

fprintf(fid, '\n## Heuristic vs Lyapunov: PosDeg_Emerg Significance\n\n');
write_sig_table(fid, T_sig_pos_h_vs_l);

fprintf(fid, '\n## Link-delay-aware vs Lyapunov: Overall Significance\n\n');
write_sig_table(fid, T_sig_link_vs_l);

fprintf(fid, '\n## PosDeg_Emerg Mean Summary\n\n');
fprintf(fid, '| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
T_pos = T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :);
for i = 1:height(T_pos)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(T_pos.Scene, i), text_value(T_pos.Config, i), text_value(T_pos.Method, i), ...
        T_pos.TimelyRateMean(i), T_pos.LossRateMean(i), T_pos.AvgDelayMean(i), ...
        T_pos.AvgTxCostMean(i), T_pos.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- If rows are classified as `PromisingCostVariant`, Lyapunov is worth optimizing into a stronger side method.\n');
fprintf(fid, '- If most rows are `CostOnlyVariant` or `NotCompetitive`, Lyapunov should remain a theoretical/cost-tradeoff baseline rather than replacing the main heuristic scheduler.\n');
fprintf(fid, '- A valid paper use is to state that Lyapunov formalization provides a tunable drift-plus-penalty counterpart, while the deployment-oriented heuristic occupies the high-reliability end of the Pareto tradeoff.\n');
end

function write_sig_table(fid, T_sig)
fprintf(fid, '| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta %% | Holm(all) | Practical |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---|---|\n');
for i = 1:height(T_sig)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.3f | %s | %s |\n', ...
        text_value(T_sig.Scene, i), text_value(T_sig.Config, i), text_value(T_sig.Metric, i), ...
        T_sig.Baseline_Mean(i), T_sig.Proposed_Mean(i), T_sig.Delta_Mean(i), ...
        T_sig.DeltaPct(i), text_value(T_sig.P_Value_Holm_Family_Display, i), ...
        text_value(T_sig.PracticalNote, i));
end
end

function value = text_value(col, idx)
value = char(string(col(idx)));
end
