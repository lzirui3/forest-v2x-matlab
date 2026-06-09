function pred_delay = predict_action_delay(q_link, action, base_rate, params)
%PREDICT_ACTION_DELAY Predict effective delay for a candidate action.

mode_delay_penalty = 0.0;
if action.mode == 1
    mode_delay_penalty = params.redundant_delay_penalty;
elseif action.mode == 2
    mode_delay_penalty = params.relay_delay_penalty;
end

base_delay = params.base_delay + params.link_delay_scale * (1.0 - q_link) + mode_delay_penalty;
pred_delay = base_delay / max(action.tx_rate, 0.2);

if action.tx_rate > base_rate
    pred_delay = pred_delay / (1.0 + 0.04 * (action.rate_multiplier - 1.0));
end
end
