function write_stage_metrics_report(T, T_imp, output_path)
%WRITE_STAGE_METRICS_REPORT Write a brief markdown report from stage metrics tables.

full_idx = (T.Stage == "Full");
T_full = T(full_idx, :);
[~, best_idx] = min(T_full.RMSE_m);
best_method = T_full.Method(best_idx);
best_rmse = T_full.RMSE_m(best_idx);

deg_idx = (T_imp.Stage == "Degraded") & (T_imp.Method == "Residual-adaptive + NHC");
out_idx = (T_imp.Stage == "Outage") & (T_imp.Method == "Residual-adaptive + NHC");
rec_idx = (T_imp.Stage == "Recovery") & (T_imp.Method == "Residual-adaptive + NHC");

deg_improve = get_first_or_nan(T_imp.ImprovementPct, deg_idx);
out_improve = get_first_or_nan(T_imp.ImprovementPct, out_idx);
rec_improve = get_first_or_nan(T_imp.ImprovementPct, rec_idx);

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open report output file: %s', output_path);
end

cleanupObj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Stage Metrics Report\n\n');
fprintf(fid, '## Headline Findings\n\n');
fprintf(fid, '- Best full-stage RMSE method: **%s** (%.3f m)\n', best_method, best_rmse);
fprintf(fid, '- Relative to `Baseline fusion`, `Residual-adaptive + NHC` RMSE change:\n');
fprintf(fid, '  - Degraded stage: %.2f%%\n', deg_improve);
fprintf(fid, '  - Outage stage: %.2f%%\n', out_improve);
fprintf(fid, '  - Recovery stage: %.2f%%\n\n', rec_improve);

fprintf(fid, '## Interpretation Template\n\n');
fprintf(fid, 'The results indicate that the multi-constraint residual-adaptive strategy improves positioning performance compared with the baseline fusion method, especially in stages where GNSS observations become unreliable. In the degraded stage, the adaptive weighting mechanism reduces the influence of low-quality GNSS observations. In the outage stage, the IMU and motion constraints sustain the navigation solution, while in the recovery stage the method regains accuracy after GNSS observations return.\n');
end

function value = get_first_or_nan(vec, idx)
if any(idx)
    value = vec(find(idx, 1, 'first'));
else
    value = NaN;
end
end
