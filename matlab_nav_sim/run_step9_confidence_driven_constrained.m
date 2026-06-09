function result = run_step9_confidence_driven_constrained(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN_CONSTRAINED Constrained confidence-driven method.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
regime_active = false;

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);
    enter_regime = event_state.blind_zone_gate >= params.confidence_regime_blind_threshold ...
        || scenario.q_pos(k) <= params.confidence_regime_qpos_threshold;
    hold_regime = event_state.blind_zone_gate >= params.confidence_regime_hold_blind_threshold ...
        || scenario.q_pos(k) <= params.confidence_regime_hold_qpos_threshold;

    if ~regime_active
        regime_active = enter_regime;
    else
        regime_active = hold_regime;
    end

    if regime_active
        action = decide_schedule_action( ...
            scenario.urgency(k), ...
            scenario.q_link(k), ...
            scenario.q_pos(k), ...
            scenario.relay_available(k), ...
            scenario.base_rate(k), ...
            params, ...
            event_state, ...
            context);
    else
        neutral_event_state = get_neutral_event_state();
        action = decide_schedule_action( ...
            scenario.urgency(k), ...
            scenario.q_link(k), ...
            1.0, ...
            scenario.relay_available(k), ...
            scenario.base_rate(k), ...
            params, ...
            neutral_event_state, ...
            context);
    end

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Confidence-constrained";
result.policy = policy;
result.delivery = delivery;
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

function event_state = get_neutral_event_state()
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
end
