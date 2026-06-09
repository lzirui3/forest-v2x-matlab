function [tuple, aux, meta] = compute_lexico_chance_mpc_tuple( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%COMPUTE_LEXICO_CHANCE_MPC_TUPLE Lexicographic tuple for Step64 MPC.
%
% Tuple order:
%   1) chance/safety constraint violation
%   2) negative emergency timely value
%   3) communication cost
%   4) delay/AoI penalty

if nargin < 9 || isempty(context)
    context = struct();
end

aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context);
aux.tx_cost = compute_actual_tx_cost_local(action, params);

targets = compute_step64_targets_local(urgency, q_link, q_pos, event_state, params);
timely_violation = max(targets.timely - aux.timely_prob, 0.0);
success_violation = max(targets.success - aux.success_prob, 0.0);
deadline_violation = max(aux.pred_delay / max(aux.deadline, 1.0e-6) - 1.0, 0.0);
protection_violation = max(targets.protection - aux.protection_level, 0.0);

constraint_violation = timely_violation + success_violation ...
    + deadline_violation + protection_violation;

emergency_value = compute_emergency_value_local(urgency, aux.timely_prob, params);
aoi_penalty = compute_aoi_penalty_local(context, aux.timely_prob, params);
delay_aoi_penalty = aux.delay_penalty + aoi_penalty;

tuple = [constraint_violation, -emergency_value, aux.tx_cost, delay_aoi_penalty];

meta.required_timely = targets.timely;
meta.required_success = targets.success;
meta.required_protection = targets.protection;
meta.timely_violation = timely_violation;
meta.success_violation = success_violation;
meta.deadline_violation = deadline_violation;
meta.protection_violation = protection_violation;
meta.total_violation = constraint_violation;
meta.emergency_value = emergency_value;
meta.aoi_penalty = aoi_penalty;
meta.is_feasible = constraint_violation <= paramsafe(params, 'step64_feasibility_tol', 1.0e-9);
end

function targets = compute_step64_targets_local(urgency, q_link, q_pos, event_state, params)
emg_thr = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
blind_thr = paramsafe(params, 'blind_zone_trigger_threshold', 0.55);
pos_low = paramsafe(params, 'pos_low_threshold', 0.40);
link_bad = paramsafe(params, 'link_bad_threshold', 0.35);

is_hard = urgency >= emg_thr || event_state.blind_zone_gate >= blind_thr || q_pos <= pos_low;
is_medium = urgency >= 0.50 || q_link <= link_bad;

if is_hard
    targets.timely = paramsafe(params, 'step64_timely_target_hard', 0.86);
    targets.success = paramsafe(params, 'step64_success_target_hard', 0.90);
elseif is_medium
    targets.timely = paramsafe(params, 'step64_timely_target_medium', 0.76);
    targets.success = paramsafe(params, 'step64_success_target_medium', 0.82);
else
    targets.timely = paramsafe(params, 'step64_timely_target_normal', 0.62);
    targets.success = paramsafe(params, 'step64_success_target_normal', 0.70);
end

targets.protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
end

function value = compute_emergency_value_local(urgency, timely_prob, params)
emg_thr = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency < emg_thr
    value = 0.0;
else
    value = urgency * timely_prob;
end
end

function penalty = compute_aoi_penalty_local(context, timely_prob, params)
if isfield(context, 'aoi_age')
    age = context.aoi_age;
else
    age = 0.0;
end
cap = paramsafe(params, 'step64_aoi_age_norm_cap', paramsafe(params, 'aoi_age_norm_cap', 8.0));
age_norm = min(max(age / max(cap, 1.0e-6), 0.0), 1.0);
penalty = age_norm * max(1.0 - timely_prob, 0.0);
end

function actual_tx_cost = compute_actual_tx_cost_local(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
actual_tx_cost = mode_cost * action.tx_rate;
end

function value = paramsafe(params, name, default)
if isfield(params, name)
    value = params.(name);
else
    value = default;
end
end
