function main_step66_dpp_smoke()
%MAIN_STEP66_DPP_SMOKE Smoke test for the drift-plus-penalty proposed method.
%
%   Demonstrates that run_step9_proposed_method_dpp:
%     (1) runs end-to-end on the mainline scenario,
%     (2) is competitive with the frozen-lambda v6 method,
%     (3) exposes a SINGLE knob V that traces the cost/reliability frontier,
%     (4) keeps the virtual queues mean-rate stable (time-average feasibility).

seed = 20240609;

params = get_default_step9_mainline_params();
params.random_seed = seed;
scenario = generate_step9_scenario(params);

% --- 1. Comparison vs baselines and the frozen-lambda v6 method ---
results = {};
results{end+1} = run_step9_baseline_fixed(scenario, params);
results{end+1} = run_step9_baseline_link_only(scenario, params);
results{end+1} = run_step9_proposed_method(scenario, params);          % frozen-lambda v6
results{end+1} = run_step9_proposed_method_dpp(scenario, params);      % drift-plus-penalty (consolidated)

params_legacy5 = params;
params_legacy5.dpp_constraint_mode = "legacy5";
r_legacy5 = run_step9_proposed_method_dpp(scenario, params_legacy5);
r_legacy5.name = "Proposed-DPP-legacy5";
results{end+1} = r_legacy5;

T = evaluate_step9_metrics(scenario, results);
disp('=== Method comparison (single seed) ===');
disp(T);

% --- 2. Single-knob V sweep: cost/reliability frontier + queue stability ---
V_grid = [0.25, 0.5, 1.0, 2.0, 4.0, 8.0];
nV = numel(V_grid);
Vcol = V_grid(:);
TimelyRate = zeros(nV, 1);
EmergencyTimelyRate = zeros(nV, 1);
AvgTxCost = zeros(nV, 1);
QueueMean_Reliability = zeros(nV, 1);
QueueMean_Protection = zeros(nV, 1);
ReqReliabilityMean = zeros(nV, 1);

idx_emg = scenario.msg_type == "emergency";
for i = 1:nV
    p = params;
    p.dpp_V = V_grid(i);
    r = run_step9_proposed_method_dpp(scenario, p);
    TimelyRate(i) = mean(r.delivery.deadline_hit);
    EmergencyTimelyRate(i) = mean(r.delivery.deadline_hit(idx_emg));
    AvgTxCost(i) = mean(r.delivery.tx_cost);
    QueueMean_Reliability(i) = mean(r.policy.queue_trace(:, 1));
    QueueMean_Protection(i) = mean(r.policy.queue_trace(:, 2));
    ReqReliabilityMean(i) = mean(r.policy.required_reliability_trace);
end

Tv = table(Vcol, TimelyRate, EmergencyTimelyRate, AvgTxCost, ...
    QueueMean_Reliability, QueueMean_Protection, ReqReliabilityMean, ...
    'VariableNames', {'V', 'TimelyRate', 'EmergencyTimelyRate', 'AvgTxCost', ...
    'QbarReliability', 'QbarProtection', 'ReqReliabilityMean'});
disp('=== Drift-plus-penalty V sweep (single knob replaces 5 frozen lambdas) ===');
disp(Tv);

fprintf(['Interpretation: larger V weights cost more -> lower TxCost, looser reliability;\n' ...
    'smaller V lets the virtual queues dominate -> higher reliability at higher cost.\n' ...
    'Bounded Qbar across the sweep indicates mean-rate stability (time-average feasibility).\n']);

% --- 3. Horizon sweep: H=1 (plain DPP) vs predictive (H>1) at fixed V ---
H_grid = [1, 3, 5];
nH = numel(H_grid);
Hcol = H_grid(:);
H_TimelyRate = zeros(nH, 1);
H_EmergencyTimelyRate = zeros(nH, 1);
H_AvgTxCost = zeros(nH, 1);
for i = 1:nH
    p = params;
    p.dpp_V = 1.0;
    p.dpp_horizon = H_grid(i);
    r = run_step9_proposed_method_dpp(scenario, p);
    H_TimelyRate(i) = mean(r.delivery.deadline_hit);
    H_EmergencyTimelyRate(i) = mean(r.delivery.deadline_hit(idx_emg));
    H_AvgTxCost(i) = mean(r.delivery.tx_cost);
end
Th = table(Hcol, H_TimelyRate, H_EmergencyTimelyRate, H_AvgTxCost, ...
    'VariableNames', {'Horizon', 'TimelyRate', 'EmergencyTimelyRate', 'AvgTxCost'});
disp('=== Predictive horizon sweep (H=1 is plain DPP; H>1 adds route-geometry look-ahead) ===');
disp(Th);
fprintf('If predictive helps, H>1 should raise EmergencyTimelyRate or cut AvgTxCost at equal reliability.\n');
end
