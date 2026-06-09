function T_imp = build_step10_ablation_improvement_table(T, baseline_method)
%BUILD_STEP10_ABLATION_IMPROVEMENT_TABLE Compare overall ablation metrics against a baseline method.

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
        row_method.AvgDelay_s - baseline_row.AvgDelay_s, ...
        row_method.TimelyRate - baseline_row.TimelyRate, ...
        row_method.LossRate - baseline_row.LossRate, ...
        row_method.AvgTxCost - baseline_row.AvgTxCost, ...
        row_method.EmergencyTimelyRate - baseline_row.EmergencyTimelyRate, ...
        'VariableNames', {'Method', 'AvgDelayDelta', 'TimelyRateGain', 'LossRateDelta', 'AvgTxCostDelta', 'EmergencyTimelyRateGain'});

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
    end
end

T_imp = rows;
end
