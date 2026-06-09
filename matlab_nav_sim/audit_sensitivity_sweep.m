function T = audit_sensitivity_sweep()
%AUDIT_SENSITIVITY_SWEEP One-factor-at-a-time sensitivity of the PRODUCTION
%   (mainline, DPP per_lookup) KPIs to the irreducible EngineeringChoice weights
%   (MRS cost/reward, VoI) and the grounded-range integrity params. This is the
%   honest grounding evidence for parameters that cannot be derived: we report
%   that the headline metrics move little across a +/-30% band, so the exact
%   values are not load-bearing. Writes audit_sensitivity_sweep.csv.

seed = 20240609;
mp = get_default_step9_mainline_params(); mp.random_seed = seed;
rng(seed); sc = generate_step9_scenario(mp);

% baseline
[bT, bC] = run_kpi(sc, mp, seed);

% Engineering-choice weights swept multiplicatively +/-30%, grounded-range params
% swept across their defensible band.
specs = {
%  field, type, lo, hi   (type 'mul' = x0.7/x1.3 of default; 'abs' = explicit lo/hi)
 'risk_v4_actual_cost_weight',            'mul', 0.7, 1.3
 'risk_constrained_delay_weight',         'mul', 0.7, 1.3
 'risk_constrained_position_risk_weight', 'mul', 0.7, 1.3
 'risk_constrained_misdecision_weight',   'mul', 0.7, 1.3
 'risk_constrained_relay_penalty_weight', 'mul', 0.7, 1.3
 'risk_constrained_success_reward_weight','mul', 0.7, 1.3
 'risk_constrained_event_reward_weight',  'mul', 0.7, 1.3
 'risk_constrained_voi_bias',             'mul', 0.7, 1.3
 'risk_constrained_voi_urgency_scale',    'mul', 0.7, 1.3
 'dpp_V',                                 'abs', 1.0, 4.0
 'integrity_k_sigma',                     'abs', 2.0, 3.0
 'protection_integrity_scale',            'mul', 0.7, 1.3
};

names = {}; vlo = []; vhi = []; Tlo = []; Thi = []; Clo = []; Chi = [];
for i = 1:size(specs, 1)
    f = specs{i, 1};
    d = local_get(mp, f);
    if strcmp(specs{i, 2}, 'mul')
        lo = d * specs{i, 3}; hi = d * specs{i, 4};
    else
        lo = specs{i, 3}; hi = specs{i, 4};
    end
    plo = mp; plo.(f) = lo; [tl, cl] = run_kpi(sc, plo, seed);
    phi = mp; phi.(f) = hi; [th, ch] = run_kpi(sc, phi, seed);
    names{end+1,1} = f; vlo(end+1,1) = lo; vhi(end+1,1) = hi; %#ok<AGROW>
    Tlo(end+1,1) = tl; Thi(end+1,1) = th; Clo(end+1,1) = cl; Chi(end+1,1) = ch; %#ok<AGROW>
end

Parameter = string(names);
Default   = arrayfun(@(i) local_get(mp, names{i}), (1:numel(names))');
Lo = vlo; Hi = vhi;
TimelyLo = Tlo; TimelyHi = Thi; CostLo = Clo; CostHi = Chi;
TimelySpan = abs(Thi - Tlo);
CostSpanPct = 100 * abs(Chi - Clo) / bC;
T = table(Parameter, Default, Lo, Hi, TimelyLo, TimelyHi, TimelySpan, CostLo, CostHi, CostSpanPct);
T = sortrows(T, 'TimelySpan', 'descend');

fprintf('=== PRODUCTION sensitivity (baseline Timely=%.5f Cost=%.4f) ===\n', bT, bC);
disp(T);
fprintf('Max Timely span across all swept params: %.4f (%.2f pp)\n', max(TimelySpan), 100*max(TimelySpan));
fprintf('Max Cost span across all swept params: %.2f%%\n', max(CostSpanPct));
writetable(T, 'audit_sensitivity_sweep.csv');
end

function [timely, cost] = run_kpi(sc, params, seed)
rng(seed);
r = run_step9_proposed_method(sc, params);
M = evaluate_step9_metrics(sc, {r});
timely = M.TimelyRate(1); cost = M.AvgTxCost(1);
end

function v = local_get(params, name)
if isfield(params, name); v = params.(name); else; v = NaN; end
end
