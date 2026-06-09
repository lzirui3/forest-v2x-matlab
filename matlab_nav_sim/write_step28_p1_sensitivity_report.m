function write_step28_p1_sensitivity_report(profile_table, T_summary, T_delta, T_sig, out_path)
%WRITE_STEP28_P1_SENSITIVITY_REPORT Formal report for P1 feasibility analysis.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step28 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 28 P1 Sensitivity Report\n\n');
fprintf(fid, 'This report addresses P1 without tuning the mainline parameters to make the results look better. ');
fprintf(fid, 'It separates emergency-message performance into three scenario-pressure profiles:\n\n');
fprintf(fid, '- `Strict-75ms`: ForestGeometry channel with strict 75 ms emergency deadline.\n');
fprintf(fid, '- `Forest-150ms`: ForestGeometry channel with relaxed 150 ms forest emergency deadline.\n');
fprintf(fid, '- `Moderate-Forest`: midpoint physical degradation between Default and ForestGeometry, with 150 ms emergency deadline.\n\n');

fprintf(fid, '## Profile Definitions\n\n');
fprintf(fid, '| Profile | Emergency Deadline (s) | Link Scale | Tx Power (dBm) | LOS Exp. | NLOS Exp. | NLOSv Extra Loss (dB) | Interference Scale |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|---:|\n');
for i = 1:height(profile_table)
    fprintf(fid, '| %s | %.3f | %.3f | %.2f | %.2f | %.2f | %.2f | %.2f |\n', ...
        text_value(profile_table.Profile, i), profile_table.DeadlineEmergency_s(i), ...
        profile_table.LinkDistanceScale(i), profile_table.TxPower_dBm(i), ...
        profile_table.PathlossLosExponent(i), profile_table.PathlossNlosExponent(i), ...
        profile_table.NlosvExtraLoss_dB(i), profile_table.InterferenceScale(i));
end

fprintf(fid, '\n## Emergency Feasibility Summary\n\n');
oracle_mean = get_table_column(T_delta, "ConstrainedOracleEmergencyTimelyMean", "OracleEmergencyTimelyMean");
oracle_delta = get_table_column(T_delta, "ConstrainedOracleMinusLink_pp", "OracleMinusLink_pp");
oracle_band = get_table_column(T_delta, "ConstrainedOracleFeasibilityBand", "OracleFeasibilityBand");
fprintf(fid, '| Scene | Role | Profile | Link EmgTimely | Confidence EmgTimely | Constrained Oracle EmgTimely | Confidence-Link (pp) | ConstrainedOracle-Link (pp) | Feasibility Band |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_delta)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.3f | %.3f | %s |\n', ...
        text_value(T_delta.Scene, i), text_value(T_delta.SceneRole, i), text_value(T_delta.Config, i), ...
        T_delta.LinkEmergencyTimelyMean(i), T_delta.ConfidenceEmergencyTimelyMean(i), ...
        oracle_mean(i), T_delta.ConfidenceMinusLink_pp(i), ...
        oracle_delta(i), text_value(oracle_band, i));
end

fprintf(fid, '\n## Confidence-driven vs Link-delay-aware Emergency Statistics\n\n');
T_emg = T_sig(T_sig.Metric == "EmgTimely", :);
fprintf(fid, '| Scene | Profile | Link Mean | Confidence Mean | Delta | Delta (pp) | 95%% CI | p-value | Holm(all) | Effect RBC | Practical |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_emg)
    fprintf(fid, '| %s | %s | %.4f | %.4f | %.4f | %.3f | [%.4f, %.4f] | %s | %s | %.3f | %s |\n', ...
        text_value(T_emg.Scene, i), text_value(T_emg.Config, i), T_emg.Baseline_Mean(i), ...
        T_emg.Proposed_Mean(i), T_emg.Delta_Mean(i), T_emg.DeltaPct(i), ...
        T_emg.CI_Lower(i), T_emg.CI_Upper(i), text_value(T_emg.P_Value_Display, i), ...
        text_value(T_emg.P_Value_Holm_Family_Display, i), T_emg.EffectSize_RBC(i), ...
        text_value(T_emg.PracticalNote, i));
end

fprintf(fid, '\n## Overall Method Summary\n\n');
fprintf(fid, '| Scene | Profile | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(T_summary.Scene, i), text_value(T_summary.Config, i), text_value(T_summary.Method, i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), ...
        T_summary.AvgDelayMean(i), T_summary.AvgTxCostMean(i), ...
        T_summary.EmergencyTimelyRateMean(i));
end

T_eff = build_cost_efficiency_table(T_summary, "Link-delay-aware");
fprintf(fid, '\n## Cost-Efficiency Summary\n\n');
fprintf(fid, '| Scene | Profile | Method | Timely/Cost | Emergency/Cost | Delta Timely (pp) | Delta Emergency (pp) | Delta Cost | Gain Class |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_eff)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.3f | %.3f | %.4f | %s |\n', ...
        text_value(T_eff.Scene, i), text_value(T_eff.Config, i), text_value(T_eff.Method, i), ...
        T_eff.TimelyPerCost(i), T_eff.EmergencyTimelyPerCost(i), ...
        T_eff.DeltaTimely_pp(i), T_eff.DeltaEmergencyTimely_pp(i), ...
        T_eff.DeltaAvgTxCost(i), text_value(T_eff.CostEfficiencyClass, i));
end

near_impossible = T_delta(oracle_band == "Near-impossible", :);
marginal = T_delta(oracle_band == "Marginal", :);
feasible = T_delta(oracle_band == "Feasible", :);

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- Rows classified as `Near-impossible` should not be used as primary evidence for scheduler superiority, because the constrained-oracle upper bound is also low.\n');
fprintf(fid, '- `Forest-150ms` isolates the deadline effect. If the constrained oracle remains low after relaxing the deadline, the bottleneck is the physical link rather than the scheduler.\n');
fprintf(fid, '- `Moderate-Forest` should be interpreted as a sensitivity profile defining the workable forest operating region, not as a tuned replacement for ForestGeometry.\n');
fprintf(fid, '- The current 10-seed run contains %d near-impossible rows, %d marginal rows, and %d feasible rows.\n', ...
    height(near_impossible), height(marginal), height(feasible));

fprintf(fid, '\n## Paper Usage Recommendation\n\n');
fprintf(fid, '- Present P1 as a feasibility-boundary finding: strong ForestGeometry pressure can push emergency delivery into a physically near-impossible region.\n');
fprintf(fid, '- Keep Strict-75ms and Forest-150ms as stress tests or appendix evidence.\n');
fprintf(fid, '- Use feasible or marginal profiles for method-performance claims, and explicitly state that near-impossible profiles evaluate robustness rather than expected deployment performance.\n');
fprintf(fid, '- Do not claim that deadline relaxation alone solves P1; the sensitivity results show that link degradation dominates in the hardest scenes.\n');
end

function value = text_value(column, idx)
if iscell(column)
    value = string(column{idx});
else
    value = string(column(idx));
end
end

function column = get_table_column(T, preferred_name, fallback_name)
if ismember(preferred_name, T.Properties.VariableNames)
    column = T.(preferred_name);
elseif ismember(fallback_name, T.Properties.VariableNames)
    column = T.(fallback_name);
else
    error('Missing required table column: %s or %s', preferred_name, fallback_name);
end
end
