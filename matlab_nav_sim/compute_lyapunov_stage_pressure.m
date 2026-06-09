function pressure = compute_lyapunov_stage_pressure(urgency, q_link, q_pos, event_state, params)
%COMPUTE_LYAPUNOV_STAGE_PRESSURE State-dependent virtual arrival pressure.

required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
blind_zone_gain = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);

pressure = params.lyapunov_queue_arrival_scale * required_timely ...
    + params.lyapunov_violation_weight * required_protection ...
    + 0.5 * blind_zone_gain;
pressure = max(pressure, 0.0);
end
