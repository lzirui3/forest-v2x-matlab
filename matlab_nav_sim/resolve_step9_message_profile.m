function [msg_type, urgency, base_rate, deadline, relay_available] = resolve_step9_message_profile(params, t, use_random, external)
%RESOLVE_STEP9_MESSAGE_PROFILE Build message-type and rate profile for Step 9.

N = numel(t);
msg_type = strings(N, 1);
msg_type(:) = "normal";
relay_available = zeros(N, 1);

if nargin >= 4 && isfield(external, 'has_message') && external.has_message
    ext_type = external.message.msg_type;
    valid_mask = strlength(ext_type) > 0;
    msg_type(valid_mask) = ext_type(valid_mask);
    if ~isempty(external.message.relay_available)
        relay_available = max(external.message.relay_available(:), 0.0);
    end
else
    % 消息类型时间边界（带随机偏移以避免与 NLOS 区间完美对齐）
    % 基准：normal[0,25) -> coop[25,55) -> emergency[55,90) -> coop[90,end)
    % 审稿人关注：固定边界使 emergency 总与 NLOS(t∈[68,90]) 完美重叠，
    % 实际林火场景中紧急消息触发时间取决于火情发展，不应与传播遮挡同步
    t_coop_start = 25;
    t_emg_start = 55;
    t_emg_end = 90;

    if use_random
        % 随机偏移量（±3~5秒），模拟火情报告时间不确定性
        t_coop_start = t_coop_start + round(2.0 * randn());
        t_emg_start  = t_emg_start  + round(3.0 * randn());
        t_emg_end    = t_emg_end    + round(2.5 * randn());
        % 保证时序合法性
        t_coop_start = max(t_coop_start, 15);
        t_emg_start  = max(t_emg_start, t_coop_start + 10);
        t_emg_end    = max(t_emg_end, t_emg_start + 15);
    end

    msg_type(t >= t_coop_start & t < t_emg_start) = "coop";
    msg_type(t >= t_emg_start & t < t_emg_end) = "emergency";
    msg_type(t >= t_emg_end) = "coop";

    relay_shift_1 = 0.0;
    relay_shift_2 = 0.0;
    if use_random
        relay_shift_1 = round(1.5 * randn());
        relay_shift_2 = round(1.5 * randn());
    end
    relay_available(t >= (52 + relay_shift_1) & t < (68 + relay_shift_1)) = 1;
    relay_available(t >= (96 + relay_shift_2) & t < (110 + relay_shift_2)) = 1;
end

urgency = zeros(N, 1);
base_rate = zeros(N, 1);
deadline = zeros(N, 1);

is_normal = msg_type == "normal";
is_coop = msg_type == "coop";
is_emergency = msg_type == "emergency";

urgency(is_normal) = params.urgency_normal;
urgency(is_coop) = params.urgency_coop;
urgency(is_emergency) = params.urgency_emergency;

base_rate(is_normal) = params.base_rate_normal;
base_rate(is_coop) = params.base_rate_coop;
base_rate(is_emergency) = params.base_rate_emergency;

deadline(is_normal) = params.deadline_normal;
deadline(is_coop) = params.deadline_coop;
deadline(is_emergency) = params.deadline_emergency;
end
