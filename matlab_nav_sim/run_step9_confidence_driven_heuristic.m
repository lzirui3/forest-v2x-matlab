function result = run_step9_confidence_driven_heuristic(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_HEURISTIC Legacy heuristic confidence-driven method.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
regime_active = false;

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);

    enter_regime = event_state.blind_zone_gate >= params.confidence_regime_blind_threshold ...
        || scenario.q_pos(k) <= params.confidence_regime_qpos_threshold;
    hold_regime = event_state.blind_zone_gate >= params.confidence_regime_hold_blind_threshold ...
        || scenario.q_pos(k) <= params.confidence_regime_hold_qpos_threshold;

    if ~regime_active
        regime_active = enter_regime;
    else
        regime_active = hold_regime;
    end

    if regime_active
        q_pos_used = scenario.q_pos(k);
    else
        q_pos_used = 1.0;
        event_state = get_neutral_event_state();
    end

    action = decide_schedule_action_heuristic( ...
        scenario.urgency(k), ...
        scenario.q_link(k), ...
        q_pos_used, ...
        scenario.relay_available(k), ...
        scenario.base_rate(k), ...
        params, ...
        event_state, ...
        context);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Confidence-heuristic";
result.policy = policy;
result.delivery = delivery;
end

function event_state = get_neutral_event_state()
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
end

function action = decide_schedule_action_heuristic(urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)
actions = enumerate_schedule_actions(relay_available, base_rate, params);
best_score = -inf;
best_action = actions(1);
best_aux = struct();
best_relaxed_score = -inf;
best_relaxed_violation = inf;
best_relaxed_action = actions(1);
best_relaxed_aux = struct();

required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
blind_score = compute_blind_score_local(urgency, q_link, q_pos, event_state, params);
high_pdr_bypass = false;

for i = 1:numel(actions)
    [utility_value, aux] = compute_action_utility( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    if i == 1
        high_pdr_bypass = should_bypass_protection_local(aux, blind_score, params);
    end
    surplus_penalty = compute_surplus_regularization_local( ...
        actions(i), aux, urgency, q_link, q_pos, base_rate, params, event_state, required_timely);
    score = utility_value + compute_regime_bias_local(actions(i), urgency, q_link, q_pos, event_state, params, high_pdr_bypass) ...
        - params.utility_constraint_penalty * max(required_timely - aux.timely_prob, 0.0) ...
        - surplus_penalty;

    violation = compute_action_violation_score( ...
        actions(i), urgency, q_link, q_pos, relay_available, params, event_state, required_timely, aux);
    if violation < best_relaxed_violation - 1.0e-9 ...
            || (abs(violation - best_relaxed_violation) <= 1.0e-9 && score > best_relaxed_score)
        best_relaxed_violation = violation;
        best_relaxed_score = score;
        best_relaxed_action = actions(i);
        best_relaxed_aux = aux;
    end

    feasible_options = struct('bypass_blind_protection', high_pdr_bypass);
    if ~is_action_feasible(actions(i), urgency, q_link, q_pos, relay_available, params, event_state, feasible_options)
        continue;
    end

    if ~passes_deadline_guard_local(actions(i), aux, urgency, params)
        continue;
    end

    if score > best_score
        best_score = score;
        best_action = actions(i);
        best_aux = aux;
    end
end

if ~isfinite(best_score)
    best_score = best_relaxed_score;
    best_action = best_relaxed_action;
    best_aux = best_relaxed_aux;
end

action = best_action;
action.score = best_score;
action.utility = best_score;
action.timely_prob = best_aux.timely_prob;
action.success_prob = best_aux.success_prob;
action.pred_delay = best_aux.pred_delay;
action.pred_tx_cost = best_aux.tx_cost;
action.risk_penalty = best_aux.risk_penalty;
action.event_gain = best_aux.event_gain;
action.required_timely = required_timely;
end

function event_state = build_event_state(scenario, k)
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
if isfield(scenario, 'blind_zone_gate')
    event_state.blind_zone_gate = scenario.blind_zone_gate(k);
end
if isfield(scenario, 'rsu_gain_gate')
    event_state.rsu_gain_gate = scenario.rsu_gain_gate(k);
end
if isfield(scenario, 'env_correction_gate')
    event_state.env_correction_gate = scenario.env_correction_gate(k);
end
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
if isfield(scenario, 'position_modules')
    event_state.use_gnss = scenario.position_modules.use_gnss;
    event_state.use_rsu = scenario.position_modules.use_rsu;
    event_state.use_env = scenario.position_modules.use_env;
    event_state.use_traj = scenario.position_modules.use_traj;
end
end

function regime_bias = compute_regime_bias_local(action, urgency, q_link, q_pos, event_state, params, high_pdr_bypass)
if nargin < 7
    high_pdr_bypass = false;
end
regime_bias = 0.0;
blind_score = compute_blind_score_local(urgency, q_link, q_pos, event_state, params);

if blind_score < params.utility_low_risk_guard_threshold ...
        && blind_score < params.utility_low_risk_blind_threshold
    if action.mode == 0
        regime_bias = regime_bias + 0.10;
    else
        regime_bias = regime_bias - 0.10;
    end
end

if high_pdr_bypass && action.mode > 0
    regime_bias = regime_bias - 0.18 * action.mode;
end

if blind_score >= params.utility_blind_protection_threshold && q_pos <= params.utility_blind_pos_threshold
    if high_pdr_bypass
        return;
    end
    if action.priority >= params.utility_blind_min_priority
        regime_bias = regime_bias + 0.06;
    end
    if action.rate_multiplier >= params.baseline_rate_multiplier_by_priority(action.priority)
        regime_bias = regime_bias + 0.05;
    end
    if blind_score >= params.utility_blind_relay_threshold && action.mode >= params.utility_blind_force_mode
        regime_bias = regime_bias + 0.08;
    end
end
end

function blind_score = compute_blind_score_local(urgency, q_link, q_pos, event_state, params)
blind_score = max(event_state.blind_zone_gate, ...
    params.utility_low_risk_weight_urgency * urgency ...
    + params.utility_low_risk_weight_link * (1.0 - q_link) ...
    + params.utility_low_risk_weight_pos * (1.0 - q_pos));
end

function bypass = should_bypass_protection_local(aux, blind_score, params)
threshold = paramsafe_local(params, 'regime_pdr_bypass_threshold', inf);
min_blind = paramsafe_local(params, 'regime_pdr_bypass_min_blind_score', 0.0);
bypass = isfield(aux, 'success_prob') ...
    && aux.success_prob >= threshold ...
    && blind_score >= min_blind;
end

function pass = passes_deadline_guard_local(action, aux, urgency, params)
guard_min_urgency = paramsafe_local(params, 'deadline_guard_min_urgency', inf);
if urgency < guard_min_urgency || action.mode == 0
    pass = true;
    return;
end
if ~isfield(aux, 'pred_delay') || ~isfield(aux, 'deadline') || isnan(aux.pred_delay) || isnan(aux.deadline)
    pass = true;
    return;
end
guard_ratio = paramsafe_local(params, 'deadline_guard_ratio', 1.0);
pass = aux.pred_delay <= aux.deadline * guard_ratio + 1.0e-9;
end

function v = paramsafe_local(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end

function surplus_penalty = compute_surplus_regularization_local( ...
    action, aux, urgency, q_link, q_pos, base_rate, params, event_state, required_timely)
surplus_penalty = 0.0;

piecewise_pos_risk = compute_piecewise_position_risk(q_pos, params);
blind_zone_gain = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);
risk_gate = max(piecewise_pos_risk, blind_zone_gain);
activation = params.utility_surplus_penalty_activation;
if risk_gate <= activation
    return;
end

required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
timely_surplus = max(aux.timely_prob - required_timely, 0.0);
protection_surplus = max(aux.protection_level - required_protection, 0.0);
timely_surplus = max(timely_surplus - params.utility_surplus_penalty_timely_margin, 0.0);
protection_surplus = max(protection_surplus - params.utility_surplus_penalty_protection_margin, 0.0);
if timely_surplus <= 1.0e-9 && protection_surplus <= 1.0e-9
    return;
end

risk_gain = (risk_gate - activation) / max(1.0 - activation, 1.0e-6);
blind_score = max(event_state.blind_zone_gate, ...
    params.utility_low_risk_weight_urgency * urgency ...
    + params.utility_low_risk_weight_link * (1.0 - q_link) ...
    + params.utility_low_risk_weight_pos * (1.0 - q_pos));

target_priority = 1;
if urgency >= params.utility_emergency_urgency_threshold
    target_priority = max(target_priority, params.utility_min_priority_when_emergency);
end
if q_link < params.link_bad_threshold && q_pos < params.pos_low_threshold
    target_priority = max(target_priority, params.utility_min_priority_when_high_risk);
end
target_mode = 0;
if blind_score >= params.utility_blind_protection_threshold && q_pos <= params.utility_blind_pos_threshold
    target_priority = max(target_priority, params.utility_blind_min_priority);
    if blind_score >= params.utility_blind_relay_threshold
        target_mode = params.utility_blind_force_mode;
    end
end

reference_cost = params.tx_cost_direct * base_rate * params.priority_rate_scale(target_priority);
extra_tx_cost = max(aux.tx_cost - reference_cost, 0.0);
priority_excess = max(action.priority - target_priority, 0.0);
mode_excess = max(action.mode - target_mode, 0.0);

surplus_penalty = risk_gain * ( ...
    params.utility_surplus_penalty_timely_scale * timely_surplus ...
    + params.utility_surplus_penalty_protection_scale * protection_surplus) * ( ...
    params.utility_surplus_penalty_cost_scale * extra_tx_cost ...
    + params.utility_surplus_penalty_priority_scale * priority_excess ...
    + params.utility_surplus_penalty_mode_scale * mode_excess);
end
