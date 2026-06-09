function action = decide_schedule_action(urgency, q_link, q_pos, relay_available, base_rate, params, event_state, context)
%DECIDE_SCHEDULE_ACTION Constrained action selection with heuristic fallback.

if nargin < 7 || isempty(event_state)
    event_state = get_default_event_state();
end
if nargin < 8 || isempty(context)
    context = struct();
end

actions = enumerate_schedule_actions(relay_available, base_rate, params);
required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
blind_score = compute_blind_score(urgency, q_link, q_pos, event_state);

best_fallback = struct('idx', 1, 'score', -inf);
best_relaxed = struct('idx', 1, 'score', -inf, 'violation', inf);
cache = repmat(struct('utility', NaN, 'aux', struct()), numel(actions), 1);
fallback_scores = -inf(numel(actions), 1);
hard_feasible_mask = false(numel(actions), 1);
high_pdr_bypass = false;

for i = 1:numel(actions)
    [heuristic_score, aux_for_score] = compute_action_utility( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    cache(i).utility = heuristic_score;
    cache(i).aux = aux_for_score;

    if i == 1
        high_pdr_bypass = should_bypass_protection(aux_for_score, blind_score, params);
    end

    regime_bias = compute_regime_bias(actions(i), urgency, q_link, q_pos, event_state, params, high_pdr_bypass);
    fallback_score = heuristic_score + regime_bias ...
        - params.utility_constraint_penalty * max(required_timely - aux_for_score.timely_prob, 0.0);
    fallback_scores(i) = fallback_score;

    violation = compute_action_violation_score( ...
        actions(i), urgency, q_link, q_pos, relay_available, params, event_state, required_timely, aux_for_score);
    if violation < best_relaxed.violation - 1.0e-9 ...
            || (abs(violation - best_relaxed.violation) <= 1.0e-9 && fallback_score > best_relaxed.score)
        best_relaxed.idx = i;
        best_relaxed.score = fallback_score;
        best_relaxed.violation = violation;
    end

    feasible_options = struct('bypass_blind_protection', high_pdr_bypass);
    if ~is_action_feasible(actions(i), urgency, q_link, q_pos, relay_available, params, event_state, feasible_options)
        continue;
    end
    if ~passes_deadline_guard(actions(i), aux_for_score, urgency, params)
        continue;
    end

    hard_feasible_mask(i) = true;
    if fallback_score > best_fallback.score
        best_fallback.idx = i;
        best_fallback.score = fallback_score;
    end
end

[chosen_idx, chosen_score, ~, feasible_found] = ...
    select_min_cost_feasible_action(actions, cache, fallback_scores, required_timely, hard_feasible_mask);

if feasible_found
    % keep constrained-feasible choice
elseif isfinite(best_fallback.score)
    chosen_idx = best_fallback.idx;
    chosen_score = best_fallback.score;
else
    chosen_idx = best_relaxed.idx;
    chosen_score = best_relaxed.score;
end

chosen_action = actions(chosen_idx);
chosen_aux = cache(chosen_idx).aux;

action = chosen_action;
action.score = chosen_score;
action.utility = cache(chosen_idx).utility;
action.timely_prob = chosen_aux.timely_prob;
action.success_prob = chosen_aux.success_prob;
action.pred_delay = chosen_aux.pred_delay;
action.pred_tx_cost = chosen_aux.tx_cost;
action.risk_penalty = chosen_aux.risk_penalty;
action.event_gain = chosen_aux.event_gain;
action.required_timely = required_timely;
action.feasible_by_constraint = hard_feasible_mask(chosen_idx) ...
    && chosen_aux.timely_prob >= required_timely;
end

function event_state = get_default_event_state()
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
end

function regime_bias = compute_regime_bias(action, urgency, q_link, q_pos, event_state, params, high_pdr_bypass)
if nargin < 7
    high_pdr_bypass = false;
end
regime_bias = 0.0;
blind_score = compute_blind_score(urgency, q_link, q_pos, event_state);

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

function blind_score = compute_blind_score(urgency, q_link, q_pos, event_state)
blind_score = max(event_state.blind_zone_gate, ...
    0.45 * urgency + 0.30 * (1.0 - q_link) + 0.25 * (1.0 - q_pos));
end

function bypass = should_bypass_protection(aux, blind_score, params)
if ~paramsafe(params, 'enable_p5_guard_public_selector', false)
    bypass = false;
    return;
end
threshold = paramsafe(params, 'regime_pdr_bypass_threshold', inf);
min_blind = paramsafe(params, 'regime_pdr_bypass_min_blind_score', 0.0);
bypass = isfield(aux, 'success_prob') ...
    && aux.success_prob >= threshold ...
    && blind_score >= min_blind;
end

function pass = passes_deadline_guard(action, aux, urgency, params)
if ~paramsafe(params, 'enable_p5_guard_public_selector', false)
    pass = true;
    return;
end
guard_min_urgency = paramsafe(params, 'deadline_guard_min_urgency', inf);
if urgency < guard_min_urgency || action.mode == 0
    pass = true;
    return;
end
if ~isfield(aux, 'pred_delay') || ~isfield(aux, 'deadline') || isnan(aux.pred_delay) || isnan(aux.deadline)
    pass = true;
    return;
end
guard_ratio = paramsafe(params, 'deadline_guard_ratio', 1.0);
pass = aux.pred_delay <= aux.deadline * guard_ratio + 1.0e-9;
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
