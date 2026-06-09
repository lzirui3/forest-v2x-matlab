clc;
clear;
close all;

% Step43: data-backed threshold calibration for the proposed scheduler.
% This script does not modify get_default_step9_params.m. It only writes
% calibration evidence files with the step43_* prefix.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP43_NUM_SEEDS', 5);
sample_stride = get_env_int_local('STEP43_SAMPLE_STRIDE', 1);
scene_ids = get_env_string_list_local('STEP43_SCENES', ...
    ["10014", "10006", "10011", "10019", "10017"]);
config_names = get_env_string_list_local('STEP43_CONFIGS', ["Default", "ForestGeometry"]);
prefix = get_env_string_local('STEP43_PREFIX_TAG', ...
    "step43_threshold_calibration_" + string(num_seeds) + "seed");

scene_matrix = filter_scene_matrix_local(get_paper_scene_matrix(), scene_ids);
samples = [];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg = config_names
        for seed = 1:num_seeds
            fprintf('Step43 calibration sampling: scene=%s config=%s seed=%d/%d\n', ...
                scene_meta.scene_id, cfg, seed, num_seeds);

            params = get_params_for_config_local(cfg);
            params.scenario_input = scene_cfg;
            params.random_seed = seed;
            scenario = generate_step9_scenario(params);

            T_seed = build_sample_table_local(scenario, params, scene_meta, cfg, seed, sample_stride);
            samples = append_table_local(samples, T_seed);
        end
    end
end

[thresholds, diagnostics] = calibrate_thresholds_local(samples);

writetable(samples, prefix + "_samples.csv");
writetable(thresholds, prefix + "_threshold_table.csv");
writetable(diagnostics, prefix + "_diagnostics.csv");
write_report_local(thresholds, diagnostics, prefix + "_report.md", num_seeds, sample_stride);

disp(thresholds);
fprintf('Step43 complete: threshold calibration evidence written with prefix %s.\n', prefix);

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step43 config: %s', cfg);
end
end

function T = build_sample_table_local(scenario, params, scene_meta, cfg, seed, stride)
idx = (1:max(stride, 1):numel(scenario.t))';
N = numel(idx);

required_timely = zeros(N, 1);
required_protection = zeros(N, 1);
for ii = 1:N
    k = idx(ii);
    event_state = build_event_state_local(scenario, k);
    required_timely(ii) = compute_required_timely_target( ...
        scenario.urgency(k), scenario.q_link(k), scenario.q_pos(k), event_state, params);
    required_protection(ii) = compute_required_protection_level( ...
        scenario.urgency(k), scenario.q_link(k), scenario.q_pos(k), event_state, params);
end

deadline = scenario.deadline(idx);
delay_ratio = scenario.delay(idx) ./ max(deadline, 1.0e-6);

T = table( ...
    repmat(scene_meta.scene_id, N, 1), ...
    repmat(scene_meta.scene_role, N, 1), ...
    repmat(scene_meta.geometry_type, N, 1), ...
    repmat(scene_meta.density_class, N, 1), ...
    repmat(scene_meta.vegetation_class, N, 1), ...
    repmat(cfg, N, 1), ...
    repmat(seed, N, 1), ...
    scenario.t(idx), scenario.msg_type(idx), scenario.urgency(idx), ...
    scenario.q_pos(idx), scenario.q_link(idx), scenario.blind_zone_gate(idx), ...
    scenario.n_sat(idx), scenario.dop(idx), scenario.sigma_pos(idx), ...
    scenario.position_coarse_sigma(idx), scenario.pdr(idx), scenario.delay(idx), ...
    deadline, delay_ratio, logical(scenario.is_nlos(idx)), scenario.shadowing_dB(idx), ...
    required_timely, required_protection, ...
    'VariableNames', {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Seed','Time_s','MessageType','Urgency','QPos','QLink','BlindZoneGate', ...
    'NSat','DOP','SigmaPos_m','PositionSigma_m','PDR','Delay_s','Deadline_s', ...
    'DelayDeadlineRatio','IsNLOS','Shadowing_dB','RequiredTimelyDefault', ...
    'RequiredProtectionDefault'});
end

function event_state = build_event_state_local(scenario, k)
event_state.blind_zone_gate = scenario.blind_zone_gate(k);
event_state.rsu_gain_gate = scenario.rsu_gain_gate(k);
event_state.env_correction_gate = scenario.env_correction_gate(k);
event_state.use_gnss = scenario.position_modules.use_gnss;
event_state.use_rsu = scenario.position_modules.use_rsu;
event_state.use_env = scenario.position_modules.use_env;
event_state.use_traj = scenario.position_modules.use_traj;
end

function [T_thr, T_diag] = calibrate_thresholds_local(T)
params = get_default_step9_mainline_params();

sigma_q25 = quantile_local(T.PositionSigma_m, 0.25);
sigma_q75 = quantile_local(T.PositionSigma_m, 0.75);
dop_q25 = quantile_local(T.DOP, 0.25);
dop_q75 = quantile_local(T.DOP, 0.75);
nsat_q25 = quantile_local(T.NSat, 0.25);
nsat_q75 = quantile_local(T.NSat, 0.75);

reliable_position = T.PositionSigma_m <= sigma_q25 ...
    & T.DOP <= dop_q25 ...
    & T.NSat >= nsat_q75;
degraded_position = T.PositionSigma_m >= sigma_q75 ...
    | T.DOP >= dop_q75 ...
    | T.NSat <= nsat_q25;
high_blockage = logical(T.IsNLOS) ...
    | T.PDR <= get_env_double_local('STEP43_BAD_PDR_THRESHOLD', 0.70) ...
    | T.DelayDeadlineRatio >= 1.0;

[qpos_high, qpos_high_score] = best_threshold_local( ...
    T.QPos, reliable_position, "high", params.utility_required_timely_qpos_high_threshold);
[qpos_low, qpos_low_score] = best_threshold_local( ...
    T.QPos, degraded_position, "low", params.utility_required_timely_qpos_low_threshold);
[blind_thr, blind_score] = best_threshold_local( ...
    T.BlindZoneGate, high_blockage, "high", params.blind_zone_trigger_threshold);

qpos_high = clip_local(qpos_high, 0.55, 0.95);
qpos_low = clip_local(qpos_low, 0.25, 0.70);
if qpos_low >= qpos_high - 0.05
    qpos_high = params.utility_required_timely_qpos_high_threshold;
    qpos_low = params.utility_required_timely_qpos_low_threshold;
end
blind_thr = clip_local(blind_thr, 0.20, 0.85);

pos_risk = piecewise_position_risk_local(T.QPos, qpos_high, qpos_low, ...
    params.utility_required_timely_qpos_mid_scale, ...
    params.utility_required_timely_qpos_low_scale);
pos_activation = quantile_or_default_local(pos_risk(degraded_position & pos_risk > 0), ...
    0.25, params.utility_required_protection_activation_pos);
pos_activation = clip_local(pos_activation, 0.10, 0.70);

blind_excess = max(T.BlindZoneGate - blind_thr, 0.0);
blind_activation = quantile_or_default_local(blind_excess(high_blockage & blind_excess > 0), ...
    0.25, params.utility_required_protection_activation_blind);
blind_activation = clip_local(blind_activation, 0.03, 0.35);

rows = [];
rows = append_table_local(rows, make_threshold_row_local( ...
    "utility_required_timely_qpos_high_threshold", ...
    params.utility_required_timely_qpos_high_threshold, qpos_high, ...
    "ROC/Youden threshold for reliable-position label using q_pos >= threshold.", ...
    sum(reliable_position), height(T), qpos_high_score, ...
    "Reliable label: low position sigma, low DOP, high satellite count."));
rows = append_table_local(rows, make_threshold_row_local( ...
    "utility_required_timely_qpos_low_threshold", ...
    params.utility_required_timely_qpos_low_threshold, qpos_low, ...
    "ROC/Youden threshold for degraded-position label using q_pos <= threshold.", ...
    sum(degraded_position), height(T), qpos_low_score, ...
    "Degraded label: high position sigma, high DOP, or low satellite count."));
rows = append_table_local(rows, make_threshold_row_local( ...
    "blind_zone_trigger_threshold", ...
    params.blind_zone_trigger_threshold, blind_thr, ...
    "ROC/Youden threshold for high-blockage label using blind_zone >= threshold.", ...
    sum(high_blockage), height(T), blind_score, ...
    "High-blockage label: NLOS, PDR <= 0.70, or delay exceeds deadline."));
rows = append_table_local(rows, make_threshold_row_local( ...
    "utility_required_protection_activation_pos", ...
    params.utility_required_protection_activation_pos, pos_activation, ...
    "Lower-quartile position-risk level among degraded-position samples.", ...
    sum(degraded_position), height(T), NaN, ...
    "This controls when protection demand starts increasing from position risk."));
rows = append_table_local(rows, make_threshold_row_local( ...
    "utility_required_protection_activation_blind", ...
    params.utility_required_protection_activation_blind, blind_activation, ...
    "Lower-quartile excess-blindness level among high-blockage samples.", ...
    sum(high_blockage & blind_excess > 0), height(T), NaN, ...
    "This controls when protection demand starts increasing from blind-zone risk."));

T_thr = rows;
T_diag = build_diagnostics_local(T, reliable_position, degraded_position, high_blockage);
end

function row = make_threshold_row_local(parameter, default_value, recommended_value, rule, positive_count, sample_count, score, note)
row = table(parameter, default_value, recommended_value, rule, positive_count, sample_count, score, note, ...
    'VariableNames', {'Parameter','DefaultValue','RecommendedValue','EvidenceRule', ...
    'PositiveCount','SampleCount','CalibrationScore','Note'});
end

function T_diag = build_diagnostics_local(T, reliable_position, degraded_position, high_blockage)
signals = ["QPos"; "BlindZoneGate"; "PositionSigma_m"; "DOP"; "NSat"; ...
    "PDR"; "DelayDeadlineRatio"; "RequiredTimelyDefault"; "RequiredProtectionDefault"];
low_q = zeros(numel(signals), 1);
median_q = zeros(numel(signals), 1);
high_q = zeros(numel(signals), 1);
for i = 1:numel(signals)
    x = T.(char(signals(i)));
    low_q(i) = quantile_local(x, 0.25);
    median_q(i) = quantile_local(x, 0.50);
    high_q(i) = quantile_local(x, 0.75);
end

labels = ["ReliablePosition"; "DegradedPosition"; "HighBlockage"];
positive_rate = [mean(reliable_position); mean(degraded_position); mean(high_blockage)];
T_label = table(labels, positive_rate, ...
    'VariableNames', {'Diagnostic','PositiveRate'});

T_signal = table(signals, low_q, median_q, high_q, ...
    'VariableNames', {'Diagnostic','Q25','Median','Q75'});
T_signal.PositiveRate = NaN(height(T_signal), 1);

T_diag = [T_signal(:, {'Diagnostic','Q25','Median','Q75','PositiveRate'}); ...
    add_missing_quantile_columns_local(T_label)];
end

function T = add_missing_quantile_columns_local(T)
T.Q25 = NaN(height(T), 1);
T.Median = NaN(height(T), 1);
T.Q75 = NaN(height(T), 1);
T = T(:, {'Diagnostic','Q25','Median','Q75','PositiveRate'});
end

function [best_thr, best_score] = best_threshold_local(x, label, direction, default_thr)
x = double(x(:));
label = logical(label(:));
valid = isfinite(x) & ~isnan(x) & ~isnan(double(label));
x = x(valid);
label = label(valid);

if numel(x) < 10 || all(label) || ~any(label)
    best_thr = default_thr;
    best_score = NaN;
    return;
end

candidates = unique(arrayfun(@(q) quantile_local(x, q), linspace(0.05, 0.95, 91)));
best_thr = default_thr;
best_score = -inf;
for i = 1:numel(candidates)
    thr = candidates(i);
    if direction == "high"
        pred = x >= thr;
    else
        pred = x <= thr;
    end
    tp = sum(pred & label);
    fp = sum(pred & ~label);
    fn = sum(~pred & label);
    tn = sum(~pred & ~label);
    tpr = tp / max(tp + fn, 1);
    fpr = fp / max(fp + tn, 1);
    score = tpr - fpr;
    if score > best_score + 1.0e-12 ...
            || (abs(score - best_score) <= 1.0e-12 && abs(thr - default_thr) < abs(best_thr - default_thr))
        best_score = score;
        best_thr = thr;
    end
end
end

function risk = piecewise_position_risk_local(q_pos, high_thr, low_thr, mid_scale, low_scale)
risk = zeros(size(q_pos));
mid = q_pos <= high_thr & q_pos > low_thr;
low = q_pos <= low_thr;
risk(mid) = mid_scale .* (high_thr - q_pos(mid)) ./ max(high_thr - low_thr, 1.0e-6);
risk(low) = mid_scale + low_scale .* (low_thr - q_pos(low)) ./ max(low_thr, 1.0e-6);
risk = max(risk, 0.0);
end

function q = quantile_or_default_local(x, p, default_value)
x = x(isfinite(x));
if isempty(x)
    q = default_value;
else
    q = quantile_local(x, p);
end
end

function q = quantile_local(x, p)
x = sort(double(x(isfinite(x))));
if isempty(x)
    q = NaN;
    return;
end
p = clip_local(p, 0.0, 1.0);
pos = 1 + (numel(x) - 1) * p;
lo = floor(pos);
hi = ceil(pos);
if lo == hi
    q = x(lo);
else
    q = x(lo) + (x(hi) - x(lo)) * (pos - lo);
end
end

function y = clip_local(x, lo, hi)
y = min(max(x, lo), hi);
end

function scenes = filter_scene_matrix_local(scene_matrix, scene_ids)
scenes = scene_matrix([]);
for i = 1:numel(scene_ids)
    matched = false;
    for j = 1:numel(scene_matrix)
        if scene_matrix(j).scene_id == scene_ids(i)
            scenes(end + 1) = scene_matrix(j); %#ok<AGROW>
            matched = true;
            break;
        end
    end
    if ~matched
        error('Unknown Step43 scene id: %s', scene_ids(i));
    end
end
end

function values = get_env_string_list_local(name, default_values)
raw = getenv(name);
if isempty(raw)
    values = default_values;
else
    parts = split(string(raw), ',');
    values = strtrim(parts(:)).';
    values = values(strlength(values) > 0);
end
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = string(raw);
end
end

function value = get_env_int_local(name, default_value)
raw = str2double(getenv(name));
if isnan(raw) || raw < 1
    value = default_value;
else
    value = round(raw);
end
end

function value = get_env_double_local(name, default_value)
raw = str2double(getenv(name));
if isnan(raw)
    value = default_value;
else
    value = raw;
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end

function write_report_local(T_thr, T_diag, out_path, num_seeds, sample_stride)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step43 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step43 Threshold Calibration Report\n\n');
fprintf(fid, 'Purpose: convert key scheduler thresholds from hand-set values into data-backed recommendations.\n\n');
fprintf(fid, '- Seeds per scene/config: %d\n', num_seeds);
fprintf(fid, '- Sample stride: %d\n', sample_stride);
fprintf(fid, '- This step writes evidence only; it does not modify the main parameter file.\n\n');

fprintf(fid, '## Recommended Thresholds\n\n');
fprintf(fid, '| Parameter | Default | Recommended | Score | Evidence |\n');
fprintf(fid, '|---|---:|---:|---:|---|\n');
for i = 1:height(T_thr)
    fprintf(fid, '| `%s` | %.4f | %.4f | %.4f | %s |\n', ...
        T_thr.Parameter(i), T_thr.DefaultValue(i), T_thr.RecommendedValue(i), ...
        T_thr.CalibrationScore(i), T_thr.EvidenceRule(i));
end

fprintf(fid, '\n## Diagnostics\n\n');
fprintf(fid, '| Diagnostic | Q25 | Median | Q75 | PositiveRate |\n');
fprintf(fid, '|---|---:|---:|---:|---:|\n');
for i = 1:height(T_diag)
    fprintf(fid, '| %s | %.4f | %.4f | %.4f | %.4f |\n', ...
        T_diag.Diagnostic(i), T_diag.Q25(i), T_diag.Median(i), ...
        T_diag.Q75(i), T_diag.PositiveRate(i));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, 'A threshold is credible only if Step44 shows that the calibrated value and its perturbations do not overturn the main conclusion.\n');
fprintf(fid, 'Step43 provides provenance; Step44 provides robustness validation.\n');
end
