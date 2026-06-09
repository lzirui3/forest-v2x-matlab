function result = run_step9_baseline_event_only(scenario, params)
%RUN_STEP9_BASELINE_EVENT_ONLY Blind-zone-event baseline without link or position adaptation.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    blind_zone_gate = 0.0;
    if isfield(scenario, 'blind_zone_gate')
        blind_zone_gate = scenario.blind_zone_gate(k);
    end

    if scenario.urgency(k) < params.T1
        priority(k) = 1;
    elseif scenario.urgency(k) < params.T2
        priority(k) = 2;
    else
        priority(k) = 3;
    end

    score(k) = scenario.urgency(k) + params.event_priority_bias * blind_zone_gate;
    tx_rate(k) = params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k);
    mode(k) = 0;

    if blind_zone_gate >= params.blind_zone_trigger_threshold
        priority(k) = max(priority(k), 2);
        tx_rate(k) = max(tx_rate(k), ...
            (1.0 + 0.45 * params.event_rate_scale_gain) ...
            * params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k));

        if scenario.urgency(k) >= 0.80
            priority(k) = 3;
        end

        mode(k) = 1;
    end
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Blind-zone-event-only";
result.policy = policy;
result.delivery = delivery;
end
