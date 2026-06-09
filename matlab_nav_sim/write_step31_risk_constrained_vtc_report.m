function write_step31_risk_constrained_vtc_report( ...
    T_summary, T_stage_summary, T_sig_h_vs_r, T_sig_link_vs_r, ...
    T_sig_lyap_vs_r, T_decision, out_path)
%WRITE_STEP31_RISK_CONSTRAINED_VTC_REPORT Write Step31 side-copy report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step31 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 31 Risk-Constrained VTC Validation Report\n\n');
fprintf(fid, 'This side-copy experiment validates a risk-constrained Lagrangian scheduler on the same VTC scene matrix used by Step17/Step30. ');
fprintf(fid, 'It does not modify the main confidence-driven heuristic scheduler.\n\n');

fprintf(fid, '## Method Framing\n\n');
fprintf(fid, 'The scheduler maximizes value-weighted timely delivery and penalizes communication cost plus soft violations of timely, reliability, deadline, and protection constraints. ');
fprintf(fid, 'This makes the decision rule closer to a constrained optimization formulation than the legacy heuristic scorer.\n\n');

fprintf(fid, '## Overall Mean Summary\n\n');
fprintf(fid, '| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(T_summary.Scene, i), text_value(T_summary.Config, i), text_value(T_summary.Method, i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), T_summary.AvgDelayMean(i), ...
        T_summary.AvgTxCostMean(i), T_summary.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Decision Table: Risk-Constrained vs Heuristic\n\n');
fprintf(fid, '| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%%) | Delay Delta (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.2f | %s |\n', ...
        text_value(T_decision.Scene, i), text_value(T_decision.Config, i), ...
        T_decision.RiskMinusHeuristicTimely_pp(i), ...
        T_decision.RiskMinusHeuristicEmg_pp(i), ...
        T_decision.RiskCostDeltaPct(i), ...
        T_decision.RiskDelayDeltaPct(i), ...
        text_value(T_decision.DecisionClass, i));
end

fprintf(fid, '\n## Heuristic vs Risk-Constrained: Overall Significance\n\n');
write_sig_table(fid, T_sig_h_vs_r, 'Heuristic', 'Risk');

fprintf(fid, '\n## Link-delay-aware vs Risk-Constrained: Overall Significance\n\n');
write_sig_table(fid, T_sig_link_vs_r, 'Link-delay-aware', 'Risk');

fprintf(fid, '\n## Lyapunov vs Risk-Constrained: Overall Significance\n\n');
write_sig_table(fid, T_sig_lyap_vs_r, 'Lyapunov', 'Risk');

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

fprintf(fid, '\n## Interpretation Rules\n\n');
fprintf(fid, '- `CandidateMainMethod`: Risk-constrained is no worse in timely delivery and does not harm emergency delivery.\n');
fprintf(fid, '- `ComparableTheoryVariant`: Risk-constrained stays within 0.5 pp of heuristic and has acceptable emergency behavior.\n');
fprintf(fid, '- `NeedsTuning`: Risk-constrained has theoretical value but loses enough timely/emergency performance that weights need calibration.\n');
fprintf(fid, '- `NotCompetitive`: Risk-constrained should stay as a baseline rather than a main method candidate.\n');
end

function write_sig_table(fid, T_sig, base_label, prop_label)
fprintf(fid, '| Scene | Config | Metric | %s Mean | %s Mean | Delta Mean | Delta %% | Holm(all) | Practical |\n', base_label, prop_label);
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
