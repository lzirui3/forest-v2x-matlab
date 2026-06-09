function external = load_step9_external_inputs(params, t)
%LOAD_STEP9_EXTERNAL_INPUTS Load optional data-backed inputs for Step 9 scenario generation.

external = struct();
external.enabled = false;
external.mode = "fallback";
external.has_trajectory = false;
external.has_rsu = false;
external.has_blockage = false;
external.has_gnss = false;
external.has_message = false;
external.trajectory = struct();
external.rsu = struct();
external.blockage = struct();
external.gnss = struct();
external.message = struct();

if ~isfield(params, 'scenario_input') || isempty(params.scenario_input)
    return;
end

config = params.scenario_input;
if ~isfield(config, 'mode') || isempty(config.mode)
    config.mode = "fallback";
end
if ~isfield(config, 'strict_external') || isempty(config.strict_external)
    config.strict_external = false;
end
if ~isfield(config, 'interp_method') || isempty(config.interp_method)
    config.interp_method = "linear";
end

external.mode = string(config.mode);
if external.mode ~= "external"
    return;
end

external.enabled = true;
external.strict_external = logical(config.strict_external);
external.interp_method = char(config.interp_method);

[external.trajectory, external.has_trajectory] = local_load_trajectory(config, t, external);
[external.rsu, external.has_rsu] = local_load_rsu(config);
[external.blockage, external.has_blockage] = local_load_blockage(config, t, external);
[external.gnss, external.has_gnss] = local_load_gnss(config, t, external);
[external.message, external.has_message] = local_load_message(config, t, external);

if external.has_rsu
    external.rsu = local_apply_rsu_level(external.rsu, config);
end
if external.has_gnss
    external.gnss = local_apply_gnss_level(external.gnss, config);
end
end

function [trajectory, ok] = local_load_trajectory(config, t, external)
trajectory = struct();
ok = false;
if ~isfield(config, 'trajectory_file') || strlength(string(config.trajectory_file)) == 0
    local_require_or_skip(external, 'trajectory');
    return;
end

file = char(config.trajectory_file);
if ~isfile(file)
    local_require_or_skip(external, sprintf('trajectory file missing: %s', file));
    return;
end

T = readtable(file);
required = {'t', 'tx_x', 'tx_y', 'rx_x', 'rx_y'};
local_check_columns(T, required, file, external);

trajectory.t = T.t(:);
trajectory.tx_x = local_interp_to_t(trajectory.t, T.tx_x(:), t, external.interp_method);
trajectory.tx_y = local_interp_to_t(trajectory.t, T.tx_y(:), t, external.interp_method);
trajectory.rx_x = local_interp_to_t(trajectory.t, T.rx_x(:), t, external.interp_method);
trajectory.rx_y = local_interp_to_t(trajectory.t, T.rx_y(:), t, external.interp_method);

if ismember('relay_available', T.Properties.VariableNames)
    trajectory.relay_available = local_interp_to_t(trajectory.t, T.relay_available(:), t, 'previous');
else
    trajectory.relay_available = zeros(numel(t), 1);
end

ok = true;
end

function [rsu, ok] = local_load_rsu(config)
rsu = struct();
ok = false;
if ~isfield(config, 'rsu_layout_file') || strlength(string(config.rsu_layout_file)) == 0
    return;
end

file = char(config.rsu_layout_file);
if ~isfile(file)
    return;
end

T = readtable(file);
required = {'rsu_x', 'rsu_y', 'coverage'};
local_check_columns(T, required, file, struct('strict_external', false));

rsu.x = T.rsu_x(:)';
rsu.y = T.rsu_y(:)';
rsu.coverage = T.coverage(:)';
ok = true;
end

function [blockage, ok] = local_load_blockage(config, t, external)
blockage = struct();
ok = false;
if ~isfield(config, 'blockage_profile_file') || strlength(string(config.blockage_profile_file)) == 0
    return;
end

file = char(config.blockage_profile_file);
if ~isfile(file)
    return;
end

T = readtable(file);
required = {'t'};
local_check_columns(T, required, file, external);

blockage.t = T.t(:);
if ismember('is_nlos', T.Properties.VariableNames)
    blockage.is_nlos = local_interp_to_t(blockage.t, T.is_nlos(:), t, 'previous') >= 0.5;
else
    blockage.is_nlos = false(numel(t), 1);
end
if ismember('nlosv', T.Properties.VariableNames)
    blockage.nlosv = max(local_interp_to_t(blockage.t, T.nlosv(:), t, external.interp_method), 0.0);
else
    blockage.nlosv = zeros(numel(t), 1);
end
if ismember('shadowing_dB', T.Properties.VariableNames)
    blockage.shadowing_dB = local_interp_to_t(blockage.t, T.shadowing_dB(:), t, external.interp_method);
else
    blockage.shadowing_dB = zeros(numel(t), 1);
end
if ismember('interference_dB', T.Properties.VariableNames)
    blockage.interference_dB = local_interp_to_t(blockage.t, T.interference_dB(:), t, external.interp_method);
else
    blockage.interference_dB = zeros(numel(t), 1);
end
if ismember('veg_atten_dB', T.Properties.VariableNames)
    blockage.veg_atten_dB = local_interp_to_t(blockage.t, T.veg_atten_dB(:), t, external.interp_method);
else
    blockage.veg_atten_dB = zeros(numel(t), 1);
end

ok = true;
end

function [gnss, ok] = local_load_gnss(config, t, external)
gnss = struct();
ok = false;
if ~isfield(config, 'gnss_config_file') || strlength(string(config.gnss_config_file)) == 0
    return;
end

file = char(config.gnss_config_file);
if ~isfile(file)
    return;
end

T = readtable(file);
required = {'t'};
local_check_columns(T, required, file, external);

gnss.t = T.t(:);

if ismember('n_sat', T.Properties.VariableNames)
    gnss.n_sat = local_interp_to_t(gnss.t, T.n_sat(:), t, external.interp_method);
else
    gnss.n_sat = [];
end
if ismember('dop', T.Properties.VariableNames)
    gnss.dop = local_interp_to_t(gnss.t, T.dop(:), t, external.interp_method);
else
    gnss.dop = [];
end
if ismember('sigma_pos', T.Properties.VariableNames)
    gnss.sigma_pos = local_interp_to_t(gnss.t, T.sigma_pos(:), t, external.interp_method);
else
    gnss.sigma_pos = [];
end
if ismember('dt_upd', T.Properties.VariableNames)
    gnss.dt_upd = local_interp_to_t(gnss.t, T.dt_upd(:), t, external.interp_method);
else
    gnss.dt_upd = [];
end

ok = true;
end

function [message, ok] = local_load_message(config, t, external)
message = struct();
ok = false;
if ~isfield(config, 'message_profile_file') || strlength(string(config.message_profile_file)) == 0
    return;
end

file = char(config.message_profile_file);
if ~isfile(file)
    return;
end

T = readtable(file, 'TextType', 'string');
required = {'t'};
local_check_columns(T, required, file, external);

message.t = T.t(:);
if ismember('msg_type', T.Properties.VariableNames)
    message.msg_type = local_interp_string_to_t(message.t, string(T.msg_type(:)), t);
else
    message.msg_type = strings(numel(t), 1);
end
if ismember('relay_available', T.Properties.VariableNames)
    message.relay_available = local_interp_to_t(message.t, T.relay_available(:), t, 'previous');
else
    message.relay_available = [];
end

ok = true;
end

function y = local_interp_to_t(src_t, src_y, target_t, method)
src_t = src_t(:);
src_y = src_y(:);
target_t = target_t(:);

if isempty(src_t) || isempty(src_y)
    y = zeros(numel(target_t), 1);
    return;
end

[src_t, unique_idx] = unique(src_t, 'stable');
src_y = src_y(unique_idx);

if strcmpi(method, 'previous')
    y = interp1(src_t, src_y, target_t, 'previous', 'extrap');
else
    y = interp1(src_t, src_y, target_t, method, 'extrap');
end
end

function y = local_interp_string_to_t(src_t, src_y, target_t)
src_t = src_t(:);
src_y = string(src_y(:));
target_t = target_t(:);

[src_t, unique_idx] = unique(src_t, 'stable');
src_y = src_y(unique_idx);

y = strings(numel(target_t), 1);
for k = 1:numel(target_t)
    idx = find(src_t <= target_t(k), 1, 'last');
    if isempty(idx)
        idx = 1;
    end
    y(k) = src_y(idx);
end
end

function local_check_columns(T, required, file, external)
missing = required(~ismember(required, T.Properties.VariableNames));
if isempty(missing)
    return;
end

message = sprintf('Missing required column(s) in %s: %s', file, strjoin(missing, ', '));
if isfield(external, 'strict_external') && external.strict_external
    error(message);
end
warning(message);
end

function local_require_or_skip(external, item_name)
if isfield(external, 'strict_external') && external.strict_external
    error('Step9 external scenario input requires %s.', item_name);
end
end

function rsu = local_apply_rsu_level(rsu, config)
if ~isfield(config, 'rsu_level')
    return;
end

switch char(string(config.rsu_level))
    case 'Sparse'
        keep_idx = 1:2:numel(rsu.x);
        rsu.x = rsu.x(keep_idx);
        rsu.y = rsu.y(keep_idx);
        rsu.coverage = 0.88 * rsu.coverage(keep_idx);
    case 'Medium'
        return;
    case 'Dense'
        rsu.coverage = 1.15 * rsu.coverage;
    otherwise
        return;
end
end

function gnss = local_apply_gnss_level(gnss, config)
if ~isfield(config, 'gnss_level')
    return;
end

switch char(string(config.gnss_level))
    case 'Weak'
        scale = 0.85;
    case 'Medium'
        scale = 1.00;
    case 'Strong'
        scale = 1.20;
    otherwise
        scale = 1.00;
end

if ~isempty(gnss.n_sat)
    gnss.n_sat = gnss.n_sat / scale;
end
if ~isempty(gnss.dop)
    gnss.dop = gnss.dop * scale;
end
if ~isempty(gnss.sigma_pos)
    gnss.sigma_pos = gnss.sigma_pos * scale;
end
if ~isempty(gnss.dt_upd)
    gnss.dt_upd = gnss.dt_upd * scale;
end
end
