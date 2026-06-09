function T_summary = build_step12_effective_warning_summary_table(T_raw)
%BUILD_STEP12_EFFECTIVE_WARNING_SUMMARY_TABLE Aggregate effective-warning metrics across seeds.

methods = unique(T_raw.Method, 'stable');
rows = [];

for i = 1:numel(methods)
    subT = T_raw(T_raw.Method == methods(i), :);
    row = table( ...
        methods(i), ...
        mean(subT.QPosThreshold, 'omitnan'), ...
        mean(subT.EffectiveWarningRate, 'omitnan'), std(subT.EffectiveWarningRate, 0, 'omitnan'), ci95(subT.EffectiveWarningRate), ...
        mean(subT.EffectiveCoverage, 'omitnan'), std(subT.EffectiveCoverage, 0, 'omitnan'), ci95(subT.EffectiveCoverage), ...
        mean(subT.EffectiveCount, 'omitnan'), std(subT.EffectiveCount, 0, 'omitnan'), ci95(subT.EffectiveCount), ...
        mean(subT.EffectiveAvgDelay_s, 'omitnan'), std(subT.EffectiveAvgDelay_s, 0, 'omitnan'), ci95(subT.EffectiveAvgDelay_s), ...
        'VariableNames', {'Method', 'QPosThresholdMean', ...
        'EffectiveWarningRateMean', 'EffectiveWarningRateStd', 'EffectiveWarningRateCI95', ...
        'EffectiveCoverageMean', 'EffectiveCoverageStd', 'EffectiveCoverageCI95', ...
        'EffectiveCountMean', 'EffectiveCountStd', 'EffectiveCountCI95', ...
        'EffectiveAvgDelayMean_s', 'EffectiveAvgDelayStd_s', 'EffectiveAvgDelayCI95_s'});

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
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
