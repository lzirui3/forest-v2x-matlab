function metrics = compute_step9_stage_metrics(scenario, result, stages)
%COMPUTE_STEP9_STAGE_METRICS Compute stage-wise delivery metrics for one method.

num_stages = numel(stages);
metrics = struct( ...
    'stage', [], ...
    'avg_delay_s', [], ...
    'timely_rate', [], ...
    'loss_rate', [], ...
    'avg_tx_cost', [], ...
    'emergency_timely_rate', []);
metrics = repmat(metrics, num_stages, 1);

for i = 1:num_stages
    idx = stages(i).mask;
    idx_emg = idx & (scenario.msg_type == "emergency");

    delay_stage = result.delivery.delay(idx & result.delivery.delivered);

    metrics(i).stage = stages(i).name;
    if isempty(delay_stage)
        metrics(i).avg_delay_s = NaN;
    else
        metrics(i).avg_delay_s = mean(delay_stage);
    end

    metrics(i).timely_rate = mean(result.delivery.deadline_hit(idx));
    metrics(i).loss_rate = 1.0 - mean(result.delivery.delivered(idx));
    metrics(i).avg_tx_cost = mean(result.delivery.tx_cost(idx));

    if any(idx_emg)
        metrics(i).emergency_timely_rate = mean(result.delivery.deadline_hit(idx_emg));
    else
        metrics(i).emergency_timely_rate = NaN;
    end
end
end

