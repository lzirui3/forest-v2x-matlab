function audit_snapshot_harness(tag)
%AUDIT_SNAPSHOT_HARNESS Deterministic KPI snapshot for the parameter-grounding audit.
%   audit_snapshot_harness('baseline') runs the current proposed method (whatever
%   run_step9_proposed_method routes to) and the DPP scheduler on a fixed-seed
%   smoke scenario, under common random numbers, and writes a KPI CSV tagged TAG.
%   Re-running after a [SAFE] edit must reproduce the baseline CSV byte-for-byte;
%   after a [STRUCTURAL] edit the drift vs baseline is the quantity we report.

if nargin < 1 || isempty(tag); tag = 'baseline'; end
seed = 20240609;

params = get_default_step9_params();
params.random_seed = seed;

rng(seed);
scenario = generate_step9_scenario(params);

methods = { ...
    'Proposed(entry)', @() run_step9_proposed_method(scenario, params); ...
    'DPP(direct)',     @() run_step9_proposed_method_dpp(scenario, params)};

results = cell(size(methods, 1), 1);
for i = 1:size(methods, 1)
    rng(seed);                      % common random numbers across methods
    results{i} = methods{i, 2}();
end

T = evaluate_step9_metrics(scenario, results);
disp(T);

out = sprintf('audit_snapshot_%s.csv', tag);
writetable(T, out);
fprintf('SNAPSHOT[%s] written -> %s (%d methods, seed %d)\n', tag, out, numel(results), seed);
end
