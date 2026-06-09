function result = run_step9_confidence_driven_lyapunov(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_LYAPUNOV Lyapunov drift-plus-penalty scheduler.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
queue_trace = zeros(N, 1);
arrival_trace = zeros(N, 1);
service_trace = zeros(N, 1);

queue_state = params.lyapunov_queue_init;

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);

    [action, queue_state, meta] = decide_schedule_action_lyapunov( ...
        queue_state, ...
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
    queue_trace(k) = queue_state;
    arrival_trace(k) = meta.arrival;
    service_trace(k) = meta.service;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.queue_trace = queue_trace;
policy.arrival_trace = arrival_trace;
policy.service_trace = service_trace;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Confidence-lyapunov";
result.policy = policy;
result.delivery = delivery;
end

function [action, queue_next, chosen_meta] = decide_schedule_action_lyapunov( ...
    queue_state, urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)

actions = enumerate_schedule_actions(relay_available, base_rate, params);
best_idx = 1;
best_obj = inf;
best_aux = struct();
best_meta = struct();
best_relaxed_idx = 1;
best_relaxed_obj = inf;
best_relaxed_aux = struct();
best_relaxed_meta = struct();

for i = 1:numel(actions)
    [obj, aux, meta] = compute_action_lyapunov_objective( ...
        queue_state, urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);

    if obj < best_relaxed_obj
        best_relaxed_idx = i;
        best_relaxed_obj = obj;
        best_relaxed_aux = aux;
        best_relaxed_meta = meta;
    end

    if ~is_action_feasible(actions(i), urgency, q_link, q_pos, relay_available, params, event_state)
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
chosen.required_protection = chosen_meta.required_protection;
chosen.drift_term = chosen_meta.drift_term;
chosen.penalty_term = chosen_meta.penalty;
chosen.reward_term = chosen_meta.reward;
chosen.arrival = chosen_meta.arrival;
chosen.service = chosen_meta.service;
action = chosen;

queue_next = chosen_meta.queue_next;
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
