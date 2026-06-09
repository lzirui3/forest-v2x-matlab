function [n_sat, dop, sigma_pos, dt_upd] = resolve_step9_gnss_profile(params, t, use_random, external)
%RESOLVE_STEP9_GNSS_PROFILE Build GNSS degradation profile for Step 9.

if isfield(params, 'gnss_degradation_scale') && ~isempty(params.gnss_degradation_scale)
    gnss_deg_scale = params.gnss_degradation_scale;
else
    gnss_deg_scale = 1.0;
end

N = numel(t);
center_coop = 35.0;
center_emerg = 78.0;
if use_random
    center_coop = center_coop + 1.2 * randn();
    center_emerg = center_emerg + 1.8 * randn();
    sat_noise = 0.45 * local_smooth_noise(N, 7);
    dop_noise = 0.12 * local_smooth_noise(N, 9);
    sigma_noise = 0.16 * local_smooth_noise(N, 9);
    update_noise = 0.10 * local_smooth_noise(N, 7);
else
    sat_noise = zeros(N, 1);
    dop_noise = zeros(N, 1);
    sigma_noise = zeros(N, 1);
    update_noise = zeros(N, 1);
end

n_sat = 11 - gnss_deg_scale * 5.5 * exp(-((t - center_emerg) / 10).^2) ...
    - gnss_deg_scale * 1.5 * exp(-((t - center_coop) / 8).^2) ...
    + sat_noise;
n_sat = max(3, min(12, n_sat));

dop = 1.2 + gnss_deg_scale * 2.8 * exp(-((t - center_emerg) / 11).^2) ...
    + gnss_deg_scale * 0.6 * exp(-((t - center_coop) / 8).^2) ...
    + dop_noise;
dop = min(5.0, dop);
dop = max(1.0, dop);

sigma_pos = 0.4 + gnss_deg_scale * 2.5 * exp(-((t - center_emerg) / 11).^2) ...
    + gnss_deg_scale * 0.5 * exp(-((t - center_coop) / 8).^2) ...
    + sigma_noise;
sigma_pos = max(0.25, sigma_pos);

dt_upd = 0.10 + gnss_deg_scale * 0.60 * exp(-((t - center_emerg) / 10).^2) ...
    + gnss_deg_scale * 0.15 * exp(-((t - center_coop) / 8).^2) ...
    + update_noise;
dt_upd = max(0.05, dt_upd);

if nargin < 4 || ~isfield(external, 'has_gnss') || ~external.has_gnss
    return;
end

gnss = external.gnss;
if ~isempty(gnss.n_sat)
    n_sat = max(3, min(12, gnss_deg_scale * gnss.n_sat(:)));
end
if ~isempty(gnss.dop)
    dop = max(1.0, min(5.5, gnss_deg_scale * gnss.dop(:)));
end
if ~isempty(gnss.sigma_pos)
    sigma_pos = max(0.25, gnss_deg_scale * gnss.sigma_pos(:));
end
if ~isempty(gnss.dt_upd)
    dt_upd = max(0.05, gnss_deg_scale * gnss.dt_upd(:));
end
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
