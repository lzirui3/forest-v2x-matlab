function main_step69_dpp_multiseed()
%MAIN_STEP69_DPP_MULTISEED Multi-seed forest comparison: principled DPP vs the
%   hand-tuned frozen-lambda v6. The honest test of "principled single knob is
%   competitive" -- on the scenes v6 was tuned on -- with paired statistics.

num_seeds = 10;
seeds = 1:num_seeds;

methods = { ...
    'Fixed',        @(sc, p) run_step9_baseline_fixed(sc, p); ...
    'Link-delay',   @(sc, p) run_step9_baseline_link_delayaware(sc, p); ...
    'v6 (frozen-lambda)', @(sc, p) run_step9_proposed_method(sc, p); ...
    'DPP V1 cap10', @(sc, p) run_dpp(sc, p, 1.0, 10, 1); ...
    'DPP V1 cap20', @(sc, p) run_dpp(sc, p, 1.0, 20, 1); ...
    'PDPP H3 cap10', @(sc, p) run_dpp(sc, p, 1.0, 10, 3) };
nM = size(methods, 1);

Timely = zeros(num_seeds, nM);
Cost = zeros(num_seeds, nM);
PosDeg = zeros(num_seeds, nM);

for si = 1:num_seeds
    params = get_forest_geometry_mainline_params();
    params.random_seed = seeds(si);
    scenario = generate_step9_scenario(params);
    idx_pd = (scenario.t >= 68) & (scenario.t < 90);
    for mi = 1:nM
        r = methods{mi, 2}(scenario, params);
        Timely(si, mi) = mean(r.delivery.deadline_hit);
        Cost(si, mi) = mean(r.delivery.tx_cost);
        PosDeg(si, mi) = mean(r.delivery.deadline_hit(idx_pd));
    end
end

Method = string(methods(:, 1));
TimelyMean = mean(Timely)';
TimelyStd = std(Timely)';
CostMean = mean(Cost)';
CostStd = std(Cost)';
PosDegMean = mean(PosDeg)';
T = table(Method, TimelyMean, TimelyStd, CostMean, CostStd, PosDegMean);
disp('=== Forest-geometry multi-seed (10 seeds): mean +/- std ===');
disp(T);

% Paired comparison: v6 vs DPP V1 cap10
iv6 = find(Method == "v6 (frozen-lambda)");
idpp = find(Method == "DPP V1 cap10");
d_timely = Timely(:, idpp) - Timely(:, iv6);
d_cost = Cost(:, idpp) - Cost(:, iv6);
fprintf('\nPaired (DPP V1 cap10 - v6) over %d seeds:\n', num_seeds);
fprintf('  Timely diff: mean=%.4f  std=%.4f  (negative = DPP slightly lower)\n', mean(d_timely), std(d_timely));
fprintf('  Cost   diff: mean=%.4f  std=%.4f  (negative = DPP cheaper)\n', mean(d_cost), std(d_cost));
[~, p_timely] = local_ttest(d_timely);
fprintf('  Paired t-test on Timely diff: p=%.3f  (p>0.05 => no significant timely gap)\n', p_timely);
fprintf('\nReading: if the timely gap is within noise (p>0.05) while DPP uses ONE knob\n');
fprintf('instead of 5 frozen lambdas and carries a feasibility certificate, that is the result.\n');
end

function r = run_dpp(scenario, params, V, cap, H)
p = params;
p.dpp_V = V;
p.dpp_queue_max = cap;
p.dpp_horizon = H;
r = run_step9_proposed_method_dpp(scenario, p);
end

function [h, p] = local_ttest(d)
% Minimal one-sample t-test against zero (avoids Stats Toolbox dependency).
n = numel(d);
m = mean(d);
s = std(d);
if s <= 0
    h = 0; p = 1.0; return;
end
tstat = m / (s / sqrt(n));
% two-sided p-value via Student-t CDF approximation (normal for n>=10 is close)
df = n - 1;
p = 2 * (1 - local_tcdf(abs(tstat), df));
h = double(p < 0.05);
end

function pc = local_tcdf(t, df)
% Student-t CDF via incomplete beta; fallback to normal approximation.
x = df / (df + t^2);
ib = local_betainc(x, df/2, 0.5);
pc = 1 - 0.5 * ib;
end

function y = local_betainc(x, a, b)
% Regularized incomplete beta via MATLAB builtin if available.
y = betainc(x, a, b);
end
