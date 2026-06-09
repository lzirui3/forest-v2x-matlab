function out = simulate_step9_delivery_physical(scenario, policy, params)
%SIMULATE_STEP9_DELIVERY_PHYSICAL Physical-layer delivery model.
%   Packet delivery is a Bernoulli trial with probability derived from
%   instantaneous SINR through calibrated PER curves (WiLabV2Xsim).
%
%   Physical mechanisms:
%     1. Priority/emergency -> SINR gain (resource advantage)
%     2. Per-attempt fast fading -> instantaneous SINR
%     3. SINR -> PDR via sigmoid PER curve approximation
%     4. Mode diversity: redundant (HARQ blind retx), relay (spatial)
%     5. rate_multiplier -> n_attempts (time diversity, early stopping)
%     6. Delivery = Bernoulli(pdr_effective)
%
%   Delay model:
%     delay = base_access + congestion + mode_overhead + attempt_gaps + jitter

N = numel(scenario.t);
delivered = false(N, 1);
deadline_hit = false(N, 1);
delay_real = zeros(N, 1);
tx_cost = zeros(N, 1);
shared_draws = [];
if isfield(scenario, 'random_draws')
    shared_draws = scenario.random_draws;
end

for k = 1:N
    %% ---- Step 1: Priority SINR gain ----
    sinr_gain = params.priority_sinr_gain * (policy.priority(k) - 1);
    if scenario.msg_type(k) == "emergency"
        sinr_gain = sinr_gain + params.emergency_sinr_bonus;
    end
    sinr_base = scenario.sinr_dB(k) + sinr_gain;

    %% ---- Step 2: Determine number of attempts ----
    rate_mult = policy.tx_rate(k) / max(scenario.base_rate(k), 0.1);
    n_attempts = max(1, ceil(rate_mult));

    %% ---- Step 3: Fast fading parameters ----
    % 注意：sinr_base 已包含大尺度阴影衰落（来自 link generator 的 shadowing_dB）
    % 此处叠加的快衰落是物理上独立的小尺度效应（per-packet Rayleigh/Rician）
    % 两者正交：shadow fading 时间尺度 ~秒级，fast fading ~毫秒级（每包独立）
    if scenario.is_nlos(k)
        sigma_ff = params.fast_fading_sigma_nlos;
    else
        sigma_ff = params.fast_fading_sigma_los;
    end
    is_nlos_k = scenario.is_nlos(k);

    %% ---- Step 4: Multi-attempt delivery (early stopping) ----
    pkt_delivered = false;
    attempts_used = 0;

    for attempt = 1:n_attempts
        attempts_used = attempt;

        % Per-attempt fast fading
        if params.enable_fast_fading
            if ~isempty(shared_draws)
                ff_dB = shared_draws.fast_fading_primary(k, attempt) * sigma_ff;
            else
                ff_dB = randn() * sigma_ff;
            end
        else
            ff_dB = 0.0;
        end
        sinr_inst = sinr_base + ff_dB;

        % SINR -> PDR (physical PER curve)
        pdr_single = sinr_to_pdr_physical(sinr_inst, is_nlos_k, params);

        % Mode diversity
        if policy.mode(k) == 0
            % Direct: single transmission
            pdr_attempt = pdr_single;

        elseif policy.mode(k) == 1
            % Redundant: HARQ blind retransmission (2 independent copies)
            if params.enable_fast_fading
                if ~isempty(shared_draws)
                    ff2_dB = shared_draws.fast_fading_secondary(k, attempt) * sigma_ff;
                else
                    ff2_dB = randn() * sigma_ff;
                end
            else
                ff2_dB = 0.0;
            end
            pdr_copy2 = sinr_to_pdr_physical(sinr_base + ff2_dB, is_nlos_k, params);
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_copy2);

        elseif policy.mode(k) == 2
            % Relay: 空间分集（独立信道路径）
            % 物理模型：Source->Relay->Dest 两跳独立信道
            % 中继节点通常距离更近，且可能有 LOS 路径（即使直通链路是 NLOS）

            % 第一跳 SINR：Source -> Relay（中继距离更近，有 SINR 增益）
            relay_sinr_offset = paramsafe(params, 'relay_sinr_offset_dB', 2.5);
            sinr_hop1 = sinr_base + relay_sinr_offset;

            % 中继链路的 NLOS 状态：直通 NLOS 时中继可能恢复 LOS
            relay_nlos_to_los_prob = paramsafe(params, 'relay_nlos_to_los_prob', 0.35);
            if ~isempty(shared_draws) && isfield(shared_draws, 'relay_los_uniform')
                relay_los_u = shared_draws.relay_los_uniform(k, attempt);
            else
                relay_los_u = rand();
            end
            if is_nlos_k && relay_los_u < relay_nlos_to_los_prob
                is_nlos_relay = false;  % 中继路径恢复 LOS
            else
                is_nlos_relay = is_nlos_k;
            end

            % 第一跳独立快衰落
            if params.enable_fast_fading
                if ~isempty(shared_draws) && isfield(shared_draws, 'fast_fading_relay_hop1')
                    relay_hop1_z = shared_draws.fast_fading_relay_hop1(k, attempt);
                else
                    relay_hop1_z = randn();
                end
                if is_nlos_relay
                    ff_relay1_dB = relay_hop1_z * params.fast_fading_sigma_nlos;
                else
                    ff_relay1_dB = relay_hop1_z * params.fast_fading_sigma_los;
                end
            else
                ff_relay1_dB = 0.0;
            end
            pdr_hop1 = sinr_to_pdr_physical(sinr_hop1 + ff_relay1_dB, is_nlos_relay, params);

            % 第二跳 SINR：Relay -> Dest（独立信道）
            relay_hop2_sinr_offset = paramsafe(params, 'relay_hop2_sinr_offset_dB', 1.5);
            sinr_hop2 = sinr_base + relay_hop2_sinr_offset;

            if params.enable_fast_fading
                if ~isempty(shared_draws) && isfield(shared_draws, 'fast_fading_relay_hop2')
                    relay_hop2_z = shared_draws.fast_fading_relay_hop2(k, attempt);
                else
                    relay_hop2_z = randn();
                end
                if is_nlos_relay
                    ff_relay2_dB = relay_hop2_z * params.fast_fading_sigma_nlos;
                else
                    ff_relay2_dB = relay_hop2_z * params.fast_fading_sigma_los;
                end
            else
                ff_relay2_dB = 0.0;
            end
            pdr_hop2 = sinr_to_pdr_physical(sinr_hop2 + ff_relay2_dB, is_nlos_relay, params);

            % 中继链 PDR = P(第一跳成功) × P(第二跳成功)
            pdr_relay_chain = pdr_hop1 * pdr_hop2;

            % 联合：直通 + 中继（独立路径）
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay_chain);

        else
            pdr_attempt = pdr_single;
        end

        % Bernoulli trial
        if ~isempty(shared_draws)
            success_u = shared_draws.success_uniform(k, attempt);
        else
            success_u = rand();
        end
        if success_u < pdr_attempt
            pkt_delivered = true;
            break;
        end
    end

    delivered(k) = pkt_delivered;

    %% ---- Step 5: Delay model ----
    % Congestion based on raw channel quality (without priority gain)
    pdr_raw = sinr_to_pdr_physical(scenario.sinr_dB(k), is_nlos_k, params);
    congestion = params.congestion_delay_max * (1.0 - pdr_raw);

    % Mode overhead
    mode_overhead = 0.0;
    if policy.mode(k) == 1
        mode_overhead = params.mode_overhead_redundant;
    elseif policy.mode(k) == 2
        mode_overhead = params.mode_overhead_relay;
    end

    % Extra delay from additional attempts
    extra_attempt_delay = params.attempt_gap * max(attempts_used - 1, 0);

    % Nominal delay
    nominal_delay = params.base_access_delay + congestion ...
        + mode_overhead + extra_attempt_delay;

    % Jitter
    if params.enable_fast_fading
        if ~isempty(shared_draws)
            jitter = shared_draws.delay_jitter(k) * params.delay_jitter_scale * nominal_delay;
        else
            jitter = randn() * params.delay_jitter_scale * nominal_delay;
        end
        delay_real(k) = max(nominal_delay + jitter, 0.002);
    else
        delay_real(k) = nominal_delay;
    end

    %% ---- Step 6: Deadline check ----
    deadline_hit(k) = delivered(k) && (delay_real(k) <= scenario.deadline(k));

    %% ---- Step 7: Transmission cost ----
    % 与抽象模型保持一致：tx_cost = mode_cost * tx_rate（绝对速率）
    % 而非 mode_cost * rate_mult（相对倍率），确保跨模型可比性
    if policy.mode(k) == 0
        mode_cost = params.tx_cost_direct;
    elseif policy.mode(k) == 1
        mode_cost = params.tx_cost_redundant;
    else
        mode_cost = params.tx_cost_relay;
    end
    tx_cost(k) = mode_cost * policy.tx_rate(k);
end

out.delivered = delivered;
out.deadline_hit = deadline_hit;
out.delay = delay_real;
out.tx_cost = tx_cost;
end

function v = paramsafe(params, name, default)
%PARAMSAFE 安全读取参数，不存在时返回默认值。
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
