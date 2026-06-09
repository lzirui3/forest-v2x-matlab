function T_imp = build_improvement_table(T, baseline_method)
%BUILD_IMPROVEMENT_TABLE Build RMSE improvement percentages relative to a baseline method.

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

        if any(idx_method) && any(idx_base)
            rmse_method = T.RMSE_m(find(idx_method, 1, 'first'));
            rmse_base = baseline_rows.RMSE_m(find(idx_base, 1, 'first'));
            improve_pct = 100 * (rmse_base - rmse_method) / rmse_base;
        else
            rmse_method = NaN;
            rmse_base = NaN;
            improve_pct = NaN;
        end

        row = table( ...
            methods(i), ...
            stages(j), ...
            rmse_base, ...
            rmse_method, ...
            improve_pct, ...
            'VariableNames', {'Method', 'Stage', 'BaselineRMSE_m', 'MethodRMSE_m', 'ImprovementPct'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T_imp = rows;
