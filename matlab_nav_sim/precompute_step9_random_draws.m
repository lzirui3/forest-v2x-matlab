function random_draws = precompute_step9_random_draws(params, N)
%PRECOMPUTE_STEP9_RANDOM_DRAWS Precompute stochastic draws shared by all methods.

if isfield(params, 'action_rate_multiplier_set') && ~isempty(params.action_rate_multiplier_set)
    max_attempts = max(1, ceil(max(params.action_rate_multiplier_set)));
else
    max_attempts = 3;
end

random_draws.abstract_fading = randn(N, 1);
random_draws.abstract_delay_jitter = randn(N, 1);

random_draws.fast_fading_primary = randn(N, max_attempts);
random_draws.fast_fading_secondary = randn(N, max_attempts);
random_draws.relay_los_uniform = rand(N, max_attempts);
random_draws.fast_fading_relay_hop1 = randn(N, max_attempts);
random_draws.fast_fading_relay_hop2 = randn(N, max_attempts);
random_draws.success_uniform = rand(N, max_attempts);
random_draws.delay_jitter = randn(N, 1);
end
