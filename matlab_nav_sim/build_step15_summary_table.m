function T_summary = build_step15_summary_table(T_raw)
%BUILD_STEP15_SUMMARY_TABLE Aggregate default vs forest multiseed overall metrics.

configs = unique(T_raw.Config, 'stable');
methods = unique(T_raw.Method, 'stable');
rows = [];

for c = 1:numel(configs)
    for m = 1:numel(methods)
        subT = T_raw(T_raw.Config == configs(c) & T_raw.Method == methods(m), :);
        row = table( ...
            configs(c), methods(m), ...
            mean(subT.TimelyRate, 'omitnan'), std(subT.TimelyRate, 0, 'omitnan'), ci95(subT.TimelyRate), ...
            mean(subT.LossRate, 'omitnan'), std(subT.LossRate, 0, 'omitnan'), ci95(subT.LossRate), ...
            mean(subT.AvgTxCost, 'omitnan'), std(subT.AvgTxCost, 0, 'omitnan'), ci95(subT.AvgTxCost), ...
            mean(subT.EmergencyTimelyRate, 'omitnan'), std(subT.EmergencyTimelyRate, 0, 'omitnan'), ci95(subT.EmergencyTimelyRate), ...
            'VariableNames', { ...
            'Config','Method', ...
            'TimelyRateMean','TimelyRateStd','TimelyRateCI95', ...
            'LossRateMean','LossRateStd','LossRateCI95', ...
            'AvgTxCostMean','AvgTxCostStd','AvgTxCostCI95', ...
            'EmergencyTimelyRateMean','EmergencyTimelyRateStd','EmergencyTimelyRateCI95'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T_summary = rows;
end

function value = ci95(x)
x = x(~isnan(x));
if isempty(x)
    value = NaN;
else
    value = 1.96 * std(x, 0) / sqrt(numel(x));
end
end
