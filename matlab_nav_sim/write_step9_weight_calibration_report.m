function write_step9_weight_calibration_report(T, output_path)
%WRITE_STEP9_WEIGHT_CALIBRATION_REPORT Write a markdown report for weight calibration.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 9 weight calibration report: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 9 Weight Calibration Report\n\n');
fprintf(fid, '## Calibration Objective\n\n');
fprintf(fid, '- Objective = overall emergency timely + 0.85 * PosDeg emergency timely + 0.20 * overall timely - 0.05 * average Tx cost - 0.02 * PosDeg Tx cost - 0.50 * loss rate.\n\n');

fprintf(fid, '## Top Configurations\n\n');
fprintf(fid, '| Rank | WTimely | WReliability | WCost | WPosRisk | WEvent | Objective | EmergencyTimely | PosDegEmergencyTimely | AvgTxCost |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|\n');

num_rows = min(10, height(T));
for i = 1:num_rows
    fprintf(fid, '| %d | %.2f | %.2f | %.2f | %.2f | %.2f | %.4f | %.4f | %.4f | %.4f |\n', ...
        i, T.WTimely(i), T.WReliability(i), T.WCost(i), T.WPosRisk(i), T.WEvent(i), ...
        T.Objective(i), T.EmergencyTimelyMean(i), T.PosDegEmergencyTimelyMean(i), T.AvgTxCostMean(i));
end

fprintf(fid, '\n## Recommended Configuration\n\n');
fprintf(fid, '- WTimely = %.2f\n', T.WTimely(1));
fprintf(fid, '- WReliability = %.2f\n', T.WReliability(1));
fprintf(fid, '- WCost = %.2f\n', T.WCost(1));
fprintf(fid, '- WPosRisk = %.2f\n', T.WPosRisk(1));
fprintf(fid, '- WEvent = %.2f\n', T.WEvent(1));
fprintf(fid, '- Objective = %.4f\n', T.Objective(1));
fprintf(fid, '- Mean emergency timely rate = %.4f\n', T.EmergencyTimelyMean(1));
fprintf(fid, '- Mean PosDeg emergency timely rate = %.4f\n', T.PosDegEmergencyTimelyMean(1));
fprintf(fid, '- Mean transmission cost = %.4f\n', T.AvgTxCostMean(1));
end
