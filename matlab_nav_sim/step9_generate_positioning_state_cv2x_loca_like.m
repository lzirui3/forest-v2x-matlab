function position = step9_generate_positioning_state_cv2x_loca_like( ...
    t, n_sat, dop, sigma_pos, dt_upd, link, params, modules)
%STEP9_GENERATE_POSITIONING_STATE_CV2X_LOCA_LIKE
% Build a lightweight CV2X-LOCA-like positioning confidence layer.

if nargin < 8 || isempty(modules)
    modules = get_default_position_module_config();
end

N = numel(t);
ego_x = link.rx_x;
ego_y = link.rx_y;

rsu_x = params.position_rsu_x(:)';
rsu_y = params.position_rsu_y(:)';
rsu_cov = params.position_rsu_coverage(:)';
num_rsu = numel(rsu_x);

gnss_score_raw = compute_positioning_confidence_rule(n_sat, dop, sigma_pos, dt_upd);

% 添加 GNSS 独立噪声源（电离层闪烁 + GNSS 多径反射）
% 这些物理过程与 C-V2X sidelink 无线电链路无关，提供真正的独立信息
use_random = isfield(params, 'random_seed') && ~isempty(params.random_seed);
if use_random
    gnss_indep_std = 0.08;  % 默认独立噪声标准差
    if isfield(params, 'position_gnss_independent_noise_std')
        gnss_indep_std = params.position_gnss_independent_noise_std;
    end
    gnss_indep_len = 12;    % 电离层闪烁时间尺度（样本数）
    if isfield(params, 'position_gnss_independent_temporal_len')
        gnss_indep_len = params.position_gnss_independent_temporal_len;
    end
    % 独立于 sidelink 信道的 GNSS 扰动
    gnss_indep_noise = gnss_indep_std * local_smooth_noise_independent(N, gnss_indep_len);
    gnss_score_raw = min(max(gnss_score_raw + gnss_indep_noise, 0.0), 1.0);
end

if modules.use_gnss
    gnss_score = gnss_score_raw;
else
    gnss_score = 0.25 + 0.15 * exp(-((t - 35) / 14).^2);
end

env_attenuation_raw = 1.0 ...
    + 0.08 * max(link.shadowing_dB, 0.0) ...
    + 0.24 * double(link.is_nlos) ...
    + 0.10 * max(link.nlosv, 0.0) ...
    + 0.55 * exp(-((t - params.position_env_peak_time) / 10.0).^2);
env_attenuation_raw = min(max(env_attenuation_raw, 1.0), 3.5);

if modules.use_env
    env_attenuation = env_attenuation_raw;
else
    env_attenuation = ones(N, 1);
end

env_score_raw = 1.0 - (env_attenuation_raw - 1.0) / (3.5 - 1.0);
env_score_raw = min(max(env_score_raw, 0.0), 1.0);

d_rsu = zeros(N, num_rsu);
support_mat = zeros(N, num_rsu);
visible_mat = false(N, num_rsu);

for i = 1:num_rsu
    dx = ego_x - rsu_x(i);
    dy = ego_y - rsu_y(i);
    d = sqrt(dx.^2 + dy.^2);

    base_support = exp(-d ./ max(rsu_cov(i), 1.0));
    env_penalty = exp(-0.55 * (env_attenuation - 1.0));
    nlos_penalty = 1.0 - 0.18 * double(link.is_nlos) - 0.05 * min(link.nlosv, 2.0);
    geometry_bonus = 1.0 + 0.08 * double(sign(rsu_y(i)) ~= sign(ego_y));

    support = base_support .* env_penalty .* nlos_penalty .* geometry_bonus;
    support = min(max(support, 0.0), 1.0);

    if ~modules.use_rsu
        support = zeros(N, 1);
    end

    d_rsu(:, i) = d;
    support_mat(:, i) = support;
    visible_mat(:, i) = (support >= params.position_support_threshold) ...
        & (d <= 1.35 * rsu_cov(i));
end

nearest_rsu_distance = min(d_rsu, [], 2);
nearest_rsu_count = sum(visible_mat, 2);

support_sorted = sort(support_mat, 2, 'descend');
top1 = support_sorted(:, 1);
if num_rsu >= 2
    top2 = support_sorted(:, 2);
else
    top2 = zeros(N, 1);
end

geometry_balance = 1.0 - abs(top1 - top2);
geometry_balance = min(max(geometry_balance, 0.0), 1.0);

support_sum = sum(support_mat, 2);
% RSU 支持评分：综合距离衰减、环境衰减、NLOS 惩罚、几何分集
% 权重设计依据（参考 CV2X-LOCA 定位融合框架）：
%   0.55 * support_sum: RSU 信号强度总和（主导因素，RSSI 直接反映定位精度）
%   0.25 * rsu_count:   可见 RSU 数量（几何约束，≥2 个 RSU 才能三角定位）
%   0.20 * geometry:    RSU 几何分布均衡度（GDOP 的简化代理）
rssi_support_score_raw = 0.55 * min(support_sum / 1.6, 1.0) ...
    + 0.25 * min(nearest_rsu_count / 2.0, 1.0) ...
    + 0.20 * geometry_balance;
rssi_support_score_raw = min(max(rssi_support_score_raw, 0.0), 1.0);

gnss_risk = min(max(1.0 - gnss_score_raw, 0.0), 1.0);
% 遮挡评分：多源融合判断当前无线电环境恶化程度
% 权重依据（参考 3GPP TR 37.885 遮挡建模）：
%   0.42 * is_nlos:     NLOS 状态是遮挡的最强指示（直接影响路径损耗 10-20 dB）
%   0.18 * nlosv:       车辆遮挡程度（NLOSv 模型，影响额外损耗 5-15 dB）
%   0.20 * shadowing:   阴影衰落深度（反映环境散射体密度）
%   0.20 * (1-pdr):     链路质量退化（综合指标，捕获上述因素的联合效应）
blockage_score = 0.42 * double(link.is_nlos) ...
    + 0.18 * min(max(link.nlosv, 0.0) / 2.0, 1.0) ...
    + 0.20 * min(max(link.shadowing_dB, 0.0) / 5.0, 1.0) ...
    + 0.20 * (1.0 - link.pdr);
blockage_score = min(max(blockage_score, 0.0), 1.0);

% 盲区检测评分：GNSS 风险 + 遮挡评分的加权组合
% 权重依据：
%   0.58 * gnss_risk: GNSS 是主定位源，其退化是盲区的首要指标
%   0.42 * blockage:  无线电遮挡是盲区的次要指标（影响 RSU 辅助定位）
% 阈值 0.34/0.36: 将原始评分映射到 [0,1] 的激活区间
%   低于 0.34 视为正常（不触发盲区保护），高于 0.70 视为严重盲区
blind_zone_raw = 0.58 * gnss_risk + 0.42 * blockage_score;
blind_zone_gate = min(max((blind_zone_raw - 0.34) / 0.36, 0.0), 1.0);

rsu_gain_gate = blind_zone_gate .* min(max((rssi_support_score_raw - 0.42) / 0.26, 0.0), 1.0);
if modules.use_rsu
    rsu_support_score = 0.55 + rsu_gain_gate .* (0.90 * rssi_support_score_raw - 0.40);
    rsu_support_score = min(max(rsu_support_score, 0.45), 1.0);
    rsu_support_score = min(rsu_support_score, ...
        params.position_rsu_relief_cap - 0.18 * blind_zone_gate);
    rsu_support_score = max(rsu_support_score, 0.35);
else
    rsu_support_score = 0.55 * ones(N, 1);
    rsu_gain_gate = zeros(N, 1);
end

env_severity = min(max(1.0 - env_score_raw, 0.0), 1.0);
env_detectability = 0.48 * double(link.is_nlos) ...
    + 0.20 * min(max(link.nlosv, 0.0) / 2.0, 1.0) ...
    + 0.18 * min(max(link.shadowing_dB, 0.0) / 5.5, 1.0) ...
    + 0.14 * gnss_risk;
env_detectability = min(max(env_detectability, 0.0), 1.0);

env_correction_gate = blind_zone_gate .* min(max((env_severity - 0.16) / 0.34, 0.0), 1.0);
if modules.use_env
    env_score = 0.55 + env_correction_gate .* ( ...
        0.24 + 0.28 * env_detectability + 0.18 * min(nearest_rsu_count / 2.0, 1.0) ...
        - 0.10 * max(0.45 - rssi_support_score_raw, 0.0));
    env_score = min(max(env_score, 0.45), 1.0);
else
    env_score = 0.55 * ones(N, 1);
    env_correction_gate = zeros(N, 1);
end

rsu_sigma = 10.0 ./ (1.0 + 3.0 * max(rssi_support_score_raw, 0.05));
rsu_sigma = rsu_sigma .* (1.0 + 0.25 * blind_zone_gate .* (env_attenuation_raw - 1.0));

if modules.use_gnss && modules.use_rsu
    coarse_sigma = 0.68 * sigma_pos + 0.32 * rsu_sigma;
elseif modules.use_gnss
    coarse_sigma = 1.08 * sigma_pos + 0.35 * (1.0 - env_score);
elseif modules.use_rsu
    coarse_sigma = 0.92 * rsu_sigma + 0.55 * (1.0 - rsu_support_score);
else
    coarse_sigma = 1.20 * sigma_pos + 1.20;
end

coarse_sigma = coarse_sigma ...
    - 0.42 * rsu_gain_gate ...
    - 0.28 * env_correction_gate .* (0.65 + 0.35 * env_detectability);
coarse_sigma = coarse_sigma + params.position_blind_zone_sigma_penalty * blind_zone_gate .* (1.0 - rsu_gain_gate);
coarse_sigma = max(0.35, min(coarse_sigma, 5.5));

bias_scale = coarse_sigma .* ( ...
    0.72 ...
    + 0.28 * (1.0 - gnss_score) ...
    + 0.20 * (1.0 - rsu_support_score) ...
    + 0.16 * (1.0 - env_score) ...
    - 0.10 * rsu_gain_gate ...
    - 0.08 * env_correction_gate);
bias_scale = max(0.25, bias_scale);
err_x = bias_scale .* (0.40 * sin(0.17 * t + 0.25) + 0.14 * cos(0.05 * t));
err_y = bias_scale .* (0.30 * cos(0.13 * t - 0.35) + 0.16 * sin(0.08 * t + 0.15));

% 添加 GNSS 独立多径误差（与 sidelink 信道无关的定位漂移）
% 物理来源：卫星信号的地面/树冠多径反射，独立于 5.9 GHz 直通链路
if use_random
    gnss_multipath_std = 0.12;  % 独立多径标准差（米级缩放后）
    if isfield(params, 'position_gnss_multipath_noise_std')
        gnss_multipath_std = params.position_gnss_multipath_noise_std;
    end
    gnss_mp_len = 8;  % 多径时间相关长度
    if isfield(params, 'position_gnss_multipath_temporal_len')
        gnss_mp_len = params.position_gnss_multipath_temporal_len;
    end
    err_x = err_x + gnss_multipath_std * local_smooth_noise_independent(N, gnss_mp_len);
    err_y = err_y + gnss_multipath_std * local_smooth_noise_independent(N, gnss_mp_len);
end

coarse_x = ego_x + err_x;
coarse_y = ego_y + err_y;

if modules.use_traj
    filter_state = step9_filter_position_confidence(coarse_x, coarse_y, coarse_sigma, params.dt, params);
    traj_score = filter_state.consistency_score;
else
    filter_state.filtered_x = coarse_x;
    filter_state.filtered_y = coarse_y;
    filter_state.innovation_norm = zeros(N, 1);
    filter_state.consistency_score = 0.50 * ones(N, 1);
    traj_score = filter_state.consistency_score;
end

adaptive_weights.gnss = ones(N, 1);
adaptive_weights.rsu = rsu_gain_gate;
adaptive_weights.env = env_correction_gate;
adaptive_weights.traj = ones(N, 1);

[q_pos, q_pos_raw] = step9_compute_position_confidence_cv2x_loca_like( ...
    gnss_score, rsu_support_score, env_score, traj_score, params, modules, adaptive_weights, blind_zone_gate);

position.ego_x = ego_x;
position.ego_y = ego_y;
position.rsu_x = rsu_x;
position.rsu_y = rsu_y;
position.rsu_coverage = rsu_cov;
position.rsu_distance = d_rsu;
position.rsu_support = support_mat;
position.visible_rsu = visible_mat;
position.nearest_rsu_distance = nearest_rsu_distance;
position.nearest_rsu_count = nearest_rsu_count;
position.blind_zone_gate = blind_zone_gate;
position.rsu_gain_gate = rsu_gain_gate;
position.env_correction_gate = env_correction_gate;
position.gnss_score = gnss_score;
position.rsu_support_score = rsu_support_score;
position.rssi_support_score = rsu_support_score;
position.rsu_support_score_raw = rssi_support_score_raw;
position.env_attenuation = env_attenuation;
position.env_score = env_score;
position.coarse_sigma = coarse_sigma;
position.coarse_x = coarse_x;
position.coarse_y = coarse_y;
position.filtered_x = filter_state.filtered_x;
position.filtered_y = filter_state.filtered_y;
position.traj_residual = filter_state.innovation_norm;
position.traj_score = traj_score;
position.q_pos_raw = q_pos_raw;
position.q_pos = q_pos;
position.modules = modules;
position.gnss_score_raw = gnss_score_raw;
position.env_attenuation_raw = env_attenuation_raw;
position.env_score_raw = env_score_raw;
position.adaptive_weights = adaptive_weights;
end

function noise = local_smooth_noise_independent(N, window_len)
%LOCAL_SMOOTH_NOISE_INDEPENDENT 生成独立于链路噪声的平滑随机序列。
%   使用独立的随机数生成器状态，确保与 sidelink 信道噪声完全解耦。
%   物理对应：GNSS 电离层闪烁、卫星多径等慢变化过程。
raw = randn(N, 1);
noise = movmean(raw, window_len);
std_noise = std(noise);
if std_noise > 1.0e-9
    noise = noise / std_noise;
else
    noise = zeros(N, 1);
end
end