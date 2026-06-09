function result = run_step9_chance_risk_aoi_scheduler(scenario, params)
%RUN_STEP9_CHANCE_RISK_AOI_SCHEDULER Step63 chance-risk-AoI side-copy.
%
% Candidate method only. It does not replace run_step9_proposed_method.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
timely_req_trace = zeros(N, 1);
success_req_trace = zeros(N, 1);
constraint_violation_trace = zeros(N, 1);
feasible_action_ratio_trace = zeros(N, 1);
aoi_age_trace = zeros(N, 1);
selection_reason = strings(N, 1);

aoi_age = 0.0;
for k = 1:N
    if k > 1 && scenario.msg_type(k) ~= scenario.msg_type(k - 1)
        aoi_age = 0.0;
    else
        aoi_age = aoi_age + params.dt;
    end

    event_state = build_event_state_local(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);
    context.aoi_age = aoi_age;

    [action, meta] = decide_chance_risk_aoi_action_local( ...
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
    feasible_action_ratio_trace(k) = meta.feasible_action_ratio;
    aoi_age_trace(k) = aoi_age;
    selection_reason(k) = meta.selection_reason;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.required_timely_trace = timely_req_trace;
policy.required_success_trace = success_req_trace;
policy.constraint_violation_trace = constraint_violation_trace;
policy.feasible_action_ratio_trace = feasible_action_ratio_trace;
policy.aoi_age_trace = aoi_age_trace;
policy.selection_reason = selection_reason;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Chance-risk-AoI";
result.policy = policy;
result.delivery = delivery;
end

function [action, chosen_meta] = decide_chance_risk_aoi_action_local( ...
    urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)

actions = enumerate_schedule_actions(relay_available, base_rate, params);
best_feasible_idx = 1;
best_feasible_score = -inf;
best_feasible_aux = struct();
best_feasible_meta = struct();
best_relaxed_idx = 1;
best_relaxed_score = -inf;
best_relaxed_aux = struct();
best_relaxed_meta = struct();
best_relaxed_violation = inf;
num_feasible = 0;

for i = 1:numel(actions)
    actions(i).is_emergency = urgency >= paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
    [candidate_score, aux, meta] = compute_action_chance_risk_aoi_objective( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);

    if ~is_basic_action_feasible_local(actions(i), urgency, relay_available, params)
        meta.is_feasible = false;
        meta.total_violation = meta.total_violation + 1.0;
    end

    if meta.is_feasible
        num_feasible = num_feasible + 1;
        if candidate_score > best_feasible_score
            best_feasible_idx = i;
            best_feasible_score = candidate_score;
            best_feasible_aux = aux;
            best_feasible_meta = meta;
        end
    end

    if meta.total_violation < best_relaxed_violation - 1.0e-9 ...
            || (abs(meta.total_violation - best_relaxed_violation) <= 1.0e-9 ...
            && candidate_score > best_relaxed_score)
        best_relaxed_idx = i;
        best_relaxed_score = candidate_score;
        best_relaxed_aux = aux;
        best_relaxed_meta = meta;
        best_relaxed_violation = meta.total_violation;
    end
end

if num_feasible > 0
    chosen_idx = best_feasible_idx;
    chosen_score = best_feasible_score;
    chosen_aux = best_feasible_aux;
    chosen_meta = best_feasible_meta;
    selection_reason = "chance_feasible_max_voi";
else
    chosen_idx = best_relaxed_idx;
    chosen_score = best_relaxed_score;
    chosen_aux = best_relaxed_aux;
    chosen_meta = best_relaxed_meta;
    selection_reason = "min_chance_violation";
end

chosen = actions(chosen_idx);
chosen.score = chosen_score;
chosen.utility = chosen_score;
chosen.timely_prob = chosen_aux.timely_prob;
chosen.success_prob = chosen_aux.success_prob;
chosen.pred_delay = chosen_aux.pred_delay;
chosen.pred_tx_cost = chosen_aux.tx_cost;
chosen.required_timely = chosen_meta.required_timely;
chosen.required_success = chosen_meta.required_success;
chosen.total_violation = chosen_meta.total_violation;

chosen_meta.feasible_action_ratio = num_feasible / max(numel(actions), 1);
chosen_meta.selection_reason = selection_reason;
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

function event_state = build_event_state_local(scenario, k)
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

function value = paramsafe_local(params, name, default)
if isfield(params, name)
    value = params.(name);
else
    value = default;
end
end
