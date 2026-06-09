function result = run_step9_baseline_position_only(scenario, params)
%RUN_STEP9_BASELINE_POSITION_ONLY Position-confidence-aware baseline without link awareness.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    risk = 0.60 * scenario.urgency(k) + 0.40 * (1.0 - scenario.q_pos(k));
    score(k) = risk;

    if risk < params.pos_T1
        priority(k) = 1;
    elseif risk < params.pos_T2
        priority(k) = 2;
    else
        priority(k) = 3;
    end

    tx_rate(k) = params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k);

    if scenario.q_pos(k) < params.pos_low_threshold
        mode(k) = 1;
    else
        mode(k) = 0;
    end
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Position-only";
result.policy = policy;
result.delivery = delivery;
end
