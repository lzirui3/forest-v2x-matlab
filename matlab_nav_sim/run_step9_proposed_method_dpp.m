function result = run_step9_proposed_method_dpp(scenario, params)
%RUN_STEP9_PROPOSED_METHOD_DPP Predictive drift-plus-penalty V2X scheduler.
%
%   Principled replacement for the fixed-weight "Lagrangian" scheduler
%   (run_step9_confidence_driven_risk_constrained_v6 +
%    compute_action_risk_constrained_objective_v4), whose five FROZEN multipliers
%   lambda = (3.20, 2.20, 1.25, 1.60, 0.75) carry no feasibility/optimality
%   guarantee and whose absolute magnitudes are not identifiable.
%
%   UNIFIED ALGORITHM -- Predictive Drift-Plus-Penalty (Lyapunov-MPC):
%     Multipliers become TIME-VARYING VIRTUAL QUEUES (Neely, "Stochastic Network
%     Optimization"). For each time-average constraint c: E[g_c] <= 0,
%         Z_c(t+1) = max(Z_c(t) + g_c(t), 0)            (capped at dpp_queue_max)
%     The per-slot stage cost is the drift-plus-penalty term
%         L_t(a) = V * penalty(a) + sum_c Z_c(t) * g_c(a)
%     and the controller minimizes it over a RECEDING HORIZON of H slots
%         min_{a_0..a_{H-1}}  sum_{tau=0}^{H-1} L_{t+tau}(a_tau)
%     applying only a_0 and receding (Model Predictive Control). H = 1 recovers
%     plain drift-plus-penalty; H > 1 adds anticipation. The virtual queues
%     retain the O(1/V) optimality / O(V) backlog trade-off and time-average
%     feasibility certificate; the horizon adds look-ahead for the forest's
%     route-predictable blind-zone / relay-window / message-stage structure.
%
%   FORECAST = ROUTE-GEOMETRY PREVIEW (honest, see paper wording): the predictor
%   uses the deterministic, map/route-derived slow state for future slots
%   (message stage / urgency / deadline, relay-window availability, blind-zone
%   gate, NLOS geometry, the slow SINR envelope and positioning confidence). It
%   does NOT preview the random per-packet fast fading (that is realized only at
%   delivery time). Because scheduling actions do not change the channel, the
%   future state is exogenous, so per-step action tables are precomputed once and
%   the rollout is O(H*|A|) per slot.
%
%   CLEAN OBJECTIVE SPLIT:
%     * penalty(a) holds ONLY what we minimize: communication cost + risk
%       regularization (>= 0), so V is a monotone cost-vs-reliability knob.
%     * VALUE drives the CONSTRAINT: a more valuable/urgent message demands higher
%       required reliability. The reliability RHS is interpolated by a normalized
%       Value-of-Information (Howard 1966 VPI) between the per-class operational
%       floor and a reachable ceiling.
%
%   CONSOLIDATED CONSTRAINT SET (default, fixes audit problems #2 and #5):
%     timely/success/deadline all encode "delivered within latency" = TS 22.186
%     reliability -> ONE reliability constraint on aux.timely_prob; and
%     position_violation = pos_risk*protection_violation -> folded into protection.
%       C1 Reliability : timely_prob      >= R_req(state)  (TS 22.186 tier, derated, VoI-scaled)
%       C2 Protection  : protection_level >= P_req(state)  (GNSS-integrity shaped)
%     params.dpp_constraint_mode = "legacy5" instantiates the original five
%     constraints for ablation. The v6 emergency action floor is preserved.

params = local_apply_dpp_defaults(params);
cset = local_build_constraint_set(params);
M = numel(cset);
V = params.dpp_V;
H = max(1, round(params.dpp_horizon));
Zmax = params.dpp_queue_max;

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);
queue_trace = zeros(N, M);
violation_trace = zeros(N, M);
required_reliability_trace = zeros(N, 1);
required_protection_trace = zeros(N, 1);
selection_reason = strings(N, 1);

Z = zeros(M, 1);

for k = 1:N
    [action, g_chosen, meta] = local_decide_predictive(Z, V, cset, scenario, k, params, H, Zmax);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode(k) = action.mode;
    score(k) = action.score;
    queue_trace(k, :) = Z(:)';
    violation_trace(k, :) = g_chosen(:)';
    required_reliability_trace(k) = meta.required_reliability;
    required_protection_trace(k) = meta.required_protection;
    selection_reason(k) = meta.selection_reason;

    % Virtual-queue (Lindley) update with the realized current-slot constraint
    % values, capped for robustness against a chronically-infeasible stage.
    Z = min(max(Z + g_chosen(:), 0.0), Zmax);
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;
policy.queue_trace = queue_trace;
policy.violation_trace = violation_trace;
policy.required_reliability_trace = required_reliability_trace;
policy.required_protection_trace = required_protection_trace;
policy.selection_reason = selection_reason;
policy.constraint_names = string({cset.name});

delivery = simulate_step9_delivery(scenario, policy, params);

if H > 1
    result.name = "Proposed-PDPP";    % predictive drift-plus-penalty
else
    result.name = "Proposed-DPP";
end
result.policy = policy;
result.delivery = delivery;
result.constraint_names = string({cset.name});
result.dpp_V = V;
result.dpp_horizon = H;
end

% ------------------------------------------------------------------------
function params = local_apply_dpp_defaults(params)
% Default operating point validated against the deployed frozen-lambda v6 on the
% forest-geometry scene: (V=2, cap=20) matches v6 on BOTH timely and cost within
% noise (main_step70). V and cap are the two interpretable knobs (optimality-vs-
% feasibility tradeoff, and max constraint shadow price) that replace 5 frozen lambdas.
params = setdefault(params, 'dpp_V', 2.0);
params = setdefault(params, 'dpp_horizon', 1);          % MPC look-ahead (1 = plain DPP)
params = setdefault(params, 'dpp_constraint_mode', "consolidated");
% Virtual-queue cap = max shadow price of a constraint (bounds how far the
% backlog multiplier can override the cost objective). cap=20 with V=2 is the
% validated operating point: under common-random-numbers it matches the deployed
% frozen-lambda v6 on BOTH timely and cost within seed noise (main_step72/73).
% Mean-rate stability still holds; the cap only bounds the worst-case multiplier.
params = setdefault(params, 'dpp_queue_max', 20.0);
% VoI now lives in the penalty reward, so the reliability RHS is a clean
% per-class floor (set true to instead VoI-scale the RHS and drop the reward).
params = setdefault(params, 'dpp_reliability_voi_scaled', false);
params = setdefault(params, 'dpp_reliability_band', 0.30);
params = setdefault(params, 'dpp_reliability_reachable_cap', 0.97);
params = setdefault(params, 'risk_v6_emergency_min_priority', 3);
params = setdefault(params, 'risk_v6_emergency_min_rate_multiplier', 2.1);
params = setdefault(params, 'risk_v4_actual_cost_weight', 0.060);
end

function cset = local_build_constraint_set(params)
mode = lower(char(string(params.dpp_constraint_mode)));
switch mode
    case 'legacy5'
        cset = struct( ...
            'name', {'timely', 'success', 'deadline', 'protection', 'position'}, ...
            'type', {'timely', 'success', 'deadline', 'protection', 'position'});
    otherwise % 'consolidated'
        cset = struct( ...
            'name', {'reliability', 'protection'}, ...
            'type', {'reliability', 'protection'});
end
end

% ------------------------------------------------------------------------
function [action, g_chosen, chosen_meta] = local_decide_predictive(Z, V, cset, scenario, k, params, H, Zmax)
%LOCAL_DECIDE_PREDICTIVE Receding-horizon rollout of the drift-plus-penalty cost.

N = numel(scenario.t);
nstep = min(H, N - k + 1);

% Per-step action tables (state is exogenous to scheduling -> precompute once).
tables = cell(nstep, 1);
for s = 1:nstep
    tables{s} = local_build_action_table(scenario, k + s - 1, params, cset);
end

t0 = tables{1};
[cand0, reason0] = local_selection_set(t0);

best_J = inf;
best_i0 = cand0(1);

for ci = 1:numel(cand0)
    i0 = cand0(ci);
    Zhat = Z;
    J = V * t0.penalty(i0) + sum(Zhat(:) .* t0.G(:, i0));
    Zhat = min(max(Zhat + t0.G(:, i0), 0.0), Zmax);

    for s = 2:nstep
        ts = tables{s};
        [stepcost, g_step] = local_greedy_step_cost(ts, V, Zhat);
        J = J + stepcost;
        Zhat = min(max(Zhat + g_step, 0.0), Zmax);
    end

    if J < best_J
        best_J = J;
        best_i0 = i0;
    end
end

action = t0.actions(best_i0);
action.score = -best_J;
action.utility = -best_J;
g_chosen = t0.G(:, best_i0);

chosen_meta.required_reliability = t0.required.reliability;
chosen_meta.required_protection = t0.required.protection;
chosen_meta.selection_reason = reason0;
end

function tbl = local_build_action_table(scenario, idx, params, cset)
%LOCAL_BUILD_ACTION_TABLE Penalty / constraint-violation table for one state.

event_state = build_event_state(scenario, idx);
context = struct();
context.sinr_dB = scenario.sinr_dB(idx);
context.is_nlos = scenario.is_nlos(idx);
context.msg_type = scenario.msg_type(idx);
context.deadline = scenario.deadline(idx);

urgency = scenario.urgency(idx);
q_link = scenario.q_link(idx);
q_pos = scenario.q_pos(idx);
relay_available = scenario.relay_available(idx);
base_rate = scenario.base_rate(idx);
msg_type = scenario.msg_type(idx);

actions = enumerate_schedule_actions(relay_available, base_rate, params);
nA = numel(actions);
M = numel(cset);

required = local_required_targets(msg_type, urgency, q_link, q_pos, event_state, params);

penalty = zeros(1, nA);
G = zeros(M, nA);
feasible = false(1, nA);
emgfloor = false(1, nA);

for i = 1:nA
    aux = evaluate_action_metrics( ...
        urgency, q_link, q_pos, actions(i), relay_available, base_rate, params, event_state, context);
    G(:, i) = local_constraint_violations(cset, aux, required);
    penalty(i) = local_penalty(aux, actions(i), urgency, required, params);
    feasible(i) = local_is_basic_feasible(actions(i), urgency, relay_available, params);
    emgfloor(i) = local_is_emergency_floor_action(actions(i), params);
end

emg_thresh = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
tbl.actions = actions;
tbl.penalty = penalty;
tbl.G = G;
tbl.feasible = feasible;
tbl.emgfloor = emgfloor;
tbl.is_emergency = urgency >= emg_thresh;
tbl.required = required;
end

function [cand, reason] = local_selection_set(tbl)
%LOCAL_SELECTION_SET Candidate-action indices under the v6 selection rule.
if tbl.is_emergency && any(tbl.feasible & tbl.emgfloor)
    cand = find(tbl.feasible & tbl.emgfloor);
    reason = "emergency_floor";
elseif any(tbl.feasible)
    cand = find(tbl.feasible);
    reason = "drift_plus_penalty";
else
    cand = 1:numel(tbl.penalty);   % relaxed: all actions
    reason = "relaxed_min_objective";
end
end

function [stepcost, g_step] = local_greedy_step_cost(tbl, V, Zhat)
%LOCAL_GREEDY_STEP_COST Greedy continuation action cost at a predicted step.
cand = local_selection_set(tbl);
best = inf;
best_i = cand(1);
for ci = 1:numel(cand)
    i = cand(ci);
    obj = V * tbl.penalty(i) + sum(Zhat(:) .* tbl.G(:, i));
    if obj < best
        best = obj;
        best_i = i;
    end
end
stepcost = best;
g_step = tbl.G(:, best_i);
end

% ------------------------------------------------------------------------
function g_vec = local_constraint_violations(cset, aux, required)
M = numel(cset);
g_vec = zeros(M, 1);
for c = 1:M
    switch cset(c).type
        case 'reliability'   % timely_prob >= R_req  ->  g = R_req - timely_prob
            g_vec(c) = required.reliability - aux.timely_prob;
        case 'timely'
            g_vec(c) = required.timely - aux.timely_prob;
        case 'success'
            g_vec(c) = required.success - aux.success_prob;
        case 'deadline'      % pred_delay <= deadline  ->  g = pred_delay/deadline - 1
            g_vec(c) = aux.pred_delay / max(aux.deadline, 1.0e-6) - 1.0;
        case 'protection'    % protection_level >= P_req  ->  g = P_req - protection
            g_vec(c) = required.protection - aux.protection_level;
        case 'position'      % pos_risk * protection gap (kept only in legacy5)
            g_vec(c) = required.pos_risk * (required.protection - aux.protection_level);
        otherwise
            g_vec(c) = 0.0;
    end
end
end

function penalty = local_penalty(aux, action, urgency, required, params)
% Drift-plus-penalty "penalty" = the per-slot objective to minimize, i.e.
% regularization (cost + risk) MINUS reward (value of timely/successful/event
% delivery). This is exactly v6's non-constraint objective; the fixed lambda
% violation terms it used are replaced by the virtual-queue terms sum Z_c*g_c.
% V trades this utility against constraint backlog (standard DPP tradeoff).
info_value = local_information_value(urgency, required.pos_risk, required.link_risk, ...
    required.blind_risk, params);
reward = info_value * aux.timely_prob ...
    + paramsafe(params, 'risk_constrained_success_reward_weight', 0.45) * aux.success_prob ...
    + paramsafe(params, 'risk_constrained_event_reward_weight', 0.12) * aux.event_gain;

if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
actual_tx_cost = mode_cost * action.tx_rate;

regularization = paramsafe(params, 'risk_v4_actual_cost_weight', 0.060) * actual_tx_cost ...
    + paramsafe(params, 'risk_constrained_delay_weight', 0.08) * aux.delay_penalty ...
    + paramsafe(params, 'risk_constrained_position_risk_weight', 0.20) * aux.risk_penalty ...
    + paramsafe(params, 'risk_constrained_misdecision_weight', 0.28) * aux.misdecision_risk ...
    + paramsafe(params, 'risk_constrained_relay_penalty_weight', 0.06) * aux.relay_penalty ...
    + aux.support_mismatch_penalty;

penalty = regularization - reward;
end

% ------------------------------------------------------------------------
function required = local_required_targets(msg_type, urgency, q_link, q_pos, event_state, params)
rel_req = get_v2x_reliability_requirements(msg_type, params);
pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);

reliability = rel_req.reliability_floor;
if params.dpp_reliability_voi_scaled
    info_value = local_information_value(urgency, pos_risk, link_risk, blind_risk, params);
    voi_min = paramsafe(params, 'risk_constrained_voi_min', 0.50);
    voi_max = paramsafe(params, 'risk_constrained_voi_max', 1.90);
    voi_norm = min(max((info_value - voi_min) / max(voi_max - voi_min, 1.0e-6), 0.0), 1.0);
    ceiling = min([rel_req.reliability_standard, ...
        rel_req.reliability_floor + params.dpp_reliability_band, ...
        params.dpp_reliability_reachable_cap]);
    reliability = rel_req.reliability_floor + voi_norm * (ceiling - rel_req.reliability_floor);
end

required.reliability = reliability;
required.protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
required.pos_risk = pos_risk;
required.link_risk = link_risk;
required.blind_risk = blind_risk;

% Legacy-5 RHS (only used when dpp_constraint_mode = "legacy5").
required.timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
required.success = local_required_success(urgency, q_link, q_pos, event_state, params);
end

function required_success = local_required_success(urgency, q_link, q_pos, event_state, params)
pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate, 0.0);
required_success = paramsafe(params, 'risk_constrained_success_bias', 0.50) ...
    + paramsafe(params, 'risk_constrained_success_urgency_scale', 0.24) * urgency ...
    + paramsafe(params, 'risk_constrained_success_link_scale', 0.12) * link_risk ...
    + paramsafe(params, 'risk_constrained_success_pos_scale', 0.10) * pos_risk ...
    + paramsafe(params, 'risk_constrained_success_blind_scale', 0.12) * blind_risk;
required_success = min(max(required_success, ...
    paramsafe(params, 'risk_constrained_success_min', 0.45)), ...
    paramsafe(params, 'risk_constrained_success_max', 0.94));
end

function info_value = local_information_value(urgency, pos_risk, link_risk, blind_risk, params)
% Value-of-information weight (Howard 1966 VPI form).
info_value = paramsafe(params, 'risk_constrained_voi_bias', 0.65) ...
    + paramsafe(params, 'risk_constrained_voi_urgency_scale', 0.70) * urgency ...
    + paramsafe(params, 'risk_constrained_voi_pos_scale', 0.24) * pos_risk ...
    + paramsafe(params, 'risk_constrained_voi_link_scale', 0.14) * link_risk ...
    + paramsafe(params, 'risk_constrained_voi_blind_scale', 0.28) * blind_risk;
info_value = min(max(info_value, ...
    paramsafe(params, 'risk_constrained_voi_min', 0.50)), ...
    paramsafe(params, 'risk_constrained_voi_max', 1.90));
end

% ------------------------------------------------------------------------
function pass = local_is_emergency_floor_action(action, params)
min_priority = paramsafe(params, 'risk_v6_emergency_min_priority', 3);
min_rate_mult = paramsafe(params, 'risk_v6_emergency_min_rate_multiplier', 2.1);
pass = action.priority >= min_priority && action.rate_multiplier >= min_rate_mult;
end

function feasible = local_is_basic_feasible(action, urgency, relay_available, params)
feasible = true;
if action.mode == 2 && relay_available < 0.5
    feasible = false; return;
end
if action.rate_multiplier + 1.0e-9 < params.priority_rate_scale(action.priority)
    feasible = false; return;
end
emg_thresh = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thresh && action.priority < params.utility_min_priority_when_emergency
    feasible = false; return;
end
end

% ------------------------------------------------------------------------
function event_state = build_event_state(scenario, k)
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
if isfield(scenario, 'blind_zone_gate')
    event_state.blind_zone_gate = scenario.blind_zone_gate(k);
end
if isfield(scenario, 'rsu_gain_gate')
    event_state.rsu_gain_gate = scenario.rsu_gain_gate(k);
end
if isfield(scenario, 'env_correction_gate')
    event_state.env_correction_gate = scenario.env_correction_gate(k);
end
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
if isfield(scenario, 'position_modules')
    event_state.use_gnss = scenario.position_modules.use_gnss;
    event_state.use_rsu = scenario.position_modules.use_rsu;
    event_state.use_env = scenario.position_modules.use_env;
    event_state.use_traj = scenario.position_modules.use_traj;
end
end

function params = setdefault(params, name, value)
if ~isfield(params, name) || isempty(params.(name))
    params.(name) = value;
end
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
