function feasible = is_action_feasible(action, urgency, q_link, q_pos, relay_available, params, event_state, options)
%IS_ACTION_FEASIBLE Hard constraints for finite-action scheduling.

feasible = true;

if nargin < 7 || isempty(event_state)
    event_state = local_get_default_event_state();
end
if nargin < 8 || isempty(options)
    options = struct();
end
bypass_blind_protection = isfield(options, 'bypass_blind_protection') ...
    && options.bypass_blind_protection;

if action.mode == 2 && relay_available < 0.5
    feasible = false;
    return;
end

if action.rate_multiplier + 1.0e-9 < params.priority_rate_scale(action.priority)
    feasible = false;
    return;
end

if urgency >= 0.80 && action.priority < params.utility_min_priority_when_emergency
    feasible = false;
    return;
end

if q_link < params.link_bad_threshold && q_pos < params.pos_low_threshold ...
        && action.priority < params.utility_min_priority_when_high_risk
    feasible = false;
    return;
end

if urgency < 0.5 && action.rate_multiplier > 2.1 && q_link < params.link_good_threshold
    feasible = false;
    return;
end

if urgency < 0.5 && action.priority > 2
    feasible = false;
    return;
end

required_protection = compute_required_protection_level( ...
    urgency, q_link, q_pos, event_state, params);
action_protection = compute_action_protection_level(action, params);
if action_protection + 1.0e-9 < required_protection
    feasible = false;
    return;
end

blind_zone_est = max(0.0, 0.45 * urgency + 0.30 * (1.0 - q_link) + 0.25 * (1.0 - q_pos));
if blind_zone_est < params.utility_low_risk_guard_threshold ...
        && blind_zone_est < params.utility_low_risk_blind_threshold
    if action.mode == 2
        feasible = false;
        return;
    end
    if action.rate_multiplier > params.baseline_rate_multiplier_by_priority(action.priority) + 1.0e-9
        feasible = false;
        return;
    end
end

if ~bypass_blind_protection ...
        && blind_zone_est >= params.utility_blind_protection_threshold ...
        && q_pos <= params.utility_blind_pos_threshold
    if action.priority < params.utility_blind_min_priority
        feasible = false;
        return;
    end
    if blind_zone_est < params.utility_blind_relay_threshold && action.mode == 2
        feasible = false;
        return;
    end
    if blind_zone_est >= params.utility_blind_relay_threshold && action.mode < params.utility_blind_force_mode
        feasible = false;
        return;
    end
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
