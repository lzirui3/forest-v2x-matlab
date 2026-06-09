function result = evaluate_step9_calibration_objective(weight_cfg)
%EVALUATE_STEP9_CALIBRATION_OBJECTIVE Evaluate one utility-weight configuration.

profiles = get_default_step9_weight_calibration_profiles();
raw_rows = [];

for i = 1:numel(profiles.entries)
    entry = profiles.entries{i};
    for seed = profiles.seed_list
        params = get_default_step9_params();
        params.random_seed = seed;
        params = apply_step13_scenario_profile(params, entry.gnss, entry.rsu, entry.load);
        params = apply_weight_config(params, weight_cfg);

        scenario = generate_step9_scenario(params);
        method_result = run_step9_confidence_driven(scenario, params);
        T = evaluate_step9_metrics(scenario, {method_result});
        metrics = compute_step9_stage_metrics(scenario, method_result, define_step9_stage_masks(scenario.t));
        posdeg = get_stage_metric(metrics, 'PosDeg_Emerg');

        row = T(:, :);
        row.GNSSLevel = entry.gnss;
        row.RSULevel = entry.rsu;
        row.LoadLevel = entry.load;
        row.Seed = seed;
        row.PosDegEmergencyTimelyRate = posdeg.emergency_timely_rate;
        row.PosDegAvgTxCost = posdeg.avg_tx_cost;

        if isempty(raw_rows)
            raw_rows = row;
        else
            raw_rows = [raw_rows; row]; %#ok<AGROW>
        end
    end
end

overall_emg = mean(raw_rows.EmergencyTimelyRate, 'omitnan');
overall_timely = mean(raw_rows.TimelyRate, 'omitnan');
posdeg_emg = mean(raw_rows.PosDegEmergencyTimelyRate, 'omitnan');
avg_cost = mean(raw_rows.AvgTxCost, 'omitnan');
posdeg_cost = mean(raw_rows.PosDegAvgTxCost, 'omitnan');
loss_mean = mean(raw_rows.LossRate, 'omitnan');

objective = overall_emg ...
    + 0.85 * posdeg_emg ...
    + 0.20 * overall_timely ...
    - 0.05 * avg_cost ...
    - 0.02 * posdeg_cost ...
    - 0.50 * loss_mean;

result.config = weight_cfg;
result.raw = raw_rows;
result.objective = objective;
result.overall_emergency_timely = overall_emg;
result.overall_timely = overall_timely;
result.posdeg_emergency_timely = posdeg_emg;
result.avg_tx_cost = avg_cost;
result.posdeg_avg_tx_cost = posdeg_cost;
result.loss_rate = loss_mean;
end

function params = apply_weight_config(params, weight_cfg)
names = fieldnames(weight_cfg);
for i = 1:numel(names)
    params.(names{i}) = weight_cfg.(names{i});
end
end

function metric = get_stage_metric(metrics, stage_name)
metric = struct('stage', stage_name, 'avg_delay_s', NaN, 'timely_rate', NaN, ...
    'loss_rate', NaN, 'avg_tx_cost', NaN, 'emergency_timely_rate', NaN);
for ii = 1:numel(metrics)
    if strcmp(metrics(ii).stage, stage_name)
        metric = metrics(ii);
        return;
    end
end
end
