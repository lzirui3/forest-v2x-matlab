function main_step67_dpp_forest_diagnostic()
%MAIN_STEP67_DPP_FOREST_DIAGNOSTIC Exercise the predictive DPP on the hard
%   forest-geometry-calibrated scene, where the reliability/protection
%   constraints actually bind (the easy mainline scene is too benign).
%
%   Prints: overall comparison, hard-stage (LinkDeg_Emerg / PosDeg_Emerg)
%   timely rates, DPP queue dynamics (does reliability bind now?), and a V sweep.

seed = 7;
params = get_forest_geometry_mainline_params();
params.random_seed = seed;
scenario = generate_step9_scenario(params);

% Every DPP run below (3 named runs + the queue-dynamics run + the V sweep) is on
% this ONE scenario, so build the action-table cache ONCE and reuse it -- the
% tables are invariant to V / horizon. dpp_parallel_tables parallelises the single
% build across slots IF a pool already exists; it does NOT force one to start, so
% the diagnostic stays fast when run standalone.
cache_params = params;
cache_params.dpp_parallel_tables = true;
cache = build_dpp_action_tables(scenario, cache_params);

% --- methods ---
results = {};
results{end+1} = run_step9_baseline_fixed(scenario, params);
results{end+1} = run_step9_baseline_link_delayaware(scenario, params);
results{end+1} = run_step9_proposed_method(scenario, params);            % frozen-lambda v6

p1 = params; p1.dpp_V = 1.0;
r = run_step9_proposed_method_dpp(scenario, p1, cache); r.name = "DPP-V1.0"; results{end+1} = r;

p2 = params; p2.dpp_V = 0.5;
r = run_step9_proposed_method_dpp(scenario, p2, cache); r.name = "DPP-V0.5"; results{end+1} = r;

p3 = params; p3.dpp_V = 1.0; p3.dpp_horizon = 3;
r = run_step9_proposed_method_dpp(scenario, p3, cache); r.name = "PDPP-H3"; results{end+1} = r;

T = evaluate_step9_metrics(scenario, results);
disp('=== Forest-geometry overall (seed 7) ===');
disp(T);

% --- hard-stage breakdown ---
stages = define_step9_stage_masks(scenario.t);
nm = numel(results);
Method = strings(nm, 1);
LinkDegEmerg_Timely = zeros(nm, 1);
PosDegEmerg_Timely = zeros(nm, 1);
PosDegEmerg_EmgTimely = zeros(nm, 1);
PosDegEmerg_TxCost = zeros(nm, 1);
for i = 1:nm
    m = compute_step9_stage_metrics(scenario, results{i}, stages);
    Method(i) = results{i}.name;
    ld = m(strcmp({m.stage}, 'LinkDeg_Emerg'));
    pd = m(strcmp({m.stage}, 'PosDeg_Emerg'));
    LinkDegEmerg_Timely(i) = ld.timely_rate;
    PosDegEmerg_Timely(i) = pd.timely_rate;
    PosDegEmerg_EmgTimely(i) = pd.emergency_timely_rate;
    PosDegEmerg_TxCost(i) = pd.avg_tx_cost;
end
Ts = table(Method, LinkDegEmerg_Timely, PosDegEmerg_Timely, PosDegEmerg_EmgTimely, PosDegEmerg_TxCost);
disp('=== Hard-stage timely (where the method matters) ===');
disp(Ts);

% --- DPP queue dynamics on hard scene: does reliability bind now? ---
rd = run_step9_proposed_method_dpp(scenario, p1, cache);
fprintf(['DPP (V=1) on forest scene: Qbar_reliability=%.3f  Qbar_protection=%.3f  ' ...
    'reqReliabilityMean=%.3f  achievedTimelyMean=%.3f\n'], ...
    mean(rd.policy.queue_trace(:, 1)), mean(rd.policy.queue_trace(:, 2)), ...
    mean(rd.policy.required_reliability_trace), mean(rd.delivery.deadline_hit));
idx_pd = (scenario.t >= 68) & (scenario.t < 90);
fprintf('   In PosDeg_Emerg stage: Qbar_reliability=%.3f  achievedTimely=%.3f  reqReliability=%.3f\n', ...
    mean(rd.policy.queue_trace(idx_pd, 1)), mean(rd.delivery.deadline_hit(idx_pd)), ...
    mean(rd.policy.required_reliability_trace(idx_pd)));

% --- V sweep on the hard scene ---
V_grid = [0.25, 0.5, 1.0, 2.0, 4.0, 8.0];
nV = numel(V_grid);
Vc = V_grid(:);
TimelyRate = zeros(nV, 1);
PosDegTimely = zeros(nV, 1);
AvgTxCost = zeros(nV, 1);
Qbar_Reliability = zeros(nV, 1);
Qbar_Protection = zeros(nV, 1);
for i = 1:nV
    p = params; p.dpp_V = V_grid(i);
    rr = run_step9_proposed_method_dpp(scenario, p, cache);
    TimelyRate(i) = mean(rr.delivery.deadline_hit);
    PosDegTimely(i) = mean(rr.delivery.deadline_hit(idx_pd));
    AvgTxCost(i) = mean(rr.delivery.tx_cost);
    Qbar_Reliability(i) = mean(rr.policy.queue_trace(:, 1));
    Qbar_Protection(i) = mean(rr.policy.queue_trace(:, 2));
end
Tv = table(Vc, TimelyRate, PosDegTimely, AvgTxCost, Qbar_Reliability, Qbar_Protection, ...
    'VariableNames', {'V', 'TimelyRate', 'PosDegTimely', 'AvgTxCost', 'Qbar_Reliability', 'Qbar_Protection'});
disp('=== Forest-scene V sweep ===');
disp(Tv);
end
