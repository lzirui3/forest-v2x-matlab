function T = evaluate_step9_metrics(scenario, results)
%EVALUATE_STEP9_METRICS Build comparison table for Step 9 methods.

num_methods = numel(results);
method = strings(num_methods, 1);
avg_delay = zeros(num_methods, 1);
timely_rate = zeros(num_methods, 1);
loss_rate = zeros(num_methods, 1);
tx_cost = zeros(num_methods, 1);
emg_timely = zeros(num_methods, 1);

idx_emg = scenario.msg_type == "emergency";

for i = 1:num_methods
    method(i) = results{i}.name;
    delivery = results{i}.delivery;

    % 延迟度量：对未投递的包赋予 deadline 惩罚，避免选择偏差
    % （丢包率高的方法不应因"只统计成功包"而显示更低延迟）
    delay_with_penalty = delivery.delay;
    if isfield(scenario, 'deadline')
        delay_with_penalty(~delivery.delivered) = scenario.deadline(~delivery.delivered);
    else
        delay_with_penalty(~delivery.delivered) = max(delivery.delay);
    end
    avg_delay(i) = mean(delay_with_penalty);
    if isnan(avg_delay(i))
        avg_delay(i) = inf;
    end

    timely_rate(i) = mean(delivery.deadline_hit);
    loss_rate(i) = 1.0 - mean(delivery.delivered);
    tx_cost(i) = mean(delivery.tx_cost);
    emg_timely(i) = mean(delivery.deadline_hit(idx_emg));
end

T = table(method, avg_delay, timely_rate, loss_rate, tx_cost, emg_timely, ...
    'VariableNames', {'Method', 'AvgDelay_s', 'TimelyRate', 'LossRate', 'AvgTxCost', 'EmergencyTimelyRate'});
end

