function result = run_step9_confidence_driven_risk_constrained(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_RISK_CONSTRAINED Risk-constrained side-copy scheduler.
%
% This method is a Step31 side-copy. It does not replace the main heuristic.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
timely_req_trace = zeros(N, 1);
success_req_trace = zeros(N, 1);
constraint_violation_trace = zeros(N, 1);

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);

    [action, meta] = decide_schedule_action_risk_constrained( ...
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
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.required_timely_trace = timely_req_trace;
policy.required_success_trace = success_req_trace;
policy.constraint_violation_trace = constraint_violation_trace;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Risk-constrained";
result.policy = policy;
result.delivery = delivery;
end

function [action, chosen_meta] = decide_schedule_action_risk_constrained( ...
    urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)

actions = enumerate_schedule_actions(relay_available, base_rate, params);
best_idx = 1;
best_obj = inf;
best_aux = struct();
best_meta = struct();
best_relaxed_idx = 1;
best_relaxed_obj = inf;
best_relaxed_aux = struct();
best_relaxed_meta = struct();
best_relaxed_violation = inf;

for i = 1:numel(actions)
    [obj, aux, meta] = compute_action_risk_constrained_objective( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    violation = compute_total_violation_local(meta);

    if violation < best_relaxed_violation - 1.0e-9 ...
            || (abs(violation - best_relaxed_violation) <= 1.0e-9 && obj < best_relaxed_obj)
        best_relaxed_idx = i;
        best_relaxed_obj = obj;
        best_relaxed_aux = aux;
        best_relaxed_meta = meta;
        best_relaxed_violation = violation;
    end

    if ~is_basic_action_feasible_local(actions(i), urgency, relay_available, params)
        continue;
    end

    if obj < best_obj
        best_idx = i;
        best_obj = obj;
        best_aux = aux;
        best_meta = meta;
    end
end

if isfinite(best_obj)
    chosen_idx = best_idx;
    chosen_obj = best_obj;
    chosen_aux = best_aux;
    chosen_meta = best_meta;
else
    chosen_idx = best_relaxed_idx;
    chosen_obj = best_relaxed_obj;
    chosen_aux = best_relaxed_aux;
    chosen_meta = best_relaxed_meta;
end

chosen = actions(chosen_idx);
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
action = chosen;
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
