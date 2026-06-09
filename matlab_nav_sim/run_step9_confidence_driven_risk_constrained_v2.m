function result = run_step9_confidence_driven_risk_constrained_v2(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_RISK_CONSTRAINED_V2 Cost-aware feasible risk scheduler.
%
% Step33 side-copy. The Lagrangian risk objective from Step31 is retained,
% but action selection is changed to an epsilon-constrained form:
% first satisfy state-dependent timely/success/protection targets, then pick
% the minimum actual transmission-cost action inside that feasible set.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
timely_req_trace = zeros(N, 1);
success_req_trace = zeros(N, 1);
constraint_violation_trace = zeros(N, 1);
selection_reason = strings(N, 1);

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);

    [action, meta] = decide_schedule_action_risk_constrained_v2( ...
        scenario.urgency(k), ...
        scenario.q_link(k), ...
        scenario.q_pos(k), ...
        scenario.relay_available(k), ...
        scenario.base_rate(k), ...
        params, ...
        event_state, ...
        context);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
    timely_req_trace(k) = meta.required_timely;
    success_req_trace(k) = meta.required_success;
    constraint_violation_trace(k) = meta.total_violation;
    selection_reason(k) = meta.selection_reason;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.required_timely_trace = timely_req_trace;
policy.required_success_trace = success_req_trace;
policy.constraint_violation_trace = constraint_violation_trace;
policy.selection_reason = selection_reason;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Risk-constrained-v2";
result.policy = policy;
result.delivery = delivery;
end

function [action, chosen_meta] = decide_schedule_action_risk_constrained_v2( ...
    urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)

actions = enumerate_schedule_actions(relay_available, base_rate, params);
num_actions = numel(actions);
cache = repmat(local_empty_cache(), num_actions, 1);

best_obj_idx = 1;
best_obj = inf;
best_relaxed_idx = 1;
best_relaxed_violation = inf;
best_relaxed_obj = inf;

for i = 1:num_actions
    [obj, aux, meta] = compute_action_risk_constrained_objective( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);

    total_violation = compute_total_violation_local(meta);
    basic_violation = compute_basic_violation_local(actions(i), urgency, relay_available, params);
    relaxed_violation = total_violation + basic_violation;
    actual_cost = compute_actual_tx_cost_local(actions(i), params);
    basic_feasible = basic_violation <= 1.0e-9;

    cache(i).obj = obj;
    cache(i).aux = aux;
    cache(i).meta = meta;
    cache(i).total_violation = total_violation;
    cache(i).relaxed_violation = relaxed_violation;
    cache(i).actual_cost = actual_cost;
    cache(i).basic_feasible = basic_feasible;

    if relaxed_violation < best_relaxed_violation - 1.0e-9 ...
            || (abs(relaxed_violation - best_relaxed_violation) <= 1.0e-9 && obj < best_relaxed_obj)
        best_relaxed_idx = i;
        best_relaxed_violation = relaxed_violation;
        best_relaxed_obj = obj;
    end

    if basic_feasible && obj < best_obj
        best_obj_idx = i;
        best_obj = obj;
    end
end

safe_mask = false(num_actions, 1);
for i = 1:num_actions
    if cache(i).basic_feasible && passes_epsilon_constraints_local(cache(i), params)
        safe_mask(i) = true;
    end
end

if any(safe_mask)
    chosen_idx = select_min_cost_safe_action_local(actions, cache, safe_mask);
    selection_reason = "safe_min_cost";
elseif isfinite(best_obj)
    chosen_idx = best_obj_idx;
    selection_reason = "lagrangian_fallback";
else
    chosen_idx = best_relaxed_idx;
    selection_reason = "relaxed_min_violation";
end

chosen = actions(chosen_idx);
chosen_aux = cache(chosen_idx).aux;
chosen_meta = cache(chosen_idx).meta;
chosen_obj = cache(chosen_idx).obj;

chosen.score = -chosen_obj;
chosen.utility = -chosen_obj;
chosen.timely_prob = chosen_aux.timely_prob;
chosen.success_prob = chosen_aux.success_prob;
chosen.pred_delay = chosen_aux.pred_delay;
chosen.pred_tx_cost = cache(chosen_idx).actual_cost;
chosen.risk_penalty = chosen_aux.risk_penalty;
chosen.event_gain = chosen_aux.event_gain;
chosen.required_timely = chosen_meta.required_timely;
chosen.required_success = chosen_meta.required_success;
chosen.required_protection = chosen_meta.required_protection;
chosen.info_value = chosen_meta.info_value;
chosen.total_violation = compute_total_violation_local(chosen_meta);

chosen_meta.total_violation = chosen.total_violation;
chosen_meta.selection_reason = selection_reason;
action = chosen;
end

function cache = local_empty_cache()
cache.obj = inf;
cache.aux = struct();
cache.meta = struct();
cache.total_violation = inf;
cache.relaxed_violation = inf;
cache.actual_cost = inf;
cache.basic_feasible = false;
end

function pass = passes_epsilon_constraints_local(cache, params)
aux = cache.aux;
meta = cache.meta;

timely_slack = paramsafe_local(params, 'risk_v2_timely_slack', 0.02);
success_slack = paramsafe_local(params, 'risk_v2_success_slack', 0.02);
protection_slack = paramsafe_local(params, 'risk_v2_protection_slack', 0.10);
deadline_ratio = paramsafe_local(params, 'risk_v2_deadline_ratio', 1.05);

pass = aux.timely_prob + timely_slack >= meta.required_timely ...
    && aux.success_prob + success_slack >= meta.required_success ...
    && aux.protection_level + protection_slack >= meta.required_protection ...
    && aux.pred_delay <= aux.deadline * deadline_ratio + 1.0e-9;
end

function chosen_idx = select_min_cost_safe_action_local(actions, cache, safe_mask)
chosen_idx = find(safe_mask, 1, 'first');
best_cost = inf;
best_margin = -inf;
best_obj = inf;

for i = find(safe_mask(:))'
    margin = cache(i).aux.timely_prob - cache(i).meta.required_timely;
    cost = cache(i).actual_cost;
    obj = cache(i).obj;

    if cost < best_cost - 1.0e-9 ...
            || (abs(cost - best_cost) <= 1.0e-9 && margin > best_margin + 1.0e-9) ...
            || (abs(cost - best_cost) <= 1.0e-9 && abs(margin - best_margin) <= 1.0e-9 && obj < best_obj) ...
            || (abs(cost - best_cost) <= 1.0e-9 && abs(margin - best_margin) <= 1.0e-9 && abs(obj - best_obj) <= 1.0e-9 ...
            && actions(i).priority > actions(chosen_idx).priority)
        chosen_idx = i;
        best_cost = cost;
        best_margin = margin;
        best_obj = obj;
    end
end
end

function violation = compute_basic_violation_local(action, urgency, relay_available, params)
violation = 0.0;

if action.mode == 2 && relay_available < 0.5
    violation = violation + 1.0;
end

violation = violation + max(params.priority_rate_scale(action.priority) - action.rate_multiplier, 0.0);

emg_thresh = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh
    min_priority = paramsafe_local(params, 'risk_v2_emergency_min_priority', 3);
    min_rate = paramsafe_local(params, 'risk_v2_emergency_min_rate_multiplier', 2.1);
    violation = violation + max(min_priority - action.priority, 0.0);
    violation = violation + max(min_rate - action.rate_multiplier, 0.0);
end
end

function actual_cost = compute_actual_tx_cost_local(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
actual_cost = mode_cost * action.tx_rate;
end

function total_violation = compute_total_violation_local(meta)
total_violation = meta.timely_violation ...
    + meta.success_violation ...
    + meta.deadline_violation ...
    + meta.protection_violation ...
    + meta.position_violation;
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

function v = paramsafe_local(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
