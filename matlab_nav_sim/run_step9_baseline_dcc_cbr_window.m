function result = run_step9_baseline_dcc_cbr_window(scenario, params)
%RUN_STEP9_BASELINE_DCC_CBR_WINDOW CBR-window congestion-control baseline.
% This is a DCC-inspired baseline, not a full ETSI DCC stack. It estimates
% recent channel occupancy from scheduled load and link congestion proxy.

N = numel(scenario.t);
priority = ones(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
busy_trace = zeros(N, 1);

window_s = paramsafe_local(params, 'dcc_cbr_window_s', 1.0);
load_scale = paramsafe_local(params, 'dcc_cbr_load_scale', 0.28);
link_scale = paramsafe_local(params, 'dcc_cbr_link_scale', 0.42);
emergency_relief = paramsafe_local(params, 'dcc_cbr_emergency_relief', 0.12);

for k = 1:N
    priority(k) = infer_priority_local(scenario.msg_type(k), params);

    window_idx = scenario.t >= scenario.t(k) - window_s & scenario.t <= scenario.t(k);
    if any(window_idx)
        recent_busy = mean(busy_trace(window_idx));
    else
        recent_busy = 0.0;
    end

    link_busy = min(max(1.0 - scenario.q_link(k), 0.0), 1.0);
    cbr = min(max(0.55 * recent_busy + link_scale * link_busy, 0.0), 1.0);
    score(k) = cbr;

    if cbr <= params.dcc_cbr_low_threshold
        rate_mult = params.dcc_rate_multiplier_high;
    elseif cbr <= params.dcc_cbr_high_threshold
        rate_mult = params.dcc_rate_multiplier_mid;
    else
        rate_mult = params.dcc_rate_multiplier_low;
    end

    % Emergency messages keep priority but still obey congestion state.
    if priority(k) >= params.dcc_emergency_priority
        rate_mult = max(rate_mult, params.dcc_rate_multiplier_mid);
        cbr = max(cbr - emergency_relief, 0.0);
    end

    tx_rate(k) = scenario.base_rate(k) * rate_mult;

    if priority(k) >= params.dcc_emergency_priority
        mode(k) = 1;
    elseif scenario.relay_available(k) >= 0.5 && cbr <= params.dcc_direct_mode_threshold
        mode(k) = 2;
    else
        mode(k) = 0;
    end

    mode_load = 1.0 + 0.35 * (mode(k) == 1) + 0.55 * (mode(k) == 2);
    busy_trace(k) = min(max(load_scale * tx_rate(k) * mode_load + link_scale * link_busy, 0.0), 1.0);
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "DCC-CBR-window";
result.policy = policy;
result.delivery = delivery;
end

function priority = infer_priority_local(msg_type, params)
if msg_type == "emergency"
    priority = params.dcc_emergency_priority;
elseif msg_type == "coop"
    priority = params.dcc_coop_priority;
else
    priority = 1;
end
end

function v = paramsafe_local(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
