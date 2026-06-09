function [q_pos, q_pos_raw] = step9_compute_position_confidence_cv2x_loca_like( ...
    gnss_score, rssi_support_score, env_score, traj_score, params, modules, adaptive_weights, blind_zone_gate)
%STEP9_COMPUTE_POSITION_CONFIDENCE_CV2X_LOCA_LIKE
% Fuse GNSS, sparse RSU support, environment, and trajectory consistency.

if nargin < 6 || isempty(modules)
    modules = get_default_position_module_config();
end

N = numel(gnss_score);
if nargin < 7 || isempty(adaptive_weights)
    adaptive_weights.gnss = ones(N, 1);
    adaptive_weights.rsu = ones(N, 1);
    adaptive_weights.env = ones(N, 1);
    adaptive_weights.traj = ones(N, 1);
end
if nargin < 8 || isempty(blind_zone_gate)
    blind_zone_gate = zeros(size(gnss_score));
end

weights = [ ...
    params.position_weight_gnss * double(modules.use_gnss) * adaptive_weights.gnss(:), ...
    params.position_weight_rsu * double(modules.use_rsu) * adaptive_weights.rsu(:), ...
    params.position_weight_env * double(modules.use_env) * adaptive_weights.env(:), ...
    params.position_weight_traj * double(modules.use_traj) * adaptive_weights.traj(:)];

weight_sum = sum(weights, 2);
if any(weight_sum <= eps)
    error('At least one positioning confidence module must remain enabled at every sample.');
end
weights = weights ./ weight_sum;

q_pos_raw = weights(:, 1) .* gnss_score ...
    + weights(:, 2) .* rssi_support_score ...
    + weights(:, 3) .* env_score ...
    + weights(:, 4) .* traj_score;
q_pos_raw = q_pos_raw - params.position_blind_zone_score_penalty * blind_zone_gate(:) ...
    .* max(1.0 - rssi_support_score(:), 0.0);
q_pos_raw = min(max(q_pos_raw, 0.0), 1.0);

q_pos = zeros(N, 1);
q_pos(1) = q_pos_raw(1);

for k = 2:N
    delta = abs(q_pos_raw(k) - q_pos(k - 1));
    alpha = params.position_alpha_base ...
        + params.position_alpha_delta_scale * delta ...
        + params.position_alpha_traj_scale * (1.0 - traj_score(k)) ...
        + params.position_alpha_blind_scale * blind_zone_gate(k);
    alpha = min(max(alpha, params.position_alpha_min), params.position_alpha_max);
    q_pos(k) = alpha * q_pos_raw(k) + (1.0 - alpha) * q_pos(k - 1);
end

q_pos = min(max(q_pos, 0.0), 1.0);
end
