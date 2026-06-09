function T = build_step10_effective_warning_table(method_names, scenario_cases, results, qpos_threshold)
%BUILD_STEP10_EFFECTIVE_WARNING_TABLE Build Step 10 effective-warning metrics table.

if nargin < 4 || isempty(qpos_threshold)
    qpos_threshold = 0.50;
end

rows = [];
for i = 1:numel(method_names)
    metrics = compute_step9_effective_warning_metrics(scenario_cases{i}, results{i}, qpos_threshold);
    row = table( ...
        string(method_names{i}), ...
        metrics.qpos_threshold, ...
        metrics.posdeg_effective_warning_rate, ...
        metrics.posdeg_effective_coverage, ...
        metrics.posdeg_effective_count, ...
        metrics.posdeg_emergency_count, ...
        metrics.posdeg_effective_avg_delay_s, ...
        'VariableNames', {'Method', 'QPosThreshold', 'EffectiveWarningRate', 'EffectiveCoverage', ...
        'EffectiveCount', 'PosDegEmergencyCount', 'EffectiveAvgDelay_s'});

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
    end
end

T = rows;
end
