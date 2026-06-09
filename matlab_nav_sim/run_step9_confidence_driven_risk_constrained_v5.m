function result = run_step9_confidence_driven_risk_constrained_v5(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_RISK_CONSTRAINED_V5 Cost-calibrated emergency-safe scheduler.
%
% Step37 side-copy. It uses the Step36-selected actual-cost weight and adds
% a local emergency safeguard that chooses the strongest bounded-cost
% emergency action when it improves predicted timely delivery.

if ~isfield(params, 'risk_v4_actual_cost_weight')
    params.risk_v4_actual_cost_weight = 0.060;
end

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

    [action, meta] = decide_schedule_action_risk_constrained_v5( ...
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

result.name = "Risk-constrained-v5";
result.policy = policy;
result.delivery = delivery;
end

function [action, chosen_meta] = decide_schedule_action_risk_constrained_v5( ...
    urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)

actions = enumerate_schedule_actions(relay_available, base_rate, params);
num_actions = numel(actions);
cache = repmat(local_empty_cache(), num_actions, 1);

best_idx = 1;
best_obj = inf;
best_relaxed_idx = 1;
best_relaxed_obj = inf;
best_relaxed_violation = inf;

for i = 1:num_actions
    [obj, aux, meta] = compute_action_risk_constrained_objective_v4( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    violation = compute_total_violation_local(meta);
    basic_feasible = is_basic_action_feasible_local(actions(i), urgency, relay_available, params);

    cache(i).obj = obj;
    cache(i).aux = aux;
    cache(i).meta = meta;
    cache(i).total_violation = violation;
    cache(i).actual_cost = aux.tx_cost;
    cache(i).basic_feasible = basic_feasible;

    if violation < best_relaxed_violation - 1.0e-9 ...
            || (abs(violation - best_relaxed_violation) <= 1.0e-9 && obj < best_relaxed_obj)
        best_relaxed_idx = i;
        best_relaxed_obj = obj;
        best_relaxed_violation = violation;
    end

    if basic_feasible && obj < best_obj
        best_idx = i;
        best_obj = obj;
    end
end

if isfinite(best_obj)
    chosen_idx = best_idx;
    selection_reason = "cost_calibrated_lagrangian";
else
    chosen_idx = best_relaxed_idx;
    selection_reason = "relaxed_min_violation";
end

emg_thresh = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh
    guard_idx = select_emergency_guard_action_local(actions, cache, chosen_idx, params);
    if guard_idx ~= chosen_idx
        chosen_idx = guard_idx;
        selection_reason = "emergency_guard";
    end
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
chosen.pred_tx_cost = chosen_aux.tx_cost;
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
cache.actual_cost = inf;
cache.basic_feasible = false;
end

function chosen_idx = select_emergency_guard_action_local(actions, cache, anchor_idx, params)
chosen_idx = anchor_idx;
anchor = cache(anchor_idx);
anchor_aux = anchor.aux;

cost_cap_pct = paramsafe_local(params, 'risk_v5_emergency_cost_cap_pct', 0.35);
timely_gain_min = paramsafe_local(params, 'risk_v5_emergency_timely_gain_min', 0.0005);
success_loss_tol = paramsafe_local(params, 'risk_v5_emergency_success_loss_tol', 0.005);
deadline_ratio = paramsafe_local(params, 'risk_v5_emergency_deadline_ratio', 1.02);
max_cost = anchor.actual_cost * (1.0 + cost_cap_pct);

best_timely = anchor_aux.timely_prob;
best_success = anchor_aux.success_prob;
best_cost = anchor.actual_cost;

for i = 1:numel(actions)
    if i == anchor_idx || ~cache(i).basic_feasible
        continue;
    end
    if cache(i).actual_cost > max_cost + 1.0e-9
        continue;
    end
    if cache(i).aux.pred_delay > cache(i).aux.deadline * deadline_ratio + 1.0e-9
        continue;
    end
    if cache(i).aux.timely_prob < anchor_aux.timely_prob + timely_gain_min
        continue;
    end
    if cache(i).aux.success_prob + success_loss_tol < anchor_aux.success_prob
        continue;
    end

    if cache(i).aux.timely_prob > best_timely + 1.0e-9 ...
            || (abs(cache(i).aux.timely_prob - best_timely) <= 1.0e-9 && cache(i).aux.success_prob > best_success + 1.0e-9) ...
            || (abs(cache(i).aux.timely_prob - best_timely) <= 1.0e-9 && abs(cache(i).aux.success_prob - best_success) <= 1.0e-9 ...
            && cache(i).actual_cost < best_cost)
        chosen_idx = i;
        best_timely = cache(i).aux.timely_prob;
        best_success = cache(i).aux.success_prob;
        best_cost = cache(i).actual_cost;
    end
end
end

function feasible = is_basic_action_feasible_local(action, urgency, relay_available, params)
feasible = true;

if action.mode == 2 && relay_available < 0.5
    feasible = false;
    return;
end

if action.rate_multiplier + 1.0e-9 < params.priority_rate_scale(action.priority)
    feasible = false;
    return;
end

emg_thresh = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh && action.priority < params.utility_min_priority_when_emergency
    feasible = false;
    return;
end
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
