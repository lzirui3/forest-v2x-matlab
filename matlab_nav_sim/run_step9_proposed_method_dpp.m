function result = run_step9_proposed_method_dpp(scenario, params, cache)
%RUN_STEP9_PROPOSED_METHOD_DPP Predictive drift-plus-penalty V2X scheduler.
%
%   result = RUN_STEP9_PROPOSED_METHOD_DPP(scenario, params)
%   result = RUN_STEP9_PROPOSED_METHOD_DPP(scenario, params, cache)
%
%   The optional CACHE is a precomputed action-table struct from
%   build_dpp_action_tables(scenario, params). Because the per-slot action tables
%   depend only on the scenario state and the table-shaping params -- NOT on the
%   knobs dpp_V / dpp_queue_max / dpp_horizon -- a V/cap/horizon sweep over one
%   scenario can build the cache ONCE and pass it to every call, paying the
%   dominant table-building cost a single time. When omitted, the cache is built
%   internally (original behaviour). Results are numerically identical either way
%   (the table chain is rng-free; randomness is consumed only in the delivery
%   simulator, which is unchanged).
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
%
%   See also BUILD_DPP_ACTION_TABLES.

params = local_apply_dpp_defaults(params);
V = params.dpp_V;
H = max(1, round(params.dpp_horizon));
Zmax = params.dpp_queue_max;
mode = string(params.dpp_constraint_mode);

N = numel(scenario.t);
if nargin < 3 || isempty(cache)
    cache = build_dpp_action_tables(scenario, params);
else
    assert(cache.mode == mode, ...
        'DPP cache constraint-mode mismatch: cache="%s" params="%s".', cache.mode, mode);
    assert(cache.N == N, ...
        'DPP cache length mismatch: cache N=%d, scenario N=%d.', cache.N, N);
end
tables = cache.tables;
cset = cache.cset;
M = numel(cset);

priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode_out = zeros(N, 1);
score = zeros(N, 1);
queue_trace = zeros(N, M);
violation_trace = zeros(N, M);
required_reliability_trace = zeros(N, 1);
required_protection_trace = zeros(N, 1);
selection_reason = strings(N, 1);

Z = zeros(M, 1);

for k = 1:N
    [action, g_chosen, meta] = local_decide_predictive(Z, V, tables, k, H, Zmax);

    priority(k) = action.priority;
    tx_rate(k) = action.tx_rate;
    mode_out(k) = action.mode;
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
policy.mode = mode_out;
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
function [action, g_chosen, chosen_meta] = local_decide_predictive(Z, V, tables, k, H, Zmax)
%LOCAL_DECIDE_PREDICTIVE Receding-horizon rollout of the drift-plus-penalty cost.
%   Consumes the precomputed per-slot action tables (rng-free, state-exogenous):
%   tables{k} is the current slot, tables{k+1..k+H-1} the predicted look-ahead.

N = numel(tables);
nstep = min(H, N - k + 1);

t0 = tables{k};
[cand0, reason0] = local_selection_set(t0);

best_J = inf;
best_i0 = cand0(1);

for ci = 1:numel(cand0)
    i0 = cand0(ci);
    Zhat = Z;
    J = V * t0.penalty(i0) + sum(Zhat(:) .* t0.G(:, i0));
    Zhat = min(max(Zhat + t0.G(:, i0), 0.0), Zmax);

    for s = 2:nstep
        ts = tables{k + s - 1};
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

function params = setdefault(params, name, value)
if ~isfield(params, name) || isempty(params.(name))
    params.(name) = value;
end
end
