function main_step70_dpp_cost_parity()
%MAIN_STEP70_DPP_COST_PARITY Find a (V, cap) where the principled DPP matches the
%   frozen-lambda v6 on BOTH timely and cost, over 10 forest seeds.

num_seeds = 10;
seeds = 1:num_seeds;

% Pre-build scenarios once (suppress the calibration table spam).
scenarios = cell(num_seeds, 1);
params0 = [];
for si = 1:num_seeds
    [~, p] = evalc('get_forest_geometry_mainline_params()');
    p.random_seed = seeds(si);
    [~, sc] = evalc('generate_step9_scenario(p)');
    scenarios{si} = sc;
    if si == 1, params0 = p; end
end

idx_pd = @(sc) (sc.t >= 68) & (sc.t < 90);

% v6 reference.
v6t = zeros(num_seeds, 1); v6c = zeros(num_seeds, 1);
for si = 1:num_seeds
    r = run_step9_proposed_method(scenarios{si}, params0);
    v6t(si) = mean(r.delivery.deadline_hit);
    v6c(si) = mean(r.delivery.tx_cost);
end
fprintf('v6 reference: Timely=%.4f+/-%.4f  Cost=%.4f+/-%.4f\n\n', ...
    mean(v6t), std(v6t), mean(v6c), std(v6c));

% DPP (V, cap) grid.
Vs = [1.0, 1.5, 2.0, 3.0];
caps = [5.0, 8.0, 12.0, 20.0];
rows = {};
for vi = 1:numel(Vs)
    for ci = 1:numel(caps)
        tt = zeros(num_seeds, 1); cc = zeros(num_seeds, 1);
        for si = 1:num_seeds
            p = params0;
            p.dpp_V = Vs(vi); p.dpp_queue_max = caps(ci); p.dpp_horizon = 1;
            r = run_step9_proposed_method_dpp(scenarios{si}, p);
            tt(si) = mean(r.delivery.deadline_hit);
            cc(si) = mean(r.delivery.tx_cost);
        end
        d_t = mean(tt) - mean(v6t);
        d_c = mean(cc) - mean(v6c);
        % parity = timely within 1 std of v6 AND cost <= v6
        if abs(d_t) <= std(v6t) && d_c <= 1e-9
            tag = "PARITY+";   % matches timely, cheaper-or-equal
        elseif abs(d_t) <= std(v6t)
            tag = "timely-ok";
        else
            tag = "-";
        end
        rows(end+1, :) = {Vs(vi), caps(ci), mean(tt), mean(cc), d_t, d_c, tag}; %#ok<AGROW>
    end
end

T = cell2table(rows, 'VariableNames', {'V', 'Cap', 'Timely', 'Cost', 'dTimely_vs_v6', 'dCost_vs_v6', 'verdict'});
disp('=== DPP (V, cap) vs v6 on both metrics (10 seeds) ===');
disp(T);
fprintf('Target: verdict=timely-ok with dCost_vs_v6 closest to 0 (or negative) = match v6 on both.\n');
end
