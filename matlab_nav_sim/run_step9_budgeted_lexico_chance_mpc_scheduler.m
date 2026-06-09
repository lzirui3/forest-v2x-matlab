function result = run_step9_budgeted_lexico_chance_mpc_scheduler(scenario, params)
%RUN_STEP9_BUDGETED_LEXICO_CHANCE_MPC_SCHEDULER Step65 budgeted lexico MPC.
%
% Candidate method only. Compared with Step64, it inserts a communication
% current-action cost-control level after safety violation and before
% emergency value.
% A small safety epsilon band lets near-equivalent safety candidates be
% filtered by cost before emergency tie-breaking.

horizon = paramsafe_local(params, 'step65_horizon', paramsafe_local(params, 'step64_horizon', 2));
N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
constraint_violation_trace = zeros(N, 1);
budget_violation_trace = zeros(N, 1);
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

    [action, meta] = decide_budgeted_lexico_mpc_action_local(scenario, k, horizon, aoi_age, params);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
    constraint_violation_trace(k) = meta.safety_violation;
    budget_violation_trace(k) = meta.budget_violation;
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
policy.budget_violation_trace = budget_violation_trace;
policy.feasible_sequence_ratio_trace = feasible_sequence_ratio_trace;
policy.no_feasible_sequence_trace = no_feasible_sequence_trace;
policy.aoi_age_trace = aoi_age_trace;
policy.selection_reason = selection_reason;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Budgeted-Lexico-MPC";
result.policy = policy;
result.delivery = delivery;
end

function [action, meta] = decide_budgeted_lexico_mpc_action_local(scenario, k, horizon, aoi_age, params)
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
        seq_tuple = sequence_tuple_local(cache1.tuples(i, :), []);
        [best_tuple, best_first_idx, best_feasible_count, total_sequence_count] = update_best_local( ...
            seq_tuple, i, best_tuple, best_first_idx, best_feasible_count, total_sequence_count, params);
    end
else
    cache1 = step_cache{1};
    cache2 = step_cache{2};
    for i = 1:numel(cache1.actions)
        for j = 1:numel(cache2.actions)
            seq_tuple = sequence_tuple_local(cache1.tuples(i, :), cache2.tuples(j, :));
            [best_tuple, best_first_idx, best_feasible_count, total_sequence_count] = update_best_local( ...
                seq_tuple, i, best_tuple, best_first_idx, best_feasible_count, total_sequence_count, params);
        end
    end
end

chosen = step_cache{1}.actions(best_first_idx);
chosen.score = -best_tuple(1) - best_tuple(2);
chosen.utility = chosen.score;
action = chosen;

meta.safety_violation = best_tuple(1);
meta.budget_violation = best_tuple(4);
meta.feasible_sequence_ratio = best_feasible_count / max(total_sequence_count, 1);
meta.no_feasible_sequence = best_feasible_count == 0;
if meta.no_feasible_sequence
    meta.selection_reason = "budgeted_lexico_min_violation";
else
    meta.selection_reason = "budgeted_lexico_feasible";
end
end

function [best_tuple, best_first_idx, feasible_count, total_count] = update_best_local( ...
    seq_tuple, first_idx, best_tuple, best_first_idx, feasible_count, total_count, params)
total_count = total_count + 1;
safety_tol = paramsafe_local(params, 'step65_feasibility_tol', 1.0e-9);
budget_tol = paramsafe_local(params, 'step65_budget_feasibility_tol', 1.0e-9);
if seq_tuple(1) <= safety_tol && seq_tuple(4) <= budget_tol
    feasible_count = feasible_count + 1;
end
if isempty(best_tuple) || is_budgeted_lexico_better_local(seq_tuple, best_tuple, params)
    best_tuple = seq_tuple;
    best_first_idx = first_idx;
end
end

function seq_tuple = sequence_tuple_local(first_tuple, second_tuple)
if isempty(second_tuple)
    horizon_tuple = first_tuple;
else
    horizon_tuple = first_tuple + second_tuple;
end
% First element remains horizon safety violation. The second element is the
% current executable cost, preventing a low future-cost action from masking
% an expensive current action.
seq_tuple = [horizon_tuple(1), first_tuple(2), horizon_tuple(3), horizon_tuple(4), horizon_tuple(5)];
end

function cache = build_step_action_cache_local(scenario, idx, aoi_age, params)
relay_available = scenario.relay_available(idx);
base_rate = scenario.base_rate(idx);
urgency = scenario.urgency(idx);
q_link = scenario.q_link(idx);
q_pos = scenario.q_pos(idx);
actions = enumerate_schedule_actions(relay_available, base_rate, params);
tuples = zeros(numel(actions), 5);

event_state = build_event_state_local(scenario, idx);
context.sinr_dB = scenario.sinr_dB(idx);
context.is_nlos = scenario.is_nlos(idx);
context.msg_type = scenario.msg_type(idx);
context.deadline = scenario.deadline(idx);
context.aoi_age = aoi_age;

for i = 1:numel(actions)
    actions(i).is_emergency = urgency >= paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
    [tuple64, ~, meta64] = compute_lexico_chance_mpc_tuple( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    if ~is_basic_action_feasible_local(actions(i), urgency, relay_available, params)
        tuple64(1) = tuple64(1) + 1.0;
    elseif ~meta64.is_feasible
        tuple64(1) = tuple64(1) + 0.0;
    end
    budget = compute_step65_cost_budget_local(urgency, q_link, q_pos, base_rate, event_state, params);
    budget_violation = max(tuple64(3) - budget, 0.0) / max(budget, 1.0e-6);
    tuples(i, :) = [tuple64(1), tuple64(3), tuple64(2), budget_violation, tuple64(4)];
end

cache.actions = actions;
cache.tuples = tuples;
end

function budget = compute_step65_cost_budget_local(urgency, q_link, q_pos, base_rate, event_state, params)
emg_thr = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
blind_thr = paramsafe_local(params, 'blind_zone_trigger_threshold', 0.55);
pos_low = paramsafe_local(params, 'pos_low_threshold', 0.40);
link_bad = paramsafe_local(params, 'link_bad_threshold', 0.35);

is_hard = urgency >= emg_thr || event_state.blind_zone_gate >= blind_thr || q_pos <= pos_low;
is_medium = urgency >= 0.50 || q_link <= link_bad;

base_budget = params.tx_cost_direct * base_rate;
if is_hard
    multiplier = paramsafe_local(params, 'step65_cost_budget_multiplier_hard', 2.35);
elseif is_medium
    multiplier = paramsafe_local(params, 'step65_cost_budget_multiplier_medium', 1.95);
else
    multiplier = paramsafe_local(params, 'step65_cost_budget_multiplier_normal', 1.45);
end
budget = base_budget * multiplier;
end

function better = is_budgeted_lexico_better_local(candidate, incumbent, params)
tol = 1.0e-9;
better = false;
safety_band = paramsafe_local(params, 'step65_safety_epsilon_band', 0.020);

if candidate(1) < incumbent(1) - safety_band
    better = true;
    return;
elseif candidate(1) > incumbent(1) + safety_band
    return;
end

for i = 2:numel(candidate)
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
