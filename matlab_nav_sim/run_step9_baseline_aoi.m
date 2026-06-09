function result = run_step9_baseline_aoi(scenario, params)
%RUN_STEP9_BASELINE_AOI AoI-aware scheduling baseline.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
age = 1.0;

for k = 1:N
    age_norm = min(age / params.aoi_age_norm_cap, 1.0);
    score(k) = age_norm;

    if age_norm >= params.aoi_critical_threshold
        priority(k) = 3;
    elseif age_norm >= params.aoi_high_threshold
        priority(k) = 2;
    else
        priority(k) = 1;
    end

    tx_rate(k) = scenario.base_rate(k) * params.baseline_rate_multiplier_by_priority(priority(k));

    if age_norm >= params.aoi_redundant_threshold
        mode(k) = 1;
    else
        mode(k) = params.aoi_default_mode;
    end

    predicted_success = scenario.q_link(k) * (0.55 + 0.15 * priority(k) + 0.10 * mode(k));
    predicted_success = min(max(predicted_success, 0.05), 0.99);
    if predicted_success >= 0.75
        age = 1.0;
    else
        age = age + scenario.t(min(k + 1, N)) - scenario.t(k);
    end
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "AoI-aware";
result.policy = policy;
result.delivery = delivery;
end
