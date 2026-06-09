function T = build_step9_stage_metrics_table(method_names, metrics_list)
%BUILD_STEP9_STAGE_METRICS_TABLE Assemble Step 9 stage metrics for all methods.

rows = [];

for m = 1:numel(method_names)
    metrics = metrics_list{m};

    for i = 1:numel(metrics)
        row = table( ...
            string(method_names{m}), ...
            string(metrics(i).stage), ...
            metrics(i).avg_delay_s, ...
            metrics(i).timely_rate, ...
            metrics(i).loss_rate, ...
            metrics(i).avg_tx_cost, ...
            metrics(i).emergency_timely_rate, ...
            'VariableNames', {'Method', 'Stage', 'AvgDelay_s', 'TimelyRate', 'LossRate', 'AvgTxCost', 'EmergencyTimelyRate'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T = rows;
end

