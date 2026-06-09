function T_corr = compute_step12_correlation_diagnostic(num_seeds, params_override)
%COMPUTE_STEP12_CORRELATION_DIAGNOSTIC 诊断 q_link 与 q_pos 的 Pearson 相关性。
%   在多种子条件下计算 q_link 和 q_pos 的时序相关系数，
%   验证两者具有足够的独立性以支持"联合感知优于单一感知"的论断。
%
%   输出：
%   T_corr - 包含每种子相关系数和整体统计的表格
%
%   审稿人关注点：如果 corr(q_link, q_pos) > 0.85，则联合感知的增益
%   可能仅源自冗余信息，而非真正的互补性。目标：0.3 ~ 0.7 为合理区间。

if nargin < 1 || isempty(num_seeds)
    num_seeds = 30;
end
if nargin < 2
    params_override = struct();
end

correlations = zeros(num_seeds, 1);
corr_gnss_link = zeros(num_seeds, 1);
corr_env_link = zeros(num_seeds, 1);
corr_rsu_link = zeros(num_seeds, 1);
corr_traj_link = zeros(num_seeds, 1);

for seed = 1:num_seeds
    params = get_default_step9_mainline_params();
    params.random_seed = seed;

    % 应用参数覆盖（用于测试不同独立噪声强度）
    fnames = fieldnames(params_override);
    for f = 1:numel(fnames)
        params.(fnames{f}) = params_override.(fnames{f});
    end

    modules = get_default_position_module_config();
    scenario = generate_step9_scenario(params, modules);

    % 整体相关性
    correlations(seed) = corr(scenario.q_link, scenario.q_pos);

    % 子模块与 q_link 的相关性分解
    corr_gnss_link(seed) = corr(scenario.q_link, scenario.gnss_score);
    corr_env_link(seed) = corr(scenario.q_link, scenario.env_score);
    corr_rsu_link(seed) = corr(scenario.q_link, scenario.rsu_support_score);
    corr_traj_link(seed) = corr(scenario.q_link, scenario.traj_score);
end

% 构建汇总表
Seed = (1:num_seeds)';
Corr_qlink_qpos = correlations;
Corr_gnss_qlink = corr_gnss_link;
Corr_env_qlink = corr_env_link;
Corr_rsu_qlink = corr_rsu_link;
Corr_traj_qlink = corr_traj_link;

T_corr = table(Seed, Corr_qlink_qpos, Corr_gnss_qlink, Corr_env_qlink, ...
    Corr_rsu_qlink, Corr_traj_qlink);

% 打印汇总
fprintf('\n===== q_link / q_pos 相关性诊断 (n=%d seeds) =====\n', num_seeds);
fprintf('  corr(q_link, q_pos):    均值=%.3f, 标准差=%.3f, 范围=[%.3f, %.3f]\n', ...
    mean(correlations), std(correlations), min(correlations), max(correlations));
fprintf('  corr(q_link, gnss):     均值=%.3f\n', mean(corr_gnss_link));
fprintf('  corr(q_link, env):      均值=%.3f\n', mean(corr_env_link));
fprintf('  corr(q_link, rsu):      均值=%.3f\n', mean(corr_rsu_link));
fprintf('  corr(q_link, traj):     均值=%.3f\n', mean(corr_traj_link));

% 评判
mean_corr = mean(correlations);
if mean_corr > 0.85
    fprintf('  [警告] 相关性过高 (%.3f > 0.85)：联合感知增益可能源自冗余\n', mean_corr);
elseif mean_corr > 0.70
    fprintf('  [注意] 相关性中等偏高 (%.3f)：建议增加独立噪声源\n', mean_corr);
elseif mean_corr < 0.20
    fprintf('  [注意] 相关性过低 (%.3f < 0.20)：两指标几乎独立，检查物理合理性\n', mean_corr);
else
    fprintf('  [合理] 相关性在期望范围 [0.20, 0.70] 内\n');
end

fprintf('\n  物理解释：\n');
fprintf('    - GNSS 子模块独立性最高（星座几何与无线电链路无关）\n');
fprintf('    - 环境感知子模块共享 NLOS/阴影信息（预期相关性较高）\n');
fprintf('    - RSU 支持受遮挡影响（预期中等相关性）\n');
fprintf('    - 轨迹一致性主要独立于瞬时链路状态\n');
end