function main_step72_dpp_cap_sweep_parallel(num_seeds)
%MAIN_STEP72_DPP_CAP_SWEEP_PARALLEL Sweep the queue cap (at V=2) to locate the
%   DPP operating point that matches v6 timely, over many seeds in parallel.

if nargin < 1 || isempty(num_seeds), num_seeds = 20; end
seeds = 1:num_seeds;
caps = [20, 30, 40, 60];
nC = numel(caps);

[~, params] = evalc('get_forest_geometry_mainline_params()');
scenarios = cell(num_seeds, 1);
for si = 1:num_seeds
    p = params; p.random_seed = seeds(si);
    [~, scenarios{si}] = evalc('generate_step9_scenario(p)');
end

v6T = zeros(num_seeds, 1); v6C = zeros(num_seeds, 1);
dppT = zeros(num_seeds, nC); dppC = zeros(num_seeds, nC);

ensure_dpp_pool();   % use all physical cores for the seed-parallel sweep

parfor si = 1:num_seeds
    sc = scenarios{si};
    sd = seeds(si);
    % Tables are invariant to the cap; build once per seed (rng-free, so it does
    % not perturb the common-random-numbers stream) and reuse across the sweep.
    cache = build_dpp_action_tables(sc, params);
    rng(sd);                                  % common random numbers
    r6 = run_step9_proposed_method(sc, params);
    v6T(si) = mean(r6.delivery.deadline_hit);
    v6C(si) = mean(r6.delivery.tx_cost);
    tt = zeros(1, nC); cc = zeros(1, nC);
    for ci = 1:nC
        p = params; p.dpp_V = 2.0; p.dpp_queue_max = caps(ci);
        rng(sd);                              % same draws as v6 (CRN)
        r = run_step9_proposed_method_dpp(sc, p, cache);
        tt(ci) = mean(r.delivery.deadline_hit);
        cc(ci) = mean(r.delivery.tx_cost);
    end
    dppT(si, :) = tt; dppC(si, :) = cc;
end

fprintf('v6: Timely=%.4f  Cost=%.4f\n', mean(v6T), mean(v6C));
Cap = caps(:);
Timely = mean(dppT)';
Cost = mean(dppC)';
dTimely = Timely - mean(v6T);
dCost = Cost - mean(v6C);
T = table(Cap, Timely, Cost, dTimely, dCost);
disp('=== DPP V=2 cap sweep vs v6 (parallel) ===');
disp(T);
fprintf('Pick the smallest cap with dTimely >= 0 (matches/exceeds v6 timely); note its dCost.\n');
end
