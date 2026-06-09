function write_sensitivity_report(T, output_path)
%WRITE_SENSITIVITY_REPORT Write a brief markdown summary for sensitivity experiments.

params = unique(T.Parameter, 'stable');
fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open sensitivity report file: %s', output_path);
end

cleanupObj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Parameter Sensitivity Report\n\n');

for i = 1:numel(params)
    subT = T(T.Parameter == params(i), :);
    [min_full_rmse, idx_best] = min(subT.FullRMSE_m);
    best_value = subT.Value(idx_best);
    rmse_span = max(subT.FullRMSE_m) - min(subT.FullRMSE_m);

    fprintf(fid, '## %s\n\n', params(i));
    fprintf(fid, '- Best full-stage RMSE: %.3f m at parameter value %.4f\n', min_full_rmse, best_value);
    fprintf(fid, '- Full-stage RMSE span across tested values: %.3f m\n\n', rmse_span);
end

fprintf(fid, '## Interpretation Hint\n\n');
fprintf(fid, 'Parameters with a small RMSE span are relatively robust in the tested range. Parameters with a large RMSE span are more sensitive and may need adaptive tuning or stronger prior design.\n');
