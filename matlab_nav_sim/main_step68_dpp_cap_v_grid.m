function main_step68_dpp_cap_v_grid()
%MAIN_STEP68_DPP_CAP_V_GRID Tune the DPP max-multiplier cap and knob V against
%   the frozen-lambda v6 reference on the hard forest-geometry scene.
%
%   The reliability virtual queue over-provisions when dpp_queue_max is too loose
%   (the multiplier integrates the predictor/simulator timely gap). This grid
%   finds a (V, cap) that matches or beats v6's cost at equal reliability.

seed = 7;
params = get_forest_geometry_mainline_params();
params.random_seed = seed;
scenario = generate_step9_scenario(params);
idx_pd = (scenario.t >= 68) & (scenario.t < 90);

% Action tables are invariant to (V, cap); build once and reuse across the whole
% grid instead of rebuilding the dominant cost at each of the V x cap points.
cache = build_dpp_action_tables(scenario, params);

% --- v6 reference ---
r6 = run_step9_proposed_method(scenario, params);
v6_timely = mean(r6.delivery.deadline_hit);
v6_cost = mean(r6.delivery.tx_cost);
v6_pd = mean(r6.delivery.deadline_hit(idx_pd));
fprintf('Reference Risk-constrained-v6: Timely=%.4f  PosDegTimely=%.4f  AvgTxCost=%.4f\n\n', ...
    v6_timely, v6_pd, v6_cost);

% --- DPP (V, cap) grid ---
V_grid = [0.5, 1.0, 2.0, 4.0];
cap_grid = [3.0, 6.0, 10.0, 20.0, 50.0];

rowV = [];
rowCap = [];
Timely = [];
PosDegTimely = [];
AvgTxCost = [];
QbarRel = [];
BeatsV6 = strings(0, 1);   % "<=cost & >=timely" vs v6

for vi = 1:numel(V_grid)
    for ci = 1:numel(cap_grid)
        p = params;
        p.dpp_V = V_grid(vi);
        p.dpp_queue_max = cap_grid(ci);
        r = run_step9_proposed_method_dpp(scenario, p, cache);
        tm = mean(r.delivery.deadline_hit);
        ct = mean(r.delivery.tx_cost);
        pd = mean(r.delivery.deadline_hit(idx_pd));
        qr = mean(r.policy.queue_trace(:, 1));

        rowV(end+1, 1) = V_grid(vi);          %#ok<AGROW>
        rowCap(end+1, 1) = cap_grid(ci);      %#ok<AGROW>
        Timely(end+1, 1) = tm;                %#ok<AGROW>
        PosDegTimely(end+1, 1) = pd;          %#ok<AGROW>
        AvgTxCost(end+1, 1) = ct;             %#ok<AGROW>
        QbarRel(end+1, 1) = qr;               %#ok<AGROW>
        if ct <= v6_cost + 1e-9 && tm >= v6_timely - 1e-9
            BeatsV6(end+1, 1) = "DOMINATES"; %#ok<AGROW>
        elseif ct <= v6_cost + 1e-9
            BeatsV6(end+1, 1) = "cheaper";   %#ok<AGROW>
        else
            BeatsV6(end+1, 1) = "-";         %#ok<AGROW>
        end
    end
end

Tg = table(rowV, rowCap, Timely, PosDegTimely, AvgTxCost, QbarRel, BeatsV6, ...
    'VariableNames', {'V', 'QueueCap', 'Timely', 'PosDegTimely', 'AvgTxCost', 'QbarRel', 'vsV6'});
disp('=== DPP (V, cap) grid on forest scene; vsV6: cheaper at >= v6 timely = DOMINATES ===');
disp(Tg);
fprintf('v6 reference cost=%.4f timely=%.4f -- look for rows with AvgTxCost below this at similar Timely.\n', ...
    v6_cost, v6_timely);
end
