function write_step8_interpretation_report(T, T_imp, output_path)
%WRITE_STEP8_INTERPRETATION_REPORT Write a markdown summary for Step 8 stage-wise results.

full_idx = (T.Stage == "Full");
T_full = T(full_idx, :);

fixed_rmse = T_full.RMSE_m(T_full.Method == "Fixed constraints");
adapt_rmse = T_full.RMSE_m(T_full.Method == "Adaptive constraints");

deg_imp = get_improve(T_imp, "Degraded");
out_imp = get_improve(T_imp, "Outage");
rec_imp = get_improve(T_imp, "Recovery");
full_imp = get_improve(T_imp, "Full");

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 8 report file: %s', output_path);
end
cleanupObj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 8 Stage-wise Comparison Report\n\n');
fprintf(fid, '## Headline\n\n');
fprintf(fid, '- Fixed-constraint full-stage RMSE: %.3f m\n', fixed_rmse);
fprintf(fid, '- Adaptive-constraint full-stage RMSE: %.3f m\n', adapt_rmse);
fprintf(fid, '- Full-stage relative change: %.2f%%\n\n', full_imp);

fprintf(fid, '## Stage-wise Relative Change of Adaptive Constraints\n\n');
fprintf(fid, '- Degraded stage: %.2f%%\n', deg_imp);
fprintf(fid, '- Outage stage: %.2f%%\n', out_imp);
fprintf(fid, '- Recovery stage: %.2f%%\n\n', rec_imp);

fprintf(fid, '## Interpretation Hint\n\n');
fprintf(fid, 'If the full-stage improvement is small but one or more stage-wise improvements are more visible, this indicates that adaptive scheduling mainly helps under specific operating conditions rather than uniformly across the entire trajectory.\n');
end

function improve = get_improve(T_imp, stage_name)
idx = (T_imp.Stage == stage_name) & (T_imp.Method == "Adaptive constraints");
if any(idx)
    improve = T_imp.ImprovementPct(find(idx, 1, 'first'));
else
    improve = NaN;
end
end
