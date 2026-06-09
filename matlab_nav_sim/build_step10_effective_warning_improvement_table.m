function T_imp = build_step10_effective_warning_improvement_table(T, baseline_method)
%BUILD_STEP10_EFFECTIVE_WARNING_IMPROVEMENT_TABLE Compare effective-warning metrics to baseline.

baseline_row = T(T.Method == string(baseline_method), :);
if isempty(baseline_row)
    error('Baseline method "%s" not found.', baseline_method);
end

rows = [];
methods = unique(T.Method, 'stable');
for i = 1:numel(methods)
    if methods(i) == string(baseline_method)
        continue;
    end

    row_method = T(T.Method == methods(i), :);
    row = table( ...
        methods(i), ...
        row_method.EffectiveWarningRate - baseline_row.EffectiveWarningRate, ...
        row_method.EffectiveCoverage - baseline_row.EffectiveCoverage, ...
        row_method.EffectiveCount - baseline_row.EffectiveCount, ...
        row_method.EffectiveAvgDelay_s - baseline_row.EffectiveAvgDelay_s, ...
        'VariableNames', {'Method', 'EffectiveWarningRateGain', 'EffectiveCoverageGain', ...
        'EffectiveCountDelta', 'EffectiveAvgDelayDelta_s'});

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
    end
end

T_imp = rows;
end
