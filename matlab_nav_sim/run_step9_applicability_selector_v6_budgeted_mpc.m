function result = run_step9_applicability_selector_v6_budgeted_mpc(scenario, params)
%RUN_STEP9_APPLICABILITY_SELECTOR_V6_BUDGETED_MPC Step66 selector side-copy.
%
% Uses state-only applicability gates. It does not inspect realized delivery
% outcomes. High dense-blind emergency windows fall back to V6; otherwise
% the cost-controlled MPC candidate is used.

v6 = run_step9_confidence_driven_risk_constrained_v6(scenario, params);
bmpc = run_step9_budgeted_lexico_chance_mpc_scheduler(scenario, params);

N = numel(scenario.t);
use_v6 = false(N, 1);
selection_reason = strings(N, 1);

horizon = paramsafe_local(params, 'step66_selector_horizon', 2);
scene_guard_v6 = is_scene_level_v6_guard_local(scenario, params);
for k = 1:N
    if scene_guard_v6
        use_v6(k) = true;
        selection_reason(k) = "fallback_scene_dense_emergency";
    else
        [use_v6(k), selection_reason(k)] = should_fallback_to_v6_local(scenario, k, horizon, params);
    end
end

policy = bmpc.policy;
policy.priority(use_v6) = v6.policy.priority(use_v6);
policy.tx_rate(use_v6) = v6.policy.tx_rate(use_v6);
policy.mode(use_v6) = v6.policy.mode(use_v6);
policy.score(use_v6) = v6.policy.score(use_v6);
policy.selector_use_v6 = use_v6;
policy.selection_reason = selection_reason;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Selector-V6-BudgetedMPC";
result.policy = policy;
result.delivery = delivery;
end

function guard = is_scene_level_v6_guard_local(scenario, params)
blind = get_series_local(scenario, 'blind_zone_gate', 1:numel(scenario.t), 0.0);
emg_ratio = mean(scenario.urgency >= paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80));
blind_ratio = mean(blind >= paramsafe_local(params, 'step66_scene_guard_blind_threshold', 0.45));

guard = emg_ratio >= paramsafe_local(params, 'step66_scene_guard_emg_ratio', 0.80) ...
    && blind_ratio >= paramsafe_local(params, 'step66_scene_guard_blind_ratio', 0.28);
end

function [fallback, reason] = should_fallback_to_v6_local(scenario, k, horizon, params)
N = numel(scenario.t);
idx = k:min(k + horizon - 1, N);

blind = get_series_local(scenario, 'blind_zone_gate', idx, 0.0);
q_pos = scenario.q_pos(idx);
q_link = scenario.q_link(idx);
urgency = scenario.urgency(idx);
is_nlos = scenario.is_nlos(idx);

max_blind = max(blind);
min_q_pos = min(q_pos);
min_q_link = min(q_link);
max_urgency = max(urgency);
nlos_ratio = mean(is_nlos);

emg_thr = paramsafe_local(params, 'utility_emergency_urgency_threshold', 0.80);
blind_thr = paramsafe_local(params, 'step66_selector_blind_threshold', 0.58);
qpos_thr = paramsafe_local(params, 'step66_selector_qpos_threshold', 0.50);
nlos_thr = paramsafe_local(params, 'step66_selector_nlos_ratio_threshold', 0.50);
link_thr = paramsafe_local(params, 'step66_selector_qlink_threshold', 0.42);

dense_blind_emergency = max_urgency >= emg_thr ...
    && max_blind >= blind_thr ...
    && (min_q_pos <= qpos_thr || nlos_ratio >= nlos_thr);

hard_link_emergency = max_urgency >= emg_thr ...
    && min_q_link <= link_thr ...
    && max_blind >= paramsafe_local(params, 'step66_selector_link_blind_threshold', 0.45);

pos_degraded_emergency = max_urgency >= emg_thr ...
    && min_q_pos <= paramsafe_local(params, 'step66_selector_emg_qpos_threshold', 0.58) ...
    && max_blind >= paramsafe_local(params, 'step66_selector_emg_blind_threshold', 0.38);

fallback = dense_blind_emergency || hard_link_emergency || pos_degraded_emergency;
if dense_blind_emergency
    reason = "fallback_dense_blind_emergency";
elseif hard_link_emergency
    reason = "fallback_hard_link_emergency";
elseif pos_degraded_emergency
    reason = "fallback_pos_degraded_emergency";
else
    reason = "use_budgeted_mpc";
end
end

function values = get_series_local(scenario, field_name, idx, default_value)
if isfield(scenario, field_name)
    values = scenario.(field_name)(idx);
else
    values = repmat(default_value, size(idx));
end
end

function value = paramsafe_local(params, name, default)
if isfield(params, name)
    value = params.(name);
else
    value = default;
end
end
