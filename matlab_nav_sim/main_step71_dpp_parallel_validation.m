function main_step71_dpp_parallel_validation(num_seeds)
%MAIN_STEP71_DPP_PARALLEL_VALIDATION Parallel (parfor) multi-seed validation of
%   the predictive DPP at its default operating point vs the frozen-lambda v6.
%   Requires Parallel Computing Toolbox; start a pool first (parpool).
%
%   Scenarios are built serially (evalc suppresses the calibration table; evalc
%   is not allowed inside parfor), then the per-seed method runs go in parallel.

if nargin < 1 || isempty(num_seeds)
    num_seeds = 20;
end
seeds = 1:num_seeds;

mnames = ["Fixed", "Link-delay", "v6 (frozen-lambda)", "DPP (default V2,cap20)", "PDPP H3 (default)"];
nM = numel(mnames);

% --- build scenarios serially (suppress calibration disp) ---
[~, params] = evalc('get_forest_geometry_mainline_params()');
scenarios = cell(num_seeds, 1);
for si = 1:num_seeds
    p = params; p.random_seed = seeds(si);
    [~, scenarios{si}] = evalc('generate_step9_scenario(p)');
end

Timely = zeros(num_seeds, nM);
Cost = zeros(num_seeds, nM);
PosDeg = zeros(num_seeds, nM);

ensure_dpp_pool();   % use all physical cores for the seed-parallel sweep

parfor si = 1:num_seeds
    rng(seeds(si));   % reproducible delivery randomness per seed
    scenario = scenarios{si};
    idx_pd = (scenario.t >= 68) & (scenario.t < 90);
    p_pdpp = params; p_pdpp.dpp_horizon = 3;
    % Both DPP variants share one rng-free table cache for this seed (the table
    % is invariant to dpp_horizon, and building it does not touch the rng stream).
    cache = build_dpp_action_tables(scenario, params);

    res = { ...
        run_step9_baseline_fixed(scenario, params), ...
        run_step9_baseline_link_delayaware(scenario, params), ...
        run_step9_proposed_method(scenario, params), ...
        run_step9_proposed_method_dpp(scenario, params, cache), ...
        run_step9_proposed_method_dpp(scenario, p_pdpp, cache)};

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

T = table(mnames(:), mean(Timely)', std(Timely)', mean(Cost)', std(Cost)', mean(PosDeg)', ...
    'VariableNames', {'Method', 'TimelyMean', 'TimelyStd', 'CostMean', 'CostStd', 'PosDegMean'});
pl = gcp('nocreate'); nw = 0; if ~isempty(pl), nw = pl.NumWorkers; end
fprintf('=== Parallel forest validation (%d seeds, %d workers) ===\n', num_seeds, nw);
disp(T);

iv6 = 3; idpp = 4;
d_t = Timely(:, idpp) - Timely(:, iv6);
d_c = Cost(:, idpp) - Cost(:, iv6);
fprintf('Paired (DPP default - v6): dTimely=%.4f+/-%.4f  dCost=%.4f+/-%.4f\n', ...
    mean(d_t), std(d_t), mean(d_c), std(d_c));
[~, pval] = local_ttest(d_t);
fprintf('Paired t-test on timely: p=%.3f (p>0.05 => statistical parity with v6)\n', pval);
end

function [h, p] = local_ttest(d)
n = numel(d); m = mean(d); s = std(d);
if s <= 0, h = 0; p = 1.0; return; end
t = m / (s / sqrt(n));
p = 2 * (0.5 * betainc((n-1)/((n-1)+t^2), (n-1)/2, 0.5));
h = double(p < 0.05);
end
