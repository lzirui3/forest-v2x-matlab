function result = run_step9_baseline_fused_rule(scenario, params)
%RUN_STEP9_BASELINE_FUSED_RULE Simple q_link + q_pos fusion baseline.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    fused_risk = 0.45 * scenario.urgency(k) ...
        + 0.30 * (1.0 - scenario.q_link(k)) ...
        + 0.25 * (1.0 - scenario.q_pos(k));
    score(k) = fused_risk;

    if fused_risk < params.T1
        priority(k) = 1;
    elseif fused_risk < params.T2
        priority(k) = 2;
    else
        priority(k) = 3;
    end

    tx_rate(k) = params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k);

    if scenario.relay_available(k) >= 0.5 && scenario.q_link(k) < params.link_good_threshold
        mode(k) = 2;
    elseif scenario.q_pos(k) < params.pos_low_threshold || scenario.q_link(k) < params.link_bad_threshold
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

result.name = "Fused-rule";
result.policy = policy;
result.delivery = delivery;
end
