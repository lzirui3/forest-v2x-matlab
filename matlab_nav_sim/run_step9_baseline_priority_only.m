function result = run_step9_baseline_priority_only(scenario, params)
%RUN_STEP9_BASELINE_PRIORITY_ONLY Priority-aware baseline without context adaptation.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = scenario.urgency;

for k = 1:N
    if scenario.urgency(k) < params.T1
        priority(k) = 1;
    elseif scenario.urgency(k) < params.T2
        priority(k) = 2;
    else
        priority(k) = 3;
    end

    tx_rate(k) = params.baseline_rate_multiplier_by_priority(priority(k)) * scenario.base_rate(k);

    if priority(k) >= 3
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

result.name = "Priority-only";
result.policy = policy;
result.delivery = delivery;
end
