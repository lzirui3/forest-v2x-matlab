function audit_mainline_matrix()
%AUDIT_MAINLINE_MATRIX Decompose the Wave-1 change on the PRODUCTION (physical) path.
%   Under the mainline params (use_physical_delivery=true), run the 2x2 of
%   {current entry (v6), DPP} x {sigmoid, per_lookup} on ONE fixed-seed scenario
%   with common random numbers, so the drift from (a) wiring DPP and (b) moving
%   sigmoid->per_lookup is separately visible BEFORE the defaults are flipped.

seed = 20240609;
try
    base = get_default_step9_mainline_params();
    src = 'mainline(physical)';
catch ME
    warning('mainline params failed (%s); falling back to base+physical', ME.message);
    base = get_default_step9_params();
    base.use_physical_delivery = true;
    src = 'base+physical(forced)';
end
base.random_seed = seed;

rng(seed);
scenario = generate_step9_scenario(base);

configs = { ...
    'v6+sigmoid',    @run_step9_proposed_method,     'sigmoid'; ...
    'v6+perlookup',  @run_step9_proposed_method,     'per_lookup'; ...
    'DPP+sigmoid',   @run_step9_proposed_method_dpp, 'sigmoid'; ...
    'DPP+perlookup', @run_step9_proposed_method_dpp, 'per_lookup'};

res = cell(size(configs, 1), 1);
for i = 1:size(configs, 1)
    p = base;
    p.physical_pdr_mode = configs{i, 3};
    rng(seed);
    r = configs{i, 2}(scenario, p);
    r.name = string(configs{i, 1});
    res{i} = r;
end

T = evaluate_step9_metrics(scenario, res);
fprintf('=== PRODUCTION 2x2 matrix (%s, seed %d, use_physical_delivery=%d) ===\n', ...
    src, seed, base.use_physical_delivery);
disp(T);
writetable(T, 'audit_mainline_matrix.csv');
fprintf('Wrote audit_mainline_matrix.csv\n');
end
