function main_step74_dpp_heldout_generalization(num_seeds, pdr_mode)
%MAIN_STEP74_DPP_HELDOUT_GENERALIZATION Frozen-parameter generalization test.
%
%   All methods keep their FROZEN settings (v6: fixed lambdas; DPP: default
%   V=2,cap=20 set on the ForestGeometry tuning scene). We run them UNCHANGED on
%   held-out regimes (moderate forest, generic, and the framework's held-out
%   V2X-Seq scenes 10013/10007/10015) to test which generalizes. Parallel over
%   seeds with common random numbers.
%
%   pdr_mode: "sigmoid" (default, fast PER approx) or "per_lookup" (WiLabV2Xsim
%   PER tables, = step49/50 final-evidence delivery mode).

if nargin < 1 || isempty(num_seeds), num_seeds = 20; end
if nargin < 2 || strlength(string(pdr_mode)) == 0, pdr_mode = "sigmoid"; end
pdr_mode = string(pdr_mode);
fprintf('Held-out generalization, physical_pdr_mode=%s\n', pdr_mode);

regimes = { ...
    "ForestGeom (TUNING)", @() get_forest_geometry_mainline_params(); ...
    "Moderate (heldout)",  @() get_moderate_forest_geometry_mainline_params(); ...
    "Generic (heldout)",   @() get_default_step9_mainline_params(); ...
    "V2XSeq-10013 (heldout)", @() local_v2xseq_params("10013"); ...
    "V2XSeq-10007 (heldout)", @() local_v2xseq_params("10007"); ...
    "V2XSeq-10015 (heldout)", @() local_v2xseq_params("10015") };
nR = size(regimes, 1);

mnames = ["v6 (frozen-lambda)", "DPP (frozen V2,cap20)", "PDPP H3"];
nM = numel(mnames);

Regime = strings(nR, 1);
v6T = zeros(nR, 1); dppT = zeros(nR, 1); pdppT = zeros(nR, 1);
v6C = zeros(nR, 1); dppC = zeros(nR, 1); pdppC = zeros(nR, 1);
dT = zeros(nR, 1); pT = zeros(nR, 1); dC = zeros(nR, 1);

for ri = 1:nR
    Regime(ri) = regimes{ri, 1};
    [~, params] = evalc('feval(regimes{ri, 2})'); %#ok<ASGLU>
    params.physical_pdr_mode = pdr_mode;
    scenarios = cell(num_seeds, 1);
    for si = 1:num_seeds
        p = params; p.random_seed = si;
        [~, scenarios{si}] = evalc('generate_step9_scenario(p)');
    end

    T = zeros(num_seeds, nM); C = zeros(num_seeds, nM);
    parfor si = 1:num_seeds
        sc = scenarios{si};
        p_pdpp = params; p_pdpp.dpp_horizon = 3;
        runners = { ...
            @() run_step9_proposed_method(sc, params), ...
            @() run_step9_proposed_method_dpp(sc, params), ...
            @() run_step9_proposed_method_dpp(sc, p_pdpp)};
        tt = zeros(1, nM); cc = zeros(1, nM);
        for mi = 1:nM
            rng(si);                      % common random numbers across methods
            r = runners{mi}();
            tt(mi) = mean(r.delivery.deadline_hit);
            cc(mi) = mean(r.delivery.tx_cost);
        end
        T(si, :) = tt; C(si, :) = cc;
    end

    v6T(ri) = mean(T(:, 1)); dppT(ri) = mean(T(:, 2)); pdppT(ri) = mean(T(:, 3));
    v6C(ri) = mean(C(:, 1)); dppC(ri) = mean(C(:, 2)); pdppC(ri) = mean(C(:, 3));
    d = T(:, 2) - T(:, 1);
    dT(ri) = mean(d); dC(ri) = mean(C(:, 2) - C(:, 1));
    [~, pT(ri)] = local_ttest(d);
    fprintf('  [%d/%d] %s done\n', ri, nR, regimes{ri, 1});
end

Tbl = table(Regime, v6T, dppT, pdppT, v6C, dppC, dT, pT, dC, ...
    'VariableNames', {'Regime', 'v6_Timely', 'DPP_Timely', 'PDPP_Timely', ...
    'v6_Cost', 'DPP_Cost', 'dTimely_DPPminusV6', 'p_timely', 'dCost_DPPminusV6'});
disp('=== Held-out generalization: frozen v6 vs frozen DPP across regimes ===');
disp(Tbl);
try
    csv_name = sprintf('step74_dpp_heldout_generalization_%s.csv', pdr_mode);
    writetable(Tbl, csv_name);
    fprintf('Wrote %s\n', csv_name);
catch ME
    warning('Could not write CSV: %s', ME.message);
end
fprintf(['Reading: on every HELDOUT regime, if dTimely is within noise (p>0.05) or positive,\n' ...
    'the principled frozen DPP generalizes as well as / better than the hand-tuned v6.\n']);
end

function params = local_v2xseq_params(scene_id)
params = get_forest_geometry_mainline_params();
params.scenario_input = get_step9_v2xseq_config_by_scene(scene_id);
end

function [h, p] = local_ttest(d)
n = numel(d); m = mean(d); s = std(d);
if s <= 0, h = 0; p = 1.0; return; end
t = m / (s / sqrt(n));
p = betainc((n-1)/((n-1)+t^2), (n-1)/2, 0.5);
h = double(p < 0.05);
end
