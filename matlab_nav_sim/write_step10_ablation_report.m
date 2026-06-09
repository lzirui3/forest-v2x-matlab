function write_step10_ablation_report(T, T_imp, T_stage, T_stage_imp, T_effective, T_effective_imp, output_path)
%WRITE_STEP10_ABLATION_REPORT Write a markdown report for positioning module ablation.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 10 ablation report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 10 Position-Confidence Ablation Report\n\n');
fprintf(fid, '## Overall Metrics\n\n');
fprintf(fid, '| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T.Method(i), T.AvgDelay_s(i), T.TimelyRate(i), T.LossRate(i), T.AvgTxCost(i), T.EmergencyTimelyRate(i));
end

fprintf(fid, '\n## Delta Relative to Full\n\n');
fprintf(fid, '| Method | Avg Delay Delta | Timely Gain | Loss Delta | Avg Tx Cost Delta | Emergency Timely Gain |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_imp)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T_imp.Method(i), T_imp.AvgDelayDelta(i), T_imp.TimelyRateGain(i), T_imp.LossRateDelta(i), ...
        T_imp.AvgTxCostDelta(i), T_imp.EmergencyTimelyRateGain(i));
end

fprintf(fid, '\n## PosDeg_Emerg Focus\n\n');
fprintf(fid, '| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
posdeg = T_stage(T_stage.Stage == "PosDeg_Emerg", :);
for i = 1:height(posdeg)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        posdeg.Method(i), posdeg.AvgDelay_s(i), posdeg.TimelyRate(i), posdeg.LossRate(i), ...
        posdeg.AvgTxCost(i), posdeg.EmergencyTimelyRate(i));
end

fprintf(fid, '\n## PosDeg_Emerg Delta Relative to Full\n\n');
fprintf(fid, '| Method | Timely Gain | Emergency Timely Gain | Avg Tx Cost Delta |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
posdeg_imp = T_stage_imp(T_stage_imp.Stage == "PosDeg_Emerg", :);
for i = 1:height(posdeg_imp)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f |\n', ...
        posdeg_imp.Method(i), posdeg_imp.TimelyRateGain(i), posdeg_imp.EmergencyTimelyRateGain(i), posdeg_imp.AvgTxCostDelta(i));
end

fprintf(fid, '\n## Position-Confidence-Constrained Effective Warning\n\n');
fprintf(fid, 'Threshold: `q_{pos} >= %.2f` within `PosDeg_Emerg` emergency samples.\n\n', T_effective.QPosThreshold(1));
fprintf(fid, '| Method | Effective Warning Rate | Effective Coverage | Effective Count | Effective Avg Delay (s) |\n');
fprintf(fid, '|---|---:|---:|---:|---:|\n');
for i = 1:height(T_effective)
    fprintf(fid, '| %s | %.3f | %.3f | %d | %.3f |\n', ...
        T_effective.Method(i), T_effective.EffectiveWarningRate(i), T_effective.EffectiveCoverage(i), ...
        T_effective.EffectiveCount(i), T_effective.EffectiveAvgDelay_s(i));
end

fprintf(fid, '\n## Effective Warning Delta Relative to Full\n\n');
fprintf(fid, '| Method | Effective Warning Rate Gain | Effective Coverage Gain | Effective Count Delta | Effective Avg Delay Delta (s) |\n');
fprintf(fid, '|---|---:|---:|---:|---:|\n');
for i = 1:height(T_effective_imp)
    fprintf(fid, '| %s | %.3f | %.3f | %d | %.3f |\n', ...
        T_effective_imp.Method(i), T_effective_imp.EffectiveWarningRateGain(i), T_effective_imp.EffectiveCoverageGain(i), ...
        T_effective_imp.EffectiveCountDelta(i), T_effective_imp.EffectiveAvgDelayDelta_s(i));
end

full_row = T(T.Method == "Full", :);
abl_rows = T_imp(T_imp.Method ~= "Link-aware", :);
[~, idx_worst] = min(abl_rows.EmergencyTimelyRateGain);
fprintf(fid, '\n## Observation\n\n');
fprintf(fid, '- Full model emergency timely rate: **%.3f**.\n', full_row.EmergencyTimelyRate);
fprintf(fid, '- The largest overall emergency-timely degradation comes from removing **%s**.\n', abl_rows.Method(idx_worst));
full_effective = T_effective(T_effective.Method == "Full", :);
worst_effective_rows = T_effective_imp(T_effective_imp.Method ~= "Link-aware", :);
[~, idx_worst_effective] = min(worst_effective_rows.EffectiveWarningRateGain);
fprintf(fid, '- Under the `q_{pos}`-constrained effective-warning metric, the largest degradation comes from removing **%s**.\n', ...
    worst_effective_rows.Method(idx_worst_effective));
fprintf(fid, '- This ablation is intended to identify which positioning-confidence submodule contributes most to the scheduling gain.\n');
fprintf(fid, '- Full effective-warning rate under `q_{pos}` constraint: **%.3f** with coverage **%.3f**.\n', ...
    full_effective.EffectiveWarningRate, full_effective.EffectiveCoverage);
end
