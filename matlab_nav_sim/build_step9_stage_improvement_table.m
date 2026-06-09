function T_imp = build_step9_stage_improvement_table(T, baseline_method)
%BUILD_STEP9_STAGE_IMPROVEMENT_TABLE Compare stage metrics against a baseline method.

stages = unique(T.Stage, 'stable');
methods = unique(T.Method, 'stable');
baseline_rows = T(T.Method == string(baseline_method), :);
rows = [];

for i = 1:numel(methods)
    if methods(i) == string(baseline_method)
        continue;
    end

    for j = 1:numel(stages)
        idx_method = (T.Method == methods(i)) & (T.Stage == stages(j));
        idx_base = (baseline_rows.Stage == stages(j));

        timely_gain = NaN;
        emg_gain = NaN;
        cost_delta = NaN;

        if any(idx_method) && any(idx_base)
            row_method = T(find(idx_method, 1, 'first'), :);
            row_base = baseline_rows(find(idx_base, 1, 'first'), :);
            timely_gain = row_method.TimelyRate - row_base.TimelyRate;
            emg_gain = row_method.EmergencyTimelyRate - row_base.EmergencyTimelyRate;
            cost_delta = row_method.AvgTxCost - row_base.AvgTxCost;
        end

        row = table( ...
            methods(i), ...
            stages(j), ...
            timely_gain, ...
            emg_gain, ...
            cost_delta, ...
            'VariableNames', {'Method', 'Stage', 'TimelyRateGain', 'EmergencyTimelyRateGain', 'AvgTxCostDelta'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T_imp = rows;
end

