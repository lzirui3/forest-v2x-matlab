function main_step69_dpp_multiseed()
%MAIN_STEP69_DPP_MULTISEED Multi-seed forest comparison: principled DPP vs the
%   hand-tuned frozen-lambda v6. The honest test of "principled single knob is
%   competitive" -- on the scenes v6 was tuned on -- with paired statistics.

num_seeds = 10;
seeds = 1:num_seeds;

method_names = ["Fixed"; "Link-delay"; "v6 (frozen-lambda)"; ...
    "DPP V1 cap10"; "DPP V1 cap20"; "PDPP H3 cap10"];
nM = numel(method_names);

Timely = zeros(num_seeds, nM);
Cost = zeros(num_seeds, nM);
PosDeg = zeros(num_seeds, nM);

% Parallelise over seeds. generate_step9_scenario reseeds rng(seed) internally,
% so each seed's random stream is independent of iteration order -> the parfor
% result is bit-identical to the original serial loop. The three DPP variants in
% each seed share ONE rng-free action-table cache instead of rebuilding it.
ensure_dpp_pool();

% Base params are deterministic and seed-independent: fetch once (evalc, which is
% disallowed inside parfor, only suppresses the calibration printout here) and
% broadcast. Each seed's scenario is built INSIDE the parfor so that
% generate_step9_scenario's internal rng(seed) reset reproduces the original
% serial loop's random stream -> the parfor result is bit-identical.
[~, base_params] = evalc('get_forest_geometry_mainline_params()');

parfor si = 1:num_seeds
    params = base_params;
    params.random_seed = seeds(si);
    scenario = generate_step9_scenario(params);
    idx_pd = (scenario.t >= 68) & (scenario.t < 90);
    cache = build_dpp_action_tables(scenario, params);

    res = { ...
        run_step9_baseline_fixed(scenario, params), ...
        run_step9_baseline_link_delayaware(scenario, params), ...
        run_step9_proposed_method(scenario, params), ...
        run_dpp(scenario, params, 1.0, 10, 1, cache), ...
        run_dpp(scenario, params, 1.0, 20, 1, cache), ...
        run_dpp(scenario, params, 1.0, 10, 3, cache)};

    tt = zeros(1, nM); cc = zeros(1, nM); pp = zeros(1, nM);
    for mi = 1:nM
        tt(mi) = mean(res{mi}.delivery.deadline_hit);
        cc(mi) = mean(res{mi}.delivery.tx_cost);
        pp(mi) = mean(res{mi}.delivery.deadline_hit(idx_pd));
    end
    Timely(si, :) = tt;
    Cost(si, :) = cc;
    PosDeg(si, :) = pp;
end

Method = method_names;
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

function r = run_dpp(scenario, params, V, cap, H, cache)
p = params;
p.dpp_V = V;
p.dpp_queue_max = cap;
p.dpp_horizon = H;
if nargin < 6
    cache = [];
end
r = run_step9_proposed_method_dpp(scenario, p, cache);
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
