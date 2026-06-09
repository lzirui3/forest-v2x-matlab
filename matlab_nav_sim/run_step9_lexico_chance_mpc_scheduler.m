function result = run_step9_lexico_chance_mpc_scheduler(scenario, params)
%RUN_STEP9_LEXICO_CHANCE_MPC_SCHEDULER Step64 lexicographic chance MPC.
%
% Candidate method only. It enumerates finite action sequences over a short
% horizon and executes only the first action.

horizon = paramsafe_local(params, 'step64_horizon', 2);
N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
constraint_violation_trace = zeros(N, 1);
feasible_sequence_ratio_trace = zeros(N, 1);
no_feasible_sequence_trace = false(N, 1);
aoi_age_trace = zeros(N, 1);
selection_reason = strings(N, 1);

aoi_age = 0.0;
for k = 1:N
    if k > 1 && scenario.msg_type(k) ~= scenario.msg_type(k - 1)
        aoi_age = 0.0;
    else
        aoi_age = aoi_age + params.dt;
    end

    [action, meta] = decide_lexico_mpc_action_local(scenario, k, horizon, aoi_age, params);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
    constraint_violation_trace(k) = meta.total_violation;
    feasible_sequence_ratio_trace(k) = meta.feasible_sequence_ratio;
    no_feasible_sequence_trace(k) = meta.no_feasible_sequence;
    aoi_age_trace(k) = aoi_age;
    selection_reason(k) = meta.selection_reason;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.constraint_violation_trace = constraint_violation_trace;
policy.feasible_sequence_ratio_trace = feasible_sequence_ratio_trace;
policy.no_feasible_sequence_trace = no_feasible_sequence_trace;
policy.aoi_age_trace = aoi_age_trace;
policy.selection_reason = selection_reason;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Lexico-Chance-MPC";
result.policy = policy;
result.delivery = delivery;
end

function [action, meta] = decide_lexico_mpc_action_local(scenario, k, horizon, aoi_age, params)
N = numel(scenario.t);
max_step = min(k + horizon - 1, N);
H_eff = max_step - k + 1;

step_cache = cell(H_eff, 1);
for h = 1:H_eff
    idx = k + h - 1;
    step_cache{h} = build_step_action_cache_local(scenario, idx, aoi_age + (h - 1) * params.dt, params);
end

best_tuple = [];
best_first_idx = 1;
best_feasible_count = 0;
total_sequence_count = 0;

if H_eff == 1
    cache1 = step_cache{1};
    for i = 1:numel(cache1.actions)
        seq_tuple = cache1.tuples(i, :);
        total_sequence_count = total_sequence_count + 1;
        if seq_tuple(1) <= paramsafe_local(params, 'step64_feasibility_tol', 1.0e-9)
            best_feasible_count = best_feasible_count + 1;
        end
        if isempty(best_tuple) || is_lexico_better_local(seq_tuple, best_tuple)
            best_tuple = seq_tuple;
            best_first_idx = i;
        end
    end
else
    cache1 = step_cache{1};
    cache2 = step_cache{2};
    for i = 1:numel(cache1.actions)
        for j = 1:numel(cache2.actions)
            seq_tuple = cache1.tuples(i, :) + cache2.tuples(j, :);
            total_sequence_count = total_sequence_count + 1;
            if seq_tuple(1) <= paramsafe_local(params, 'step64_feasibility_tol', 1.0e-9)
                best_feasible_count = best_feasible_count + 1;
            end
            if isempty(best_tuple) || is_lexico_better_local(seq_tuple, best_tuple)
                best_tuple = seq_tuple;
                best_first_idx = i;
            end
        end
    end
end

chosen = step_cache{1}.actions(best_first_idx);
chosen.score = -best_tuple(1);
chosen.utility = chosen.score;
action = chosen;

meta.total_violation = best_tuple(1);
meta.feasible_sequence_ratio = best_feasible_count / max(total_sequence_count, 1);
meta.no_feasible_sequence = best_feasible_count == 0;
if meta.no_feasible_sequence
    meta.selection_reason = "lexico_min_violation";
else
    meta.selection_reason = "lexico_feasible_min_cost";
end
end

function cache = build_step_action_cache_local(scenario, idx, aoi_age, params)
relay_available = scenario.relay_available(idx);
base_rate = scenario.base_rate(idx);
urgency = scenario.urgency(idx);
q_link = scenario.q_link(idx);
q_pos = scenario.q_pos(idx);
actions = enumerate_schedule_actions(relay_available, base_rate, params);
tuples = zeros(numel(actions), 4);

event_state = build_event_state_local(scenario, idx);
context.sinr_dB = scenario.sinr_dB(idx);
context.is_nlos = scenario.is_nlos(idx);
context.msg_type = scenario.msg_type(idx);
context.deadline = scenario.deadline(idx);
context.aoi_age = aoi_age;

for i = 1:numel(actions)
    actions(i).is_emergency = urgency >= paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
    [tuple, ~, meta] = compute_lexico_chance_mpc_tuple( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    if ~is_basic_action_feasible_local(actions(i), urgency, relay_available, params)
        tuple(1) = tuple(1) + 1.0;
    elseif ~meta.is_feasible
        tuple(1) = tuple(1) + 0.0;
    end
    tuples(i, :) = tuple;
end

cache.actions = actions;
cache.tuples = tuples;
end

function better = is_lexico_better_local(candidate, incumbent)
tol = 1.0e-9;
better = false;
for i = 1:numel(candidate)
    if candidate(i) < incumbent(i) - tol
        better = true;
        return;
    elseif candidate(i) > incumbent(i) + tol
        return;
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
