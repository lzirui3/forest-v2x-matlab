function write_step9_stage_report(T_stage, T_imp, output_path)
%WRITE_STEP9_STAGE_REPORT Write a stage-wise markdown report for Step 9.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 9 stage report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 9 Stage-wise Report\n\n');
fprintf(fid, '## Stage Metrics\n\n');
fprintf(fid, '| Method | Stage | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|\n');

for i = 1:height(T_stage)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T_stage.Method(i), T_stage.Stage(i), T_stage.AvgDelay_s(i), T_stage.TimelyRate(i), ...
        T_stage.LossRate(i), T_stage.AvgTxCost(i), T_stage.EmergencyTimelyRate(i));
end

fprintf(fid, '\n## Relative to Link-aware Baseline\n\n');
fprintf(fid, '| Method | Stage | Timely Gain | Emergency Timely Gain | Avg Tx Cost Delta |\n');
fprintf(fid, '|---|---|---:|---:|---:|\n');

for i = 1:height(T_imp)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f |\n', ...
        T_imp.Method(i), T_imp.Stage(i), T_imp.TimelyRateGain(i), T_imp.EmergencyTimelyRateGain(i), T_imp.AvgTxCostDelta(i));
end
end

