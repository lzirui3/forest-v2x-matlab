function result = run_step9_baseline_position_only_opt(scenario, params)
%RUN_STEP9_BASELINE_POSITION_ONLY_OPT 效用优化的定位感知基线方法。
%   使用与 Confidence-driven 相同的 45 动作效用优化框架，但仅感知定位
%   置信度 q_pos，链路质量固定为中性值 q_link=0.5，event_state 全部
%   置零。此设计确保对比公平：相同的优化能力，不同的信息输入。

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

% 固定中性链路质量——定位感知方法不感知链路
q_link_neutral = 0.50;

for k = 1:N
    % 中性 event_state：不使用盲区检测等辅助模块
    event_state.blind_zone_gate = 0.0;
    event_state.rsu_gain_gate = 0.0;
    event_state.env_correction_gate = 0.0;
    event_state.use_gnss = false;
    event_state.use_rsu = false;
    event_state.use_env = false;
    event_state.use_traj = false;

    % 构建 context（仍传递物理信道信息——但优化器看不到 q_link）
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);

    % 使用相同的效用优化框架，但 q_link 固定为中性值
    action = decide_schedule_action( ...
        scenario.urgency(k), ...
        q_link_neutral, ...        % 链路质量固定为中性
        scenario.q_pos(k), ...     % 可感知定位置信度
        scenario.relay_available(k), ...
        scenario.base_rate(k), ...
        params, ...
        event_state, ...
        context);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Position-aware-Opt";
result.policy = policy;
result.delivery = delivery;
end