function write_step12_multiseed_report(T_summary, T_stage_summary, T_effective_summary, output_path, num_seeds)
%WRITE_STEP12_MULTISEED_REPORT Write a markdown summary for Step 12.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 12 report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 12 Multi-Seed Statistical Report\n\n');
fprintf(fid, '## Scope\n\n');
fprintf(fid, '- Number of seeds: %d\n', num_seeds);
fprintf(fid, '- Methods: `Link-aware`, `Full`, `No-GNSS`, `No-RSU`, `No-Env`\n\n');

fprintf(fid, '## Overall Summary\n\n');
fprintf(fid, '| Method | Emergency Timely Mean | Emergency Timely Std | Emergency Timely CI95 | Avg Tx Cost Mean | Avg Tx Cost Std |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T_summary.Method(i), T_summary.EmergencyTimelyRateMean(i), T_summary.EmergencyTimelyRateStd(i), ...
        T_summary.EmergencyTimelyRateCI95(i), T_summary.AvgTxCostMean(i), T_summary.AvgTxCostStd(i));
end

fprintf(fid, '\n## PosDeg_Emerg Summary\n\n');
fprintf(fid, '| Method | PosDeg Emergency Timely Mean | PosDeg Emergency Timely Std | PosDeg Emergency Timely CI95 | PosDeg Avg Tx Cost Mean |\n');
fprintf(fid, '|---|---:|---:|---:|---:|\n');
posdeg = T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :);
for i = 1:height(posdeg)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f |\n', ...
        posdeg.Method(i), posdeg.EmergencyTimelyRateMean(i), posdeg.EmergencyTimelyRateStd(i), ...
        posdeg.EmergencyTimelyRateCI95(i), posdeg.AvgTxCostMean(i));
end

fprintf(fid, '\n## Effective Warning Under Position-Confidence Constraint\n\n');
fprintf(fid, '| Method | q_pos Threshold | Effective Warning Mean | Effective Warning Std | Effective Warning CI95 | Effective Coverage Mean |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_effective_summary)
    fprintf(fid, '| %s | %.2f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T_effective_summary.Method(i), T_effective_summary.QPosThresholdMean(i), ...
        T_effective_summary.EffectiveWarningRateMean(i), T_effective_summary.EffectiveWarningRateStd(i), ...
        T_effective_summary.EffectiveWarningRateCI95(i), T_effective_summary.EffectiveCoverageMean(i));
end

full_row = T_summary(T_summary.Method == "Full", :);
link_row = T_summary(T_summary.Method == "Link-aware", :);
posdeg_full = posdeg(posdeg.Method == "Full", :);
posdeg_link = posdeg(posdeg.Method == "Link-aware", :);
eff_full = T_effective_summary(T_effective_summary.Method == "Full", :);
eff_link = T_effective_summary(T_effective_summary.Method == "Link-aware", :);

fprintf(fid, '\n## Observation\n\n');
fprintf(fid, '- `Full` overall emergency timely mean: **%.3f**.\n', full_row.EmergencyTimelyRateMean(1));
fprintf(fid, '- `Link-aware` overall emergency timely mean: **%.3f**.\n', link_row.EmergencyTimelyRateMean(1));
fprintf(fid, '- `Full` PosDeg emergency timely mean: **%.3f**.\n', posdeg_full.EmergencyTimelyRateMean(1));
fprintf(fid, '- `Link-aware` PosDeg emergency timely mean: **%.3f**.\n', posdeg_link.EmergencyTimelyRateMean(1));
fprintf(fid, '- `Full` effective warning mean under `q_{pos}` constraint: **%.3f**.\n', eff_full.EffectiveWarningRateMean(1));
fprintf(fid, '- `Link-aware` effective warning mean under `q_{pos}` constraint: **%.3f**.\n', eff_link.EffectiveWarningRateMean(1));
fprintf(fid, '- This report is intended to verify that the main advantage of the full method remains statistically stable across randomized scenario seeds.\n');
end
