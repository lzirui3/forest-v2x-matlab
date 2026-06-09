function violation = compute_action_violation_score( ...
    action, urgency, q_link, q_pos, relay_available, params, event_state, required_timely, aux)
%COMPUTE_ACTION_VIOLATION_SCORE Aggregate constraint violation for relaxed fallback.

if nargin < 7 || isempty(event_state)
    event_state = local_get_default_event_state();
end
if nargin < 8 || isempty(required_timely)
    required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
end
if nargin < 9 || isempty(aux)
    aux = struct();
end

violation = 0.0;

if action.mode == 2 && relay_available < 0.5
    violation = violation + 1.0;
end

violation = violation + max(params.priority_rate_scale(action.priority) - action.rate_multiplier, 0.0);

if urgency >= params.utility_emergency_urgency_threshold
    violation = violation + max(params.utility_min_priority_when_emergency - action.priority, 0.0);
end

if q_link < params.link_bad_threshold && q_pos < params.pos_low_threshold
    violation = violation + max(params.utility_min_priority_when_high_risk - action.priority, 0.0);
end

if urgency < 0.5 && q_link < params.link_good_threshold
    violation = violation + max(action.rate_multiplier - 2.1, 0.0);
end

if urgency < 0.5
    violation = violation + max(action.priority - 2, 0.0);
end

required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
if isfield(aux, 'protection_level')
    protection_level = aux.protection_level;
else
    protection_level = compute_action_protection_level(action, params);
end
violation = violation + max(required_protection - protection_level, 0.0);

blind_zone_est = max(0.0, 0.45 * urgency + 0.30 * (1.0 - q_link) + 0.25 * (1.0 - q_pos));
if blind_zone_est < params.utility_low_risk_guard_threshold ...
        && blind_zone_est < params.utility_low_risk_blind_threshold
    if action.mode == 2
        violation = violation + 0.5;
    end
    violation = violation + max( ...
        action.rate_multiplier - params.baseline_rate_multiplier_by_priority(action.priority), 0.0);
end

if blind_zone_est >= params.utility_blind_protection_threshold && q_pos <= params.utility_blind_pos_threshold
    violation = violation + max(params.utility_blind_min_priority - action.priority, 0.0);
    if blind_zone_est < params.utility_blind_relay_threshold && action.mode == 2
        violation = violation + 0.5;
    end
    if blind_zone_est >= params.utility_blind_relay_threshold
        violation = violation + max(params.utility_blind_force_mode - action.mode, 0.0);
    end
end

if isfield(aux, 'timely_prob') && ~isempty(aux.timely_prob) && ~isnan(aux.timely_prob)
    violation = violation + max(required_timely - aux.timely_prob, 0.0);
end
end

function event_state = local_get_default_event_state()
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
end
