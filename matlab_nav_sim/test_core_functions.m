function test_core_functions()
%TEST_CORE_FUNCTIONS 核心函数单元测试。
%   验证关键函数的输入输出正确性、边界条件和物理一致性。
%   运行方式：在 MATLAB 命令行执行 test_core_functions()

fprintf('\n===== 核心函数单元测试 =====\n');
n_pass = 0;
n_fail = 0;

%% 测试 1: sinr_to_pdr_fast 基本行为
fprintf('\n--- sinr_to_pdr_fast ---\n');

% 单调性
pdr_low = sinr_to_pdr_fast(-5, false);
pdr_mid = sinr_to_pdr_fast(4, false);
pdr_high = sinr_to_pdr_fast(20, false);
[n_pass, n_fail] = check(pdr_low < pdr_mid, 'LOS: PDR(-5) < PDR(4)', n_pass, n_fail);
[n_pass, n_fail] = check(pdr_mid < pdr_high, 'LOS: PDR(4) < PDR(20)', n_pass, n_fail);

% midpoint 处 PDR ≈ 0.5
[n_pass, n_fail] = check(abs(pdr_mid - 0.5) < 0.05, 'LOS midpoint ≈ 0.5', n_pass, n_fail);

% NLOS PDR ≤ LOS PDR
pdr_nlos = sinr_to_pdr_fast(5, true);
pdr_los = sinr_to_pdr_fast(5, false);
[n_pass, n_fail] = check(pdr_nlos <= pdr_los, 'NLOS PDR ≤ LOS PDR at same SINR', n_pass, n_fail);

% 边界值
[n_pass, n_fail] = check(sinr_to_pdr_fast(-50, false) >= 0.01, 'PDR 下界 ≥ 0.01', n_pass, n_fail);
[n_pass, n_fail] = check(sinr_to_pdr_fast(50, false) <= 0.999, 'PDR 上界 ≤ 0.999', n_pass, n_fail);

% 向量输入
pdr_vec = sinr_to_pdr_fast([-5, 0, 5, 10, 15], false);
[n_pass, n_fail] = check(numel(pdr_vec) == 5, '向量输入返回向量', n_pass, n_fail);
[n_pass, n_fail] = check(all(diff(pdr_vec) > 0), '向量结果单调递增', n_pass, n_fail);

%% 测试 2: get_default_step9_params 完整性
fprintf('\n--- get_default_step9_params ---\n');
params = get_default_step9_params();

required_fields = {'dt', 'T_total', 'urgency_normal', 'urgency_emergency', ...
    'fast_fading_sigma_los', 'fast_fading_sigma_nlos', ...
    'utility_emergency_urgency_threshold', ...
    'utility_low_risk_weight_urgency', 'utility_low_risk_weight_link', ...
    'utility_low_risk_weight_pos', 'relay_sinr_offset_dB', ...
    'position_gnss_independent_noise_std'};
for i = 1:numel(required_fields)
    [n_pass, n_fail] = check(isfield(params, required_fields{i}), ...
        sprintf('params.%s 存在', required_fields{i}), n_pass, n_fail);
end

% 物理合理性
[n_pass, n_fail] = check(params.fast_fading_sigma_los < params.fast_fading_sigma_nlos, ...
    'LOS fast fading < NLOS fast fading', n_pass, n_fail);
[n_pass, n_fail] = check(params.deadline_emergency < params.deadline_normal, ...
    'emergency deadline < normal deadline', n_pass, n_fail);

%% 测试 3: resolve_step9_message_profile
fprintf('\n--- resolve_step9_message_profile ---\n');
t = (0:params.dt:params.T_total)';
[msg_type, urgency, base_rate, deadline, relay] = resolve_step9_message_profile(params, t, false);

[n_pass, n_fail] = check(numel(msg_type) == numel(t), '输出长度匹配', n_pass, n_fail);
[n_pass, n_fail] = check(any(msg_type == "emergency"), '包含 emergency 消息', n_pass, n_fail);
[n_pass, n_fail] = check(any(msg_type == "coop"), '包含 coop 消息', n_pass, n_fail);
[n_pass, n_fail] = check(all(urgency >= 0 & urgency <= 1), 'urgency ∈ [0,1]', n_pass, n_fail);
[n_pass, n_fail] = check(all(deadline > 0), 'deadline > 0', n_pass, n_fail);

% 随机模式下边界应有变化
rng(42);
[msg1, ~, ~, ~, ~] = resolve_step9_message_profile(params, t, true);
rng(99);
[msg2, ~, ~, ~, ~] = resolve_step9_message_profile(params, t, true);
emg_start_1 = find(msg1 == "emergency", 1);
emg_start_2 = find(msg2 == "emergency", 1);
[n_pass, n_fail] = check(emg_start_1 ~= emg_start_2, ...
    '随机模式下 emergency 起始时间不同', n_pass, n_fail);

%% 测试 4: compute_action_utility 基本行为
fprintf('\n--- compute_action_utility ---\n');
action.priority = 2;
action.mode = 0;
action.rate_multiplier = 1.0;
action.tx_rate = 1.0;
event_state.blind_zone_gate = 0.3;
event_state.rsu_gain_gate = 0.2;
event_state.env_correction_gate = 0.1;
event_state.use_gnss = true;
event_state.use_rsu = true;
event_state.use_env = true;
event_state.use_traj = true;

[u1, ~] = compute_action_utility(0.3, 0.7, 0.6, action, 0, 1.0, params, event_state, struct());
[n_pass, n_fail] = check(isfinite(u1), 'utility 有限值', n_pass, n_fail);

% 高 urgency 应产生更高 utility（同等条件）
[u2, ~] = compute_action_utility(0.9, 0.7, 0.6, action, 0, 1.0, params, event_state, struct());
[n_pass, n_fail] = check(u2 > u1, '高 urgency → 更高 utility', n_pass, n_fail);

% 高优先级应产生更高 utility
action_hi = action;
action_hi.priority = 3;
[u3, ~] = compute_action_utility(0.9, 0.7, 0.6, action_hi, 0, 1.0, params, event_state, struct());
[n_pass, n_fail] = check(u3 >= u2, '高优先级 → utility 不低于低优先级', n_pass, n_fail);

%% 汇总
fprintf('\n===== 测试结果 =====\n');
fprintf('  通过: %d\n', n_pass);
fprintf('  失败: %d\n', n_fail);
if n_fail == 0
    fprintf('  [全部通过]\n');
else
    fprintf('  [存在失败，请检查]\n');
end
end

function [n_pass, n_fail] = check(condition, name, n_pass, n_fail)
if condition
    fprintf('  [PASS] %s\n', name);
    n_pass = n_pass + 1;
else
    fprintf('  [FAIL] %s\n', name);
    n_fail = n_fail + 1;
end
end
