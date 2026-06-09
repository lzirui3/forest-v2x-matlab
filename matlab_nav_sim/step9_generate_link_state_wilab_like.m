function link = step9_generate_link_state_wilab_like(t, params, external)
%STEP9_GENERATE_LINK_STATE_WILAB_LIKE Generate a WiLab-inspired link state sequence.

if nargin < 2
    params = struct();
end
if nargin < 3
    external = struct();
end

N = numel(t);
use_random = isfield(params, 'random_seed') && ~isempty(params.random_seed);

if isfield(external, 'has_trajectory') && external.has_trajectory
    tx_x = external.trajectory.tx_x(:);
    tx_y = external.trajectory.tx_y(:);
    rx_x = external.trajectory.rx_x(:);
    rx_y = external.trajectory.rx_y(:);
else
    tx_x = zeros(N, 1);
    tx_y = zeros(N, 1);
    rx_x = zeros(N, 1);
    rx_y = zeros(N, 1);

    rx_x(t < 25) = 40 + 0.2 * t(t < 25);
    rx_x(t >= 25 & t < 55) = 70 + 0.6 * (t(t >= 25 & t < 55) - 25);
    rx_x(t >= 55 & t < 68) = 150 + 3.5 * (t(t >= 55 & t < 68) - 55);
    rx_x(t >= 68 & t < 90) = 100 + 0.8 * (t(t >= 68 & t < 90) - 68);
    rx_x(t >= 90) = 95 + 0.9 * (t(t >= 90) - 90);

    rx_y(t < 68) = 0;
    rx_y(t >= 68 & t < 90) = 4.0 * sin((t(t >= 68 & t < 90) - 68) / 22 * pi);
    rx_y(t >= 90) = 0;
end

distance = params.link_distance_scale * sqrt((rx_x - tx_x).^2 + (rx_y - tx_y).^2);

pos_x = [tx_x, rx_x];
pos_y = [tx_y, rx_y];
nlosv_pair = zeros(N, 1);
for k = 1:N
    nlosv_mat = step9_calculate_nlosv(pos_x(k, :)', pos_y(k, :)');
    nlosv_pair(k) = nlosv_mat(1, 2);
end

is_nlos = false(N, 1);
if isfield(external, 'has_blockage') && external.has_blockage
    is_nlos = logical(external.blockage.is_nlos(:));
    nlosv_pair = max(nlosv_pair, external.blockage.nlosv(:));
else
    nlos_shift = 0.0;
    if use_random
        nlos_shift = 1.4 * randn();
    end
    is_nlos(t >= (68 + nlos_shift) & t < (90 + nlos_shift)) = true;
    is_nlos = is_nlos | (nlosv_pair > 0);
end

pl_dB = zeros(N, 1);
pl_dB(~is_nlos) = params.pathloss_los_offset_dB ...
    + params.pathloss_los_exponent * log10(max(distance(~is_nlos), 1.0));
pl_dB(is_nlos) = params.pathloss_nlos_offset_dB ...
    + params.pathloss_nlos_exponent * log10(max(distance(is_nlos), 1.0)) ...
    + params.nlosv_extra_loss_dB * max(nlosv_pair(is_nlos), 1);

shadow_sigma = 3.0 * ones(N, 1);
shadow_sigma(is_nlos) = 4.0;

shadow_phase_1 = 0.3;
shadow_phase_2 = 0.0;
shadow_scale = 1.0;
int_scale = [1.0, 1.0, 1.0];
int_shift = [0.0, 0.0, 0.0];
if use_random
    shadow_phase_1 = 2.0 * pi * rand();
    shadow_phase_2 = 2.0 * pi * rand();
    shadow_scale = 0.85 + 0.30 * rand();
    int_scale = 0.78 + 0.44 * rand(1, 3);
    int_shift = [1.0, 1.5, 1.5] .* randn(1, 3);
end

shadowing_dB = shadow_scale .* (shadow_sigma .* sin(0.09 * t + shadow_phase_1) ...
    + 0.5 * shadow_sigma .* cos(0.04 * t + shadow_phase_2));
if use_random
    shadowing_dB = shadowing_dB + 0.45 * shadow_sigma .* local_smooth_noise(N, 5);
end
if isfield(external, 'has_blockage') && external.has_blockage
    % In external-input mode, blockage profiles represent measured/calibrated
    % shadowing levels and should replace the synthetic perturbation.
    shadowing_dB = external.blockage.shadowing_dB(:);
    shadowing_dB = shadowing_dB + params.blind_link_loss_scale_dB ...
        * double(external.blockage.is_nlos(:)) ...
        .* min(max(external.blockage.nlosv(:), 0.0) / 2.0, 1.0);
    if isfield(params, 'use_veg_attenuation') && params.use_veg_attenuation ...
            && isfield(external.blockage, 'veg_atten_dB')
        coeff = paramsafe_local(params, 'veg_attenuation_shadowing_coeff', 0.65);
        shadowing_dB = shadowing_dB + coeff * external.blockage.veg_atten_dB(:);
    end
end

tx_power_dBm = params.tx_power_dBm;
noise_floor_dBm = params.noise_floor_dBm;
interference_dB = params.interference_scale * ( ...
    int_scale(1) * 6.0 * exp(-((t - (60 + int_shift(1))) / 8).^2) ...
    + int_scale(2) * 1.0 * exp(-((t - (78 + int_shift(2))) / 7).^2) ...
    + int_scale(3) * 1.5 * exp(-((t - (105 + int_shift(3))) / 9).^2));
if isfield(external, 'has_blockage') && external.has_blockage
    interference_dB = external.blockage.interference_dB(:) ...
        + params.blind_interference_scale_dB * double(external.blockage.is_nlos(:));
    if isfield(params, 'use_veg_attenuation') && params.use_veg_attenuation ...
            && isfield(external.blockage, 'veg_atten_dB')
        coeff = paramsafe_local(params, 'veg_attenuation_interference_coeff', 0.18);
        interference_dB = interference_dB + coeff * external.blockage.veg_atten_dB(:);
    end
end

rx_power_dBm = tx_power_dBm - pl_dB - shadowing_dB;
sinr_dB = rx_power_dBm - noise_floor_dBm - interference_dB;

pdr = zeros(N, 1);
for k = 1:N
    pdr(k) = sinr_to_pdr_physical(sinr_dB(k), is_nlos(k), params);
end
pdr = min(max(pdr, 0.01), 0.999);

delay = 0.04 + 0.18 ./ max(pdr, 0.05) + 0.006 * max(distance - 40, 0) / 10 + 0.012 * double(is_nlos);
if use_random
    delay = delay + 0.004 * max(local_smooth_noise(N, 5), -0.8);
end
delay = max(0.02, delay);
loss = 1.0 - pdr;

link.distance = distance;
link.nlosv = nlosv_pair;
link.is_nlos = is_nlos;
link.pathloss_dB = pl_dB;
link.shadowing_dB = shadowing_dB;
link.sinr_dB = sinr_dB;
link.pdr = pdr;
link.delay = delay;
link.loss = loss;
link.tx_x = tx_x;
link.tx_y = tx_y;
link.rx_x = rx_x;
link.rx_y = rx_y;
end

function noise = local_smooth_noise(N, window_len)
noise = movmean(randn(N, 1), window_len);
std_noise = std(noise);
if std_noise > 1.0e-9
    noise = noise / std_noise;
else
    noise = zeros(N, 1);
end
end

function value = paramsafe_local(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
