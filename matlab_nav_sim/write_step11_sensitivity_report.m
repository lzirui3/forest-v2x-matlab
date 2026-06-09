function write_step11_sensitivity_report(T, output_path)
%WRITE_STEP11_SENSITIVITY_REPORT Write a markdown summary for Step 11.

params = unique(T.Parameter, 'stable');
fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 11 sensitivity report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 11 Sensitivity Report\n\n');
fprintf(fid, '## Scope\n\n');
fprintf(fid, '- Method under test: `Confidence-driven`.\n');
fprintf(fid, '- Focus metrics: overall timely rate, overall emergency timely rate, `PosDeg_Emerg` emergency timely rate, and transmission cost.\n\n');

fprintf(fid, '## Summary Table\n\n');
fprintf(fid, '| Parameter | Default | Best PosDeg Emergency Timely Value | Best PosDeg Emergency Timely | Default PosDeg Emergency Timely | PosDeg Span | Avg Tx Cost Span |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|\n');

for i = 1:numel(params)
    subT = T(T.Parameter == params(i), :);
    default_row = subT(abs(subT.Value - subT.DefaultValue) < 1.0e-9, :);
    if isempty(default_row)
        default_row = subT(1, :);
    end

    max_posdeg = max(subT.PosDegEmergencyTimelyRate);
    idx_best = find(abs(subT.PosDegEmergencyTimelyRate - max_posdeg) < 1.0e-9);
    [~, idx_tiebreak] = min(subT.AvgTxCost(idx_best));
    row_best = subT(idx_best(idx_tiebreak), :);

    posdeg_span = max(subT.PosDegEmergencyTimelyRate) - min(subT.PosDegEmergencyTimelyRate);
    cost_span = max(subT.AvgTxCost) - min(subT.AvgTxCost);

    fprintf(fid, '| %s | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        params(i), default_row.DefaultValue(1), row_best.Value(1), row_best.PosDegEmergencyTimelyRate(1), ...
        default_row.PosDegEmergencyTimelyRate(1), posdeg_span, cost_span);
end

fprintf(fid, '\n## Parameter-by-Parameter Observations\n\n');

for i = 1:numel(params)
    subT = T(T.Parameter == params(i), :);
    default_row = subT(abs(subT.Value - subT.DefaultValue) < 1.0e-9, :);
    if isempty(default_row)
        default_row = subT(1, :);
    end

    [best_emg, idx_best_emg] = max(subT.EmergencyTimelyRate);
    row_best_emg = subT(idx_best_emg(1), :);

    [best_posdeg, idx_best_posdeg] = max(subT.PosDegEmergencyTimelyRate);
    idx_best_posdeg = idx_best_posdeg(:)';
    candidate_rows = subT(idx_best_posdeg, :);
    [~, idx_min_cost] = min(candidate_rows.AvgTxCost);
    row_best_posdeg = candidate_rows(idx_min_cost, :);

    emg_span = max(subT.EmergencyTimelyRate) - min(subT.EmergencyTimelyRate);
    posdeg_span = max(subT.PosDegEmergencyTimelyRate) - min(subT.PosDegEmergencyTimelyRate);
    cost_span = max(subT.AvgTxCost) - min(subT.AvgTxCost);

    fprintf(fid, '### %s\n\n', params(i));
    fprintf(fid, '- Default value: %.3f\n', default_row.DefaultValue(1));
    fprintf(fid, '- Best overall emergency timely rate: %.3f at %.3f\n', best_emg, row_best_emg.Value(1));
    fprintf(fid, '- Best `PosDeg_Emerg` emergency timely rate: %.3f at %.3f\n', best_posdeg, row_best_posdeg.Value(1));
    fprintf(fid, '- Default `PosDeg_Emerg` emergency timely rate: %.3f\n', default_row.PosDegEmergencyTimelyRate(1));
    fprintf(fid, '- Overall emergency timely span: %.3f\n', emg_span);
    fprintf(fid, '- `PosDeg_Emerg` emergency timely span: %.3f\n', posdeg_span);
    fprintf(fid, '- Average Tx cost span: %.3f\n', cost_span);
    fprintf(fid, '- Sensitivity level: %s\n\n', classify_sensitivity(posdeg_span));
end

fprintf(fid, '## Interpretation\n\n');
fprintf(fid, '- Parameters with large `PosDeg_Emerg` span strongly affect critical-stage behavior and should be tuned carefully.\n');
fprintf(fid, '- Parameters with small span are relatively robust in the tested range and can be fixed without heavily affecting the main conclusion.\n');
fprintf(fid, '- Recommended default values should prioritize critical-stage emergency timely rate first, then transmission cost.\n');
end

function label = classify_sensitivity(span_value)
if span_value >= 0.20
    label = 'High';
elseif span_value >= 0.08
    label = 'Moderate';
else
    label = 'Low';
end
end
