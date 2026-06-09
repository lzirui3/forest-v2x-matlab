function aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%EVALUATE_ACTION_METRICS Evaluate action metrics independent of selection rule.

if nargin < 9 || isempty(context)
    context = struct();
end

deadline = infer_deadline_from_urgency(urgency, params);
protection_level = compute_action_protection_level(action, params);
emg_thresh = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
action.is_emergency = urgency >= emg_thresh;

if isfield(params, 'use_physical_delivery') && params.use_physical_delivery ...
        && isfield(context, 'sinr_dB') && isfield(context, 'is_nlos')
    pred_delay = predict_action_delay_physical(context.sinr_dB, context.is_nlos, action, params);
    delivery_prob = predict_action_pdr_physical(context.sinr_dB, context.is_nlos, action, params);
    timely_prob = predict_mixture_timely_prob(context.sinr_dB, context.is_nlos, action, deadline, params);
    success_prob = delivery_prob;
    gate_threshold = NaN;
else
    pred_delay = predict_action_delay(q_link, action, base_rate, params);
    success_prob = predict_action_success(urgency, q_link, q_pos, action, params);
    gate_threshold = predict_action_gate_threshold(urgency, q_link, q_pos, action, params);

    sigmoid_scale = params.utility_sigmoid_scale;
    deadline_term = 1.0 / (1.0 + exp((pred_delay - deadline) / max(sigmoid_scale, 1.0e-4)));
    delivery_prob = 1.0 / (1.0 + exp(-(success_prob - gate_threshold) / max(params.utility_margin_sigmoid_scale, 1.0e-4)));
    timely_prob = delivery_prob * deadline_term;
end

tx_cost = infer_tx_cost(action, params);
blind_zone_gain = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);
support_gain = max(event_state.rsu_gain_gate - params.rsu_event_trigger_threshold, 0.0) ...
    + max(event_state.env_correction_gate - params.env_event_trigger_threshold, 0.0);

synergy_gain = 0.0;
if event_state.use_gnss && event_state.use_rsu && event_state.use_env && event_state.use_traj
    synergy_gain = event_state.rsu_gain_gate * event_state.env_correction_gate;
end

module_support_bonus = 0.0;
if event_state.use_rsu
    module_support_bonus = module_support_bonus + params.utility_module_support_weight_rsu * event_state.rsu_gain_gate;
end
if event_state.use_env
    module_support_bonus = module_support_bonus + params.utility_module_support_weight_env * event_state.env_correction_gate;
end
if event_state.use_traj
    module_support_bonus = module_support_bonus + params.utility_module_support_weight_traj * blind_zone_gain;
end

event_active = blind_zone_gain >= params.utility_event_activation_threshold;
if event_active
    event_gain = params.utility_weight_event * urgency * blind_zone_gain * protection_level ...
        * (params.utility_event_base_gain + module_support_bonus + params.event_rate_scale_gain * support_gain ...
        + params.event_synergy_gain * synergy_gain);
else
    event_gain = 0.0;
end

position_risk = max((1.0 - q_pos) - params.utility_position_activation_threshold, 0.0) ...
    * (1.0 - protection_level) ...
    * (params.utility_position_risk_base + params.utility_position_risk_urgency_scale * urgency ...
    + params.utility_risk_tradeoff_scale * blind_zone_gain);

mis_qpos = max(params.utility_misdecision_qpos_threshold - q_pos, 0.0);
mis_blind = max(blind_zone_gain - params.utility_misdecision_blind_threshold, 0.0);
insufficient_protection = max(params.utility_misdecision_target_protection - protection_level, 0.0);
misdecision_risk = (params.utility_misdecision_blind_scale * mis_blind ...
    + params.utility_misdecision_urgency_scale * urgency) ...
    * mis_qpos * insufficient_protection;

delay_penalty = max(pred_delay / max(deadline, 1.0e-4) - 1.0, 0.0);

if urgency < 0.5 && q_link < params.link_bad_threshold
    tx_cost = tx_cost * (1.0 + params.utility_noncritical_suppression);
end

relay_penalty = 0.0;
if action.mode == 2 && relay_available < 0.5
    relay_penalty = 1.0;
end

support_mismatch_penalty = 0.0;
if action.mode == 2 && ~event_state.use_rsu
    support_mismatch_penalty = support_mismatch_penalty + params.utility_support_mismatch_penalty_relay;
end
redund_blind_thr = paramsafe(params, 'utility_redundant_blind_threshold', 0.10);
redund_qpos_thr = paramsafe(params, 'utility_redundant_qpos_threshold', 0.65);
if action.mode == 1 && blind_zone_gain < redund_blind_thr && q_pos > redund_qpos_thr
    support_mismatch_penalty = support_mismatch_penalty + params.utility_support_mismatch_penalty_redundant;
end

aux.timely_prob = timely_prob;
aux.success_prob = delivery_prob;
aux.raw_success_prob = success_prob;
aux.pred_delay = pred_delay;
aux.tx_cost = tx_cost;
aux.risk_penalty = position_risk;
aux.event_gain = event_gain;
aux.deadline = deadline;
aux.protection_level = protection_level;
aux.delay_penalty = delay_penalty;
aux.relay_penalty = relay_penalty;
aux.support_mismatch_penalty = support_mismatch_penalty;
aux.gate_threshold = gate_threshold;
aux.misdecision_risk = misdecision_risk;
end

function deadline = infer_deadline_from_urgency(urgency, params)
emg_thr = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thr
    deadline = params.deadline_emergency;
elseif urgency >= 0.50
    deadline = params.deadline_coop;
else
    deadline = params.deadline_normal;
end
end

function tx_cost = infer_tx_cost(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
tx_cost = mode_cost * action.rate_multiplier;
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
