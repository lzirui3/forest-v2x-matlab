function T = build_step19_pdr_mode_delta_table(T_raw, target_method)
%BUILD_STEP19_PDR_MODE_DELTA_TABLE Compare sigmoid vs PER lookup under same seeds.

T_raw.Config = string(T_raw.Config);
T_raw.PdrMode = string(T_raw.PdrMode);
T_raw.Method = string(T_raw.Method);
target_method = string(target_method);

configs = unique(T_raw.Config, 'stable');
metrics = {'TimelyRate', 'LossRate', 'AvgDelay_s', 'AvgTxCost', 'EmergencyTimelyRate'};
metric_labels = {'TimelyRate', 'LossRate', 'AvgDelay', 'AvgTxCost', 'EmgTimely'};
rows = [];

for c = 1:numel(configs)
    sub_sig = T_raw(T_raw.Config == configs(c) & T_raw.PdrMode == "sigmoid" & T_raw.Method == target_method, :);
    sub_per = T_raw(T_raw.Config == configs(c) & T_raw.PdrMode == "per_lookup" & T_raw.Method == target_method, :);
    if isempty(sub_sig) || isempty(sub_per)
        continue;
    end

    [~, idx_sig] = sort(sub_sig.Seed);
    [~, idx_per] = sort(sub_per.Seed);
    sub_sig = sub_sig(idx_sig, :);
    sub_per = sub_per(idx_per, :);

    for m = 1:numel(metrics)
        vals_sig = sub_sig.(metrics{m});
        vals_per = sub_per.(metrics{m});
        delta = vals_per - vals_sig;

        row = table( ...
            configs(c), string(target_method), string(metric_labels{m}), ...
            mean(vals_sig, 'omitnan'), mean(vals_per, 'omitnan'), mean(delta, 'omitnan'), ...
            ci95(delta), max(abs(delta)), ...
            'VariableNames', {'Config','Method','Metric','SigmoidMean','PerLookupMean', ...
            'DeltaMean','DeltaCI95','MaxAbsDelta'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T = rows;
end

function value = ci95(x)
x = x(~isnan(x));
if isempty(x)
    value = NaN;
else
    value = 1.96 * std(x, 0) / sqrt(numel(x));
end
end
