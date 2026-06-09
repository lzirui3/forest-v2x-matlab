function out = simulate_step9_delivery(scenario, policy, params)
%SIMULATE_STEP9_DELIVERY Unified delivery entry for abstract/physical models.

if nargin >= 3 && isfield(params, 'use_physical_delivery') && params.use_physical_delivery
    out = simulate_step9_delivery_physical(scenario, policy, params);
    return;
end

out = local_simulate_step9_delivery_abstract(scenario, policy, params);
end

function out = local_simulate_step9_delivery_abstract(scenario, policy, params)
N = numel(scenario.t);
delivered = false(N, 1);
deadline_hit = false(N, 1);
delay_real = zeros(N, 1);
tx_cost = zeros(N, 1);

for k = 1:N
    q_link = scenario.q_link(k);
    q_pos = scenario.q_pos(k);
    urgency = scenario.urgency(k);
    base_delay = scenario.delay(k);

    priority_bonus = params.abstract_priority_bonus_per_level * (policy.priority(k) - 1);
    if scenario.msg_type(k) == "emergency"
        priority_bonus = priority_bonus + params.critical_priority_bonus;
    end

    mode_success_bonus = 0.0;
    mode_delay_penalty = 0.0;
    mode_cost = params.tx_cost_direct;
    mode_gate_bonus = 0.0;

    if policy.mode(k) == 1
        mode_success_bonus = params.redundant_success_bonus;
        mode_delay_penalty = params.redundant_delay_penalty;
        mode_cost = params.tx_cost_redundant;
        mode_gate_bonus = params.abstract_redundant_gate_bonus;
    elseif policy.mode(k) == 2
        mode_success_bonus = params.relay_success_bonus;
        mode_delay_penalty = params.relay_delay_penalty;
        mode_cost = params.tx_cost_relay;
        mode_gate_bonus = params.mode_gate_bonus;
    end

    rate_bonus = params.abstract_rate_bonus_scale * max(policy.tx_rate(k) - scenario.base_rate(k), 0.0);

    confidence_protection = 0.0;
    if policy.mode(k) >= 1
        if (1.0 - q_pos) > 0.45 && policy.priority(k) >= 3
            confidence_protection = params.abstract_confidence_protection_high;
        elseif (1.0 - q_pos) > 0.30 && policy.priority(k) >= 2
            confidence_protection = params.abstract_confidence_protection_mid;
        end
    elseif (1.0 - q_pos) > 0.30 && policy.priority(k) >= 2
        confidence_protection = params.abstract_confidence_protection_direct;
    end

    success_prob = q_link + params.base_success_bias + priority_bonus + mode_success_bonus ...
        + rate_bonus + confidence_protection - params.position_risk_penalty * (1.0 - q_pos);

    if isfield(params, 'enable_stochastic') && params.enable_stochastic
        fading_dB = randn() * params.fading_sigma_dB;
        fading_linear = 10.0 ^ (fading_dB / 20.0);
        q_link_faded = min(max(q_link * fading_linear, 0.01), 1.0);
        success_prob = q_link_faded + params.base_success_bias + priority_bonus ...
            + mode_success_bonus + rate_bonus + confidence_protection ...
            - params.position_risk_penalty * (1.0 - q_pos);
    end

    success_prob = min(max(success_prob, 0.02), 0.995);

    deterministic_gate = params.link_gate_weight * (1.0 - q_link) ...
        + params.pos_gate_weight * (1.0 - q_pos) ...
        + params.urgency_gate_weight * urgency ...
        - mode_gate_bonus ...
        - params.priority_gate_bonus * (policy.priority(k) - 1);
    if scenario.msg_type(k) == "emergency"
        deterministic_gate = deterministic_gate - params.emergency_gate_reduction;
    end
    deterministic_gate = min(max(deterministic_gate, 0.05), 0.95);

    % 投递判定：将 success_prob vs gate 的比较转化为概率采样
    % 物理含义：即使 success_prob > gate，仍有随机失败的可能（信道瞬时波动）
    % 使用 sigmoid 将 margin 映射为投递概率，再做 Bernoulli 试验
    margin = success_prob - deterministic_gate;
    pdr_abstract = 1.0 / (1.0 + exp(-margin / max(params.utility_margin_sigmoid_scale, 1.0e-4)));
    pdr_abstract = min(max(pdr_abstract, 0.02), 0.995);
    delivered(k) = rand() < pdr_abstract;

    delay_real(k) = base_delay + params.link_delay_scale * (1.0 - q_link) + mode_delay_penalty;

    if isfield(params, 'enable_stochastic') && params.enable_stochastic
        jitter = randn() * params.delay_jitter_scale * delay_real(k);
        delay_real(k) = max(delay_real(k) + jitter, 0.001);
    end

    delay_real(k) = delay_real(k) / max(policy.tx_rate(k), 0.2);

    deadline_hit(k) = delivered(k) && (delay_real(k) <= scenario.deadline(k));
    tx_cost(k) = mode_cost * policy.tx_rate(k);
end

out.delivered = delivered;
out.deadline_hit = deadline_hit;
out.delay = delay_real;
out.tx_cost = tx_cost;
end
