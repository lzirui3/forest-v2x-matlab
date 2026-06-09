function actions = enumerate_schedule_actions(relay_available, base_rate, params)
%ENUMERATE_SCHEDULE_ACTIONS Enumerate a finite action set for utility-based scheduling.

priority_set = params.action_priority_set(:)';
mode_set = params.action_mode_set(:)';
rate_mult_set = params.action_rate_multiplier_set(:)';

if relay_available < 0.5
    mode_set = mode_set(mode_set ~= 2);
end

num_actions = numel(priority_set) * numel(mode_set) * numel(rate_mult_set);
actions = repmat(struct('priority', 1, 'mode', 0, 'tx_rate', base_rate, 'rate_multiplier', 1.0), num_actions, 1);

idx = 1;
for i = 1:numel(priority_set)
    for j = 1:numel(mode_set)
        for k = 1:numel(rate_mult_set)
            actions(idx).priority = priority_set(i);
            actions(idx).mode = mode_set(j);
            actions(idx).rate_multiplier = rate_mult_set(k);
            actions(idx).tx_rate = base_rate * rate_mult_set(k);
            idx = idx + 1;
        end
    end
end
end
