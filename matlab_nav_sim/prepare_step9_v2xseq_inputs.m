function summary = prepare_step9_v2xseq_inputs(scene_id)
%PREPARE_STEP9_V2XSEQ_INPUTS
% Convert one V2X-Seq cooperative trajectory scene into Step 9 inputs.

if nargin < 1 || strlength(string(scene_id)) == 0
    scene_id = "10006";
end

scene_id = string(scene_id);
rx_tag = "AV";
tx_tag = "TARGET_AGENT";
standard_horizon_s = 120.0;

base_dir = fileparts(mfilename('fullpath'));
repo_dir = fileparts(base_dir);
scene_file = fullfile(repo_dir, ...
    'external_data', 'V2X-Seq-TFD-Example', 'V2X-Seq-TFD-Example', ...
    'cooperative-vehicle-infrastructure', 'cooperative-trajectories', ...
    'train', 'data', sprintf('%s.csv', scene_id));

if ~isfile(scene_file)
    error('V2X-Seq scene file not found: %s', scene_file);
end

T = readtable(scene_file, 'TextType', 'string');
required = {'timestamp', 'tag', 'x', 'y'};
missing = required(~ismember(required, T.Properties.VariableNames));
if ~isempty(missing)
    error('V2X-Seq scene is missing required columns: %s', strjoin(missing, ', '));
end

T = sortrows(T, 'timestamp');
T_rx = sortrows(T(T.tag == rx_tag, :), 'timestamp');
T_tx = sortrows(T(T.tag == tx_tag, :), 'timestamp');

if isempty(T_rx) || isempty(T_tx)
    error('Scene %s does not contain both %s and %s tracks.', scene_id, rx_tag, tx_tag);
end

[t_common, idx_tx, idx_rx] = intersect(double(T_tx.timestamp), double(T_rx.timestamp), 'stable');
if numel(t_common) < 10
    error('Scene %s has too few aligned timestamps for %s/%s.', scene_id, tx_tag, rx_tag);
end

T_tx = T_tx(idx_tx, :);
T_rx = T_rx(idx_rx, :);
t_real = t_common(:);
t_norm = standard_horizon_s * (t_real - t_real(1)) / max(t_real(end) - t_real(1), eps);

tx_x = local_to_double(T_tx.x);
tx_y = local_to_double(T_tx.y);
rx_x = local_to_double(T_rx.x);
rx_y = local_to_double(T_rx.y);

distance = hypot(tx_x - rx_x, tx_y - rx_y);
closing_speed = zeros(size(distance));
if numel(distance) >= 2
    dt_real = diff(t_real);
    dd = diff(distance);
    closing_speed(2:end) = max(-dd ./ max(dt_real, 1.0e-6), 0.0);
    closing_speed(1) = closing_speed(2);
end

ttc = inf(size(distance));
valid_closing = closing_speed > 1.0e-3;
ttc(valid_closing) = distance(valid_closing) ./ closing_speed(valid_closing);

msg_type = repmat("normal", numel(t_norm), 1);
is_coop = (distance <= 65.0) | (ttc <= 8.0);
is_emergency = (distance <= 35.0) | (ttc <= 4.0);
msg_type(is_coop) = "coop";
msg_type(is_emergency) = "emergency";

if ~any(is_emergency)
    [~, idx_min] = min(distance);
    idx_emerg_start = max(1, idx_min - 8);
    idx_coop_start = max(1, idx_emerg_start - 18);
    msg_type(idx_coop_start:idx_emerg_start - 1) = "coop";
    msg_type(idx_emerg_start:end) = "emergency";
end

road_side_id = -ones(size(distance));
if ismember('road_side_id', T_tx.Properties.VariableNames)
    road_side_id = local_to_double(T_tx.road_side_id);
end

relay_available = double((road_side_id > 0) & (msg_type ~= "normal"));
if any(relay_available > 0)
    relay_available = double(movmax(relay_available, [2, 2]) > 0);
end

[rsu_x, rsu_y, rsu_cov] = local_build_rsu_layout(repo_dir, scene_id, rx_x, rx_y);
[is_nlos, nlosv, shadowing_dB, interference_dB] = local_build_blockage_profile(T_tx, t_real, t_norm, distance, relay_available);

trajectory_table = table( ...
    t_norm, tx_x, tx_y, rx_x, rx_y, relay_available, ...
    'VariableNames', {'t', 'tx_x', 'tx_y', 'rx_x', 'rx_y', 'relay_available'});

message_table = table( ...
    t_norm, msg_type, relay_available, ...
    'VariableNames', {'t', 'msg_type', 'relay_available'});

rsu_table = table( ...
    rsu_x, rsu_y, rsu_cov, ...
    'VariableNames', {'rsu_x', 'rsu_y', 'coverage'});

blockage_table = table( ...
    t_norm, is_nlos, nlosv, shadowing_dB, interference_dB, ...
    'VariableNames', {'t', 'is_nlos', 'nlosv', 'shadowing_dB', 'interference_dB'});

output_dir = fullfile(base_dir, 'step9_data_templates');
trajectory_file = fullfile(output_dir, sprintf('v2xseq_scene%s_trajectory.csv', scene_id));
message_file = fullfile(output_dir, sprintf('v2xseq_scene%s_message_profile.csv', scene_id));
rsu_file = fullfile(output_dir, sprintf('v2xseq_scene%s_rsu_layout.csv', scene_id));
blockage_file = fullfile(output_dir, sprintf('v2xseq_scene%s_blockage_profile.csv', scene_id));

writetable(trajectory_table, trajectory_file);
writetable(message_table, message_file);
writetable(rsu_table, rsu_file);
writetable(blockage_table, blockage_file);

summary = struct();
summary.scene_id = scene_id;
summary.rx_tag = rx_tag;
summary.tx_tag = tx_tag;
summary.num_samples = numel(t_norm);
summary.real_duration_s = t_real(end) - t_real(1);
summary.standard_duration_s = standard_horizon_s;
summary.min_distance_m = min(distance);
summary.max_distance_m = max(distance);
summary.num_normal = sum(msg_type == "normal");
summary.num_coop = sum(msg_type == "coop");
summary.num_emergency = sum(msg_type == "emergency");
summary.num_relay = sum(relay_available > 0);
summary.num_nlos = sum(is_nlos > 0);
summary.trajectory_file = string(trajectory_file);
summary.message_file = string(message_file);
summary.rsu_file = string(rsu_file);
summary.blockage_file = string(blockage_file);

disp(struct2table(summary));
end

function x = local_to_double(v)
if isnumeric(v)
    x = double(v(:));
else
    x = str2double(string(v(:)));
end
end

function [rsu_x, rsu_y, rsu_cov] = local_build_rsu_layout(repo_dir, scene_id, rx_x, rx_y)
traffic_file = fullfile(repo_dir, ...
    'external_data', 'V2X-Seq-TFD-Example', 'V2X-Seq-TFD-Example', ...
    'cooperative-vehicle-infrastructure', 'traffic-light', 'train', ...
    sprintf('%s.csv', scene_id));

if ~isfile(traffic_file)
    error('Traffic-light file not found: %s', traffic_file);
end

T_tl = readtable(traffic_file, 'TextType', 'string');
tl_xy = unique([local_to_double(T_tl.x), local_to_double(T_tl.y)], 'rows', 'stable');

if size(tl_xy, 1) < 2
    error('Traffic-light anchors are insufficient for RSU layout.');
end

intersection_center = mean(tl_xy, 1);
dist_to_center = hypot(tl_xy(:, 1) - intersection_center(1), tl_xy(:, 2) - intersection_center(2));
[~, sort_idx] = sort(dist_to_center, 'descend');
keep_idx = sort_idx(1:min(4, numel(sort_idx)));
anchors = tl_xy(keep_idx, :);

rx_span = max(hypot(rx_x - intersection_center(1), rx_y - intersection_center(2)));
base_cov = max(28.0, min(75.0, 0.85 * rx_span));

rsu_x = anchors(:, 1);
rsu_y = anchors(:, 2);
rsu_cov = base_cov * ones(size(rsu_x));
end

function [is_nlos, nlosv, shadowing_dB, interference_dB] = local_build_blockage_profile(T_tx, t_real, t_norm, distance, relay_available)
car_side_id = -ones(height(T_tx), 1);
road_side_id = -ones(height(T_tx), 1);
from_side = zeros(height(T_tx), 1);

if ismember('car_side_id', T_tx.Properties.VariableNames)
    car_side_id = local_to_double(T_tx.car_side_id);
end
if ismember('road_side_id', T_tx.Properties.VariableNames)
    road_side_id = local_to_double(T_tx.road_side_id);
end
if ismember('from_side', T_tx.Properties.VariableNames)
    from_side = local_to_double(T_tx.from_side);
end

car_visible = car_side_id > 0;
road_visible = road_side_id > 0;
cross_view_only = road_visible & ~car_visible;
single_view_break = xor(car_visible, road_visible);

is_nlos = double(cross_view_only | (single_view_break & (distance <= 55.0)));
is_nlos = double(movmax(is_nlos, [2, 2]) > 0);

nlosv = zeros(size(is_nlos));
nlosv(is_nlos > 0) = 1;
nlosv(cross_view_only & (distance <= 40.0)) = 2;
nlosv((from_side == 2) & (distance <= 32.0)) = max(nlosv((from_side == 2) & (distance <= 32.0)), 2);

distance_scale = min(max((distance - 20.0) / 40.0, 0.0), 1.0);
shadowing_dB = 0.12 + 0.18 * distance_scale + 0.28 * is_nlos + 0.12 * (nlosv / 2.0);
interference_dB = 0.04 + 0.08 * relay_available + 0.16 * is_nlos + 0.06 * distance_scale;

shadowing_dB = min(max(shadowing_dB, 0.0), 0.85);
interference_dB = min(max(interference_dB, 0.0), 0.65);

is_nlos = is_nlos(:);
nlosv = nlosv(:);
shadowing_dB = shadowing_dB(:);
interference_dB = interference_dB(:);
end
