function result = run_step9_baseline_link_only(scenario, params)
%RUN_STEP9_BASELINE_LINK_ONLY Link-aware baseline without positioning confidence.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = scenario.base_rate;
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    risk = 0.60 * scenario.urgency(k) + 0.40 * (1.0 - scenario.q_link(k));
    score(k) = risk;

    if risk < params.T1
        priority(k) = 1;
    elseif risk < params.T2
        priority(k) = 2;
    else
        priority(k) = 3;
    end

    tx_rate(k) = params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k);

    if scenario.q_link(k) >= params.link_good_threshold
        mode(k) = 0;
    elseif scenario.relay_available(k) >= 0.5
        mode(k) = 2;
    else
        mode(k) = 1;
    end
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Link-aware";
result.policy = policy;
result.delivery = delivery;
end
