function main_step73_dpp_final_validation(num_seeds)
%MAIN_STEP73_DPP_FINAL_VALIDATION Definitive forest-scene comparison with COMMON
%   RANDOM NUMBERS: rng is reset to the same seed before each method so every
%   method sees identical delivery draws (fair, low-variance paired comparison).
%   Parallel over seeds.

if nargin < 1 || isempty(num_seeds), num_seeds = 20; end
seeds = 1:num_seeds;
mnames = ["Fixed", "Link-delay", "v6 (frozen-lambda)", "DPP (V2,cap20)", "PDPP H3"];
nM = numel(mnames);

[~, params] = evalc('get_forest_geometry_mainline_params()');
scenarios = cell(num_seeds, 1);
for si = 1:num_seeds
    p = params; p.random_seed = seeds(si);
    [~, scenarios{si}] = evalc('generate_step9_scenario(p)');
end

Timely = zeros(num_seeds, nM);
Cost = zeros(num_seeds, nM);
PosDeg = zeros(num_seeds, nM);

parfor si = 1:num_seeds
    sc = scenarios{si};
    idx_pd = (sc.t >= 68) & (sc.t < 90);
    p_pdpp = params; p_pdpp.dpp_horizon = 3;
    sd = seeds(si);

    runners = { ...
        @() run_step9_baseline_fixed(sc, params), ...
        @() run_step9_baseline_link_delayaware(sc, params), ...
        @() run_step9_proposed_method(sc, params), ...
        @() run_step9_proposed_method_dpp(sc, params), ...
        @() run_step9_proposed_method_dpp(sc, p_pdpp)};

    tt = zeros(1, nM); cc = zeros(1, nM); pp = zeros(1, nM);
    for mi = 1:nM
        rng(sd);                       % common random numbers across methods
        r = runners{mi}();
        tt(mi) = mean(r.delivery.deadline_hit);
        cc(mi) = mean(r.delivery.tx_cost);
        pp(mi) = mean(r.delivery.deadline_hit(idx_pd));
    end
    Timely(si, :) = tt; Cost(si, :) = cc; PosDeg(si, :) = pp;
end

T = table(mnames(:), mean(Timely)', std(Timely)', mean(Cost)', std(Cost)', mean(PosDeg)', ...
    'VariableNames', {'Method', 'TimelyMean', 'TimelyStd', 'CostMean', 'CostStd', 'PosDegMean'});
pl = gcp('nocreate'); nw = 0; if ~isempty(pl), nw = pl.NumWorkers; end
fprintf('=== Definitive forest validation, common random numbers (%d seeds, %d workers) ===\n', num_seeds, nw);
disp(T);

iv6 = 3; idpp = 4;
d_t = Timely(:, idpp) - Timely(:, iv6);
d_c = Cost(:, idpp) - Cost(:, iv6);
[~, pt] = local_ttest(d_t);
[~, pc] = local_ttest(d_c);
fprintf('Paired DPP-v6: dTimely=%+.4f+/-%.4f (p=%.3f)  dCost=%+.4f+/-%.4f (p=%.3f)\n', ...
    mean(d_t), std(d_t), pt, mean(d_c), std(d_c), pc);
fprintf('p>0.05 on timely => statistical parity with the hand-tuned heuristic.\n');
end

function [h, p] = local_ttest(d)
n = numel(d); m = mean(d); s = std(d);
if s <= 0, h = 0; p = 1.0; return; end
t = m / (s / sqrt(n));
p = betainc((n-1)/((n-1)+t^2), (n-1)/2, 0.5);
h = double(p < 0.05);
end
