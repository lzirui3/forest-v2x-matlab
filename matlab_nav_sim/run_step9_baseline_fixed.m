function result = run_step9_baseline_fixed(scenario, params)
%RUN_STEP9_BASELINE_FIXED Fixed scheduling policy baseline.

N = numel(scenario.t);
priority = ones(N, 1);
priority(scenario.msg_type == "emergency") = 3;
priority(scenario.msg_type == "coop") = 2;

tx_rate = scenario.base_rate;
mode = zeros(N, 1);

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = scenario.urgency;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Fixed";
result.policy = policy;
result.delivery = delivery;
end

