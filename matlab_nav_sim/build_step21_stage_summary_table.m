function T_summary = build_step21_stage_summary_table(T_raw)
%BUILD_STEP21_STAGE_SUMMARY_TABLE Aggregate stage metrics for forest geometry matrix.

configs = unique(T_raw.Config, 'stable');
methods = unique(T_raw.Method, 'stable');
stages = unique(T_raw.Stage, 'stable');
rows = [];

for c = 1:numel(configs)
    for m = 1:numel(methods)
        for s = 1:numel(stages)
            subT = T_raw(T_raw.Config == configs(c) & T_raw.Method == methods(m) & T_raw.Stage == stages(s), :);
            row = table( ...
                configs(c), subT.Profile(1), subT.Vegetation(1), methods(m), stages(s), ...
                mean(subT.TimelyRate, 'omitnan'), std(subT.TimelyRate, 0, 'omitnan'), ci95(subT.TimelyRate), ...
                mean(subT.LossRate, 'omitnan'), std(subT.LossRate, 0, 'omitnan'), ci95(subT.LossRate), ...
                mean(subT.AvgDelay_s, 'omitnan'), std(subT.AvgDelay_s, 0, 'omitnan'), ci95(subT.AvgDelay_s), ...
                mean(subT.AvgTxCost, 'omitnan'), std(subT.AvgTxCost, 0, 'omitnan'), ci95(subT.AvgTxCost), ...
                mean(subT.EmergencyTimelyRate, 'omitnan'), std(subT.EmergencyTimelyRate, 0, 'omitnan'), ci95(subT.EmergencyTimelyRate), ...
                'VariableNames', {'Config','Profile','Vegetation','Method','Stage', ...
                'TimelyRateMean','TimelyRateStd','TimelyRateCI95', ...
                'LossRateMean','LossRateStd','LossRateCI95', ...
                'AvgDelayMean','AvgDelayStd','AvgDelayCI95', ...
                'AvgTxCostMean','AvgTxCostStd','AvgTxCostCI95', ...
                'EmergencyTimelyRateMean','EmergencyTimelyRateStd','EmergencyTimelyRateCI95'});

            if isempty(rows)
                rows = row;
            else
                rows = [rows; row]; %#ok<AGROW>
            end
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
