function result = run_step9_baseline_dcc_like(scenario, params)
%RUN_STEP9_BASELINE_DCC_LIKE ETSI DCC-like congestion-control baseline.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    cbr_proxy = min(max(1.0 - scenario.q_link(k), 0.0), 1.0);
    score(k) = cbr_proxy;

    if scenario.msg_type(k) == "emergency"
        priority(k) = params.dcc_emergency_priority;
    elseif scenario.msg_type(k) == "coop"
        priority(k) = params.dcc_coop_priority;
    else
        priority(k) = 1;
    end

    if cbr_proxy <= params.dcc_cbr_low_threshold
        rate_mult = params.dcc_rate_multiplier_high;
    elseif cbr_proxy <= params.dcc_cbr_high_threshold
        rate_mult = params.dcc_rate_multiplier_mid;
    else
        rate_mult = params.dcc_rate_multiplier_low;
    end
    tx_rate(k) = scenario.base_rate(k) * rate_mult;

    if scenario.relay_available(k) >= 0.5 && cbr_proxy < params.dcc_direct_mode_threshold
        mode(k) = 2;
    elseif priority(k) >= 3
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

result.name = "DCC-like";
result.policy = policy;
result.delivery = delivery;
end
