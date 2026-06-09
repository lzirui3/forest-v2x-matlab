function T_eff = build_cost_efficiency_table(T_summary, baseline_name)
%BUILD_COST_EFFICIENCY_TABLE Cost-normalized performance summary.

if nargin < 2 || isempty(baseline_name)
    baseline_name = "Link-delay-aware";
end

key_vars = get_key_vars(T_summary);
keys = unique(T_summary(:, key_vars), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = true(height(T_summary), 1);
    for j = 1:numel(key_vars)
        key = key_vars{j};
        key_values = as_string_column(T_summary.(key));
        key_ref = as_string_column(keys.(key));
        mask = mask & key_values == key_ref(i);
    end

    subT = T_summary(mask, :);
    methods = as_string_column(subT.Method);
    baseline = subT(methods == string(baseline_name), :);
    if isempty(baseline)
        continue;
    end

    for m = 1:height(subT)
        cost = subT.AvgTxCostMean(m);
        timely = subT.TimelyRateMean(m);
        emergency = subT.EmergencyTimelyRateMean(m);
        reliability = 1.0 - subT.LossRateMean(m);

        delta_cost = cost - baseline.AvgTxCostMean(1);
        delta_timely_pp = 100.0 * (timely - baseline.TimelyRateMean(1));
        delta_emergency_pp = 100.0 * (emergency - baseline.EmergencyTimelyRateMean(1));

        row = keys(i, :);
        row.Method = methods(m);
        row.BaselineMethod = baseline_name;
        row.TimelyRateMean = timely;
        row.EmergencyTimelyRateMean = emergency;
        row.LossRateMean = subT.LossRateMean(m);
        row.AvgTxCostMean = cost;
        row.TimelyPerCost = safe_ratio(timely, cost);
        row.EmergencyTimelyPerCost = safe_ratio(emergency, cost);
        row.ReliabilityPerCost = safe_ratio(reliability, cost);
        row.DeltaTimely_pp = delta_timely_pp;
        row.DeltaEmergencyTimely_pp = delta_emergency_pp;
        row.DeltaAvgTxCost = delta_cost;
        row.TimelyGainPerCost_pp = gain_per_cost(delta_timely_pp, delta_cost);
        row.EmergencyGainPerCost_pp = gain_per_cost(delta_emergency_pp, delta_cost);
        row.CostEfficiencyClass = classify_efficiency( ...
            methods(m), string(baseline_name), delta_timely_pp, delta_emergency_pp, delta_cost);

        rows = append_table(rows, row);
    end
end

T_eff = rows;
end

function key_vars = get_key_vars(T)
candidate_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'};
key_vars = {};
for i = 1:numel(candidate_vars)
    if ismember(candidate_vars{i}, T.Properties.VariableNames)
        key_vars{end + 1} = candidate_vars{i}; %#ok<AGROW>
    end
end
end

function values = as_string_column(column)
if iscell(column)
    values = string(column);
else
    values = string(column);
end
end

function value = safe_ratio(num, den)
if abs(den) <= 1.0e-12 || isnan(num) || isnan(den)
    value = NaN;
else
    value = num / den;
end
end

function value = gain_per_cost(delta_pp, delta_cost)
if abs(delta_cost) <= 1.0e-12
    if abs(delta_pp) <= 1.0e-12
        value = 0.0;
    else
        value = sign(delta_pp) * Inf;
    end
else
    value = delta_pp / delta_cost;
end
end

function label = classify_efficiency(method_name, baseline_name, delta_timely_pp, delta_emergency_pp, delta_cost)
main_gain = max(delta_timely_pp, delta_emergency_pp);
if method_name == baseline_name
    label = "Baseline";
elseif delta_cost <= 1.0e-9 && main_gain >= -1.0e-9
    label = "Dominates";
elseif delta_cost > 1.0e-9 && main_gain <= 1.0e-9
    label = "NoGainExtraCost";
elseif delta_cost > 1.0e-9 && main_gain > 0
    label = "CostlyGain";
elseif delta_cost < -1.0e-9 && main_gain < 0
    label = "LowerCostLowerBenefit";
else
    label = "MixedTradeoff";
end
end

function T = append_table(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
