function T = build_stage_metrics_table(method_names, metrics_list)
%BUILD_STAGE_METRICS_TABLE Assemble stage metrics from multiple methods into one table.

rows = [];

for m = 1:numel(method_names)
    metrics = metrics_list{m};

    for i = 1:numel(metrics)
        row = table( ...
            string(method_names{m}), ...
            string(metrics(i).stage), ...
            metrics(i).mean_err, ...
            metrics(i).rmse, ...
            metrics(i).max_err, ...
            metrics(i).availability, ...
            'VariableNames', {'Method', 'Stage', 'MeanError_m', 'RMSE_m', 'MaxError_m', 'Availability'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T = rows;
