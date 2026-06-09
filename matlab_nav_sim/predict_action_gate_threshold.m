function gate_threshold = predict_action_gate_threshold(urgency, q_link, q_pos, action, params)
%PREDICT_ACTION_GATE_THRESHOLD Predict delivery gate threshold for a candidate action.

mode_gate_bonus = 0.0;
if action.mode == 1
    mode_gate_bonus = params.abstract_redundant_gate_bonus;
elseif action.mode == 2
    mode_gate_bonus = params.mode_gate_bonus;
end

gate_threshold = params.link_gate_weight * (1.0 - q_link) ...
    + params.pos_gate_weight * (1.0 - q_pos) ...
    + params.urgency_gate_weight * urgency ...
    - mode_gate_bonus ...
    - params.priority_gate_bonus * (action.priority - 1);

emg_thr = 0.80;
if isfield(params, 'utility_emergency_urgency_threshold')
    emg_thr = params.utility_emergency_urgency_threshold;  % bind to sweepable param (was hardcoded 0.80)
end
if urgency >= emg_thr
    gate_threshold = gate_threshold - params.emergency_gate_reduction;
end

gate_threshold = min(max(gate_threshold, 0.05), 0.95);
end
