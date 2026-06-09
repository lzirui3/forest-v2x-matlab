function protection_level = compute_action_protection_level(action, params)
%COMPUTE_ACTION_PROTECTION_LEVEL Normalized protection strength of one action.

priority_level = max(min((action.priority - 1) / 2, 1.0), 0.0);

rate_mult_set = params.action_rate_multiplier_set(:)';
rate_min = min(rate_mult_set);
rate_max = max(rate_mult_set);
if rate_max - rate_min <= 1.0e-9
    rate_level = 0.0;
else
    rate_level = (action.rate_multiplier - rate_min) / (rate_max - rate_min);
end
rate_level = max(min(rate_level, 1.0), 0.0);

if action.mode == 2
    mode_level = params.utility_mode_level_relay;
elseif action.mode == 1
    mode_level = params.utility_mode_level_redundant;
else
    mode_level = params.utility_mode_level_direct;
end

protection_level = params.utility_protection_priority_weight * priority_level ...
    + params.utility_protection_rate_weight * rate_level ...
    + params.utility_protection_mode_weight * mode_level;
protection_level = max(min(protection_level, 1.0), 0.0);
end
