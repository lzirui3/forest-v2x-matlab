function result = run_step9_confidence_driven_risk_constrained_v3(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_RISK_CONSTRAINED_V3 Performance-anchored risk scheduler.
%
% Step34 side-copy. Step31's Lagrangian action is used as the performance
% anchor. A lower-cost action is accepted only when its predicted timely
% delivery, success probability, delay, and constraint violation remain near
% the anchor. Emergency messages additionally allow a bounded-cost upgrade
% when it improves predicted timely delivery.

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

    [action, meta] = decide_schedule_action_risk_constrained_v3( ...
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

result.name = "Risk-constrained-v3";
result.policy = policy;
result.delivery = delivery;
end

function [action, chosen_meta] = decide_schedule_action_risk_constrained_v3( ...
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

if isfinite(best_obj)
    anchor_idx = best_obj_idx;
    anchor_reason = "lagrangian_anchor";
else
    anchor_idx = best_relaxed_idx;
    anchor_reason = "relaxed_anchor";
end

chosen_idx = anchor_idx;
selection_reason = anchor_reason;

emg_thresh = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh
    upgrade_idx = select_emergency_upgrade_local(actions, cache, anchor_idx, params);
    if upgrade_idx ~= anchor_idx
        chosen_idx = upgrade_idx;
        selection_reason = "emergency_safe_upgrade";
    end
else
    replacement_idx = select_cost_replacement_local(actions, cache, anchor_idx, params);
    if replacement_idx ~= anchor_idx
        chosen_idx = replacement_idx;
        selection_reason = "anchored_cost_replacement";
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

function chosen_idx = select_cost_replacement_local(actions, cache, anchor_idx, params)
chosen_idx = anchor_idx;
anchor = cache(anchor_idx);
anchor_aux = anchor.aux;

timely_loss_tol = paramsafe_local(params, 'risk_v3_timely_loss_tol', 0.006);
success_loss_tol = paramsafe_local(params, 'risk_v3_success_loss_tol', 0.006);
delay_increase_tol = paramsafe_local(params, 'risk_v3_delay_increase_tol_s', 0.004);
protection_loss_tol = paramsafe_local(params, 'risk_v3_protection_loss_tol', 0.05);
violation_slack = paramsafe_local(params, 'risk_v3_violation_slack', 0.010);
objective_slack = paramsafe_local(params, 'risk_v3_objective_slack', 0.22);
min_cost_saving = paramsafe_local(params, 'risk_v3_min_cost_saving', 0.10);

best_cost = anchor.actual_cost;
best_timely = anchor_aux.timely_prob;
best_obj = anchor.obj;

for i = 1:numel(actions)
    if i == anchor_idx || ~cache(i).basic_feasible
        continue;
    end
    if cache(i).actual_cost > anchor.actual_cost - min_cost_saving
        continue;
    end
    if cache(i).aux.timely_prob + timely_loss_tol < anchor_aux.timely_prob
        continue;
    end
    if cache(i).aux.success_prob + success_loss_tol < anchor_aux.success_prob
        continue;
    end
    if cache(i).aux.pred_delay > anchor_aux.pred_delay + delay_increase_tol
        continue;
    end
    if cache(i).aux.protection_level + protection_loss_tol < anchor_aux.protection_level
        continue;
    end
    if cache(i).total_violation > anchor.total_violation + violation_slack
        continue;
    end
    if cache(i).obj > anchor.obj + objective_slack
        continue;
    end

    if cache(i).actual_cost < best_cost - 1.0e-9 ...
            || (abs(cache(i).actual_cost - best_cost) <= 1.0e-9 && cache(i).aux.timely_prob > best_timely + 1.0e-9) ...
            || (abs(cache(i).actual_cost - best_cost) <= 1.0e-9 && abs(cache(i).aux.timely_prob - best_timely) <= 1.0e-9 ...
            && cache(i).obj < best_obj)
        chosen_idx = i;
        best_cost = cache(i).actual_cost;
        best_timely = cache(i).aux.timely_prob;
        best_obj = cache(i).obj;
    end
end
end

function chosen_idx = select_emergency_upgrade_local(actions, cache, anchor_idx, params)
chosen_idx = anchor_idx;
anchor = cache(anchor_idx);
anchor_aux = anchor.aux;

cost_cap_pct = paramsafe_local(params, 'risk_v3_emergency_cost_increase_cap_pct', 0.35);
timely_gain_min = paramsafe_local(params, 'risk_v3_emergency_timely_gain_min', 0.001);
success_loss_tol = paramsafe_local(params, 'risk_v3_emergency_success_loss_tol', 0.003);
delay_increase_tol = paramsafe_local(params, 'risk_v3_emergency_delay_increase_tol_s', 0.001);
violation_slack = paramsafe_local(params, 'risk_v3_emergency_violation_slack', 0.005);

max_cost = anchor.actual_cost * (1.0 + cost_cap_pct);
best_timely = anchor_aux.timely_prob;
best_cost = anchor.actual_cost;
best_success = anchor_aux.success_prob;

for i = 1:numel(actions)
    if i == anchor_idx || ~cache(i).basic_feasible
        continue;
    end
    if cache(i).actual_cost > max_cost + 1.0e-9
        continue;
    end
    if cache(i).aux.timely_prob < anchor_aux.timely_prob + timely_gain_min
        continue;
    end
    if cache(i).aux.success_prob + success_loss_tol < anchor_aux.success_prob
        continue;
    end
    if cache(i).aux.pred_delay > anchor_aux.pred_delay + delay_increase_tol
        continue;
    end
    if cache(i).total_violation > anchor.total_violation + violation_slack
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

function violation = compute_basic_violation_local(action, urgency, relay_available, params)
violation = 0.0;

if action.mode == 2 && relay_available < 0.5
    violation = violation + 1.0;
end

violation = violation + max(params.priority_rate_scale(action.priority) - action.rate_multiplier, 0.0);

emg_thresh = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh
    violation = violation + max(params.utility_min_priority_when_emergency - action.priority, 0.0);
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
