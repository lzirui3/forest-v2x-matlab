function result = run_step9_baseline_aoi_greedy(scenario, params)
%RUN_STEP9_BASELINE_AOI_GREEDY Greedy AoI-reduction baseline.
% This freshness baseline does not use positioning confidence or forest
% blind-zone risk. It greedily selects from a compact representative action
% set to maximize expected AoI reduction under link success and cost.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

age = 1.0;
cost_weight = paramsafe_local(params, 'aoi_greedy_cost_weight', 0.10);
delay_weight = paramsafe_local(params, 'aoi_greedy_delay_weight', 0.04);
deadline_weight = paramsafe_local(params, 'aoi_greedy_deadline_weight', 0.28);

for k = 1:N
    age_norm = min(age / params.aoi_age_norm_cap, 1.0);
    actions = build_compact_actions_local(scenario.relay_available(k), scenario.base_rate(k), params);

    best_score = -inf;
    best_action = actions(1);
    for i = 1:numel(actions)
        action = actions(i);
        action.is_emergency = scenario.msg_type(k) == "emergency";
        aux = evaluate_compact_action_local(action, scenario, k, params);

        expected_reduction = age_norm * aux.success_prob;
        deadline_margin_penalty = max(aux.pred_delay / max(scenario.deadline(k), 1.0e-4) - 1.0, 0.0);
        urgency_bonus = 0.15 * scenario.urgency(k) * aux.timely_prob;
        candidate_score = expected_reduction + urgency_bonus ...
            - cost_weight * aux.tx_cost ...
            - delay_weight * aux.pred_delay ...
            - deadline_weight * deadline_margin_penalty;

        if candidate_score > best_score
            best_score = candidate_score;
            best_action = action;
        end
    end

    priority(k) = best_action.priority;
    tx_rate(k) = best_action.tx_rate;
    mode(k) = best_action.mode;
    score(k) = best_score;

    pred_success = min(max(best_score + 0.45, 0.05), 0.99);
    if pred_success >= 0.70
        age = 1.0;
    else
        next_k = min(k + 1, N);
        age = age + max(scenario.t(next_k) - scenario.t(k), 0.0);
    end
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "AoI-greedy";
result.policy = policy;
result.delivery = delivery;
end

function actions = build_compact_actions_local(relay_available, base_rate, params)
rate_mid = paramsafe_local(params, 'dcc_rate_multiplier_mid', 1.35);
rate_high = paramsafe_local(params, 'dcc_rate_multiplier_high', 1.7);
rate_max = params.baseline_rate_multiplier_by_priority(3);
priority_set = [1, 2, 3];
mode_set = [0, 1];
if relay_available >= 0.5
    mode_set = [mode_set, 2];
end
rate_set = unique([1.0, rate_mid, rate_high, rate_max], 'stable');

actions = repmat(struct('priority', 1, 'mode', 0, 'tx_rate', base_rate, ...
    'rate_multiplier', 1.0, 'is_emergency', false), numel(priority_set) * numel(mode_set) * numel(rate_set), 1);
idx = 1;
for p = priority_set
    for m = mode_set
        for r = rate_set
            actions(idx).priority = p;
            actions(idx).mode = m;
            actions(idx).rate_multiplier = r;
            actions(idx).tx_rate = base_rate * r;
            idx = idx + 1;
        end
    end
end
end

function aux = evaluate_compact_action_local(action, scenario, k, params)
priority_gain = 0.08 * (action.priority - 1);
mode_gain = 0.10 * (action.mode == 1) + 0.07 * (action.mode == 2);
rate_gain = 0.04 * max(action.rate_multiplier - 1.0, 0.0);
nlos_penalty = 0.04 * double(scenario.is_nlos(k));
aux.success_prob = min(max(scenario.q_link(k) + priority_gain + mode_gain + rate_gain - nlos_penalty, 0.02), 0.995);

mode_overhead = 0.0;
if action.mode == 1
    mode_overhead = params.mode_overhead_redundant;
elseif action.mode == 2
    mode_overhead = params.mode_overhead_relay;
end
n_attempts = max(1, ceil(action.rate_multiplier));
aux.pred_delay = scenario.delay(k) + mode_overhead + params.attempt_gap * (n_attempts - 1);
aux.pred_delay = aux.pred_delay / max(action.rate_multiplier, 0.2);
deadline_term = double(aux.pred_delay <= scenario.deadline(k));
aux.timely_prob = aux.success_prob * deadline_term;
aux.tx_cost = infer_tx_cost_local(action, params);
end

function tx_cost = infer_tx_cost_local(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
tx_cost = mode_cost * action.rate_multiplier;
end

function v = paramsafe_local(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
