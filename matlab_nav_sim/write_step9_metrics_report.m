function write_step9_metrics_report(T, output_path)
%WRITE_STEP9_METRICS_REPORT Write a markdown summary for Step 9 results.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 9 report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 9 Scheduling Comparison Report\n\n');
fprintf(fid, '## Summary Table\n\n');
fprintf(fid, '| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');

for i = 1:height(T)
    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        T.Method(i), T.AvgDelay_s(i), T.TimelyRate(i), T.LossRate(i), T.AvgTxCost(i), T.EmergencyTimelyRate(i));
end

[~, best_idx] = max(T.EmergencyTimelyRate);
fprintf(fid, '\n## Observation\n\n');
fprintf(fid, '- The best emergency timely-delivery method is **%s**.\n', T.Method(best_idx));
fprintf(fid, '- This report is intended to support the first-step validation of whether positioning confidence provides incremental scheduling value.\n');
end

