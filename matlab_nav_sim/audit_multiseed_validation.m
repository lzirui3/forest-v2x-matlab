function S = audit_multiseed_validation(nseeds)
%AUDIT_MULTISEED_VALIDATION Multi-seed CI for the grounded production method.
%   Runs the proposed DPP method and the main comparison baselines over NSEEDS
%   seeds under the production mainline params (physical per_lookup), on a fresh
%   per-seed scenario with common random numbers across methods, and reports
%   mean +/- 95% CI for the headline KPIs. Writes audit_multiseed_validation.csv.

if nargin < 1 || isempty(nseeds); nseeds = 10; end
seeds = 4200 + (0:nseeds-1);

methods = { ...
    'Proposed-DPP',         @run_step9_proposed_method; ...
    'Link-delayaware',      @run_step9_baseline_link_delayaware; ...
    'Confidence-heuristic', @run_step9_confidence_driven_heuristic; ...
    'Constrained-Oracle',   @run_step9_baseline_oracle};
nm = size(methods, 1);
KPI = nan(nseeds, nm, 4);   % [seed, method, (Timely,Loss,Cost,Emg)]

for si = 1:nseeds
    s = seeds(si);
    mp = get_default_step9_mainline_params(); mp.random_seed = s;
    rng(s); sc = generate_step9_scenario(mp);
    for mi = 1:nm
        try
            rng(s);
            r = methods{mi, 2}(sc, mp);
            M = evaluate_step9_metrics(sc, {r});
            KPI(si, mi, 1) = M.TimelyRate(1);
            KPI(si, mi, 2) = M.LossRate(1);
            KPI(si, mi, 3) = M.AvgTxCost(1);
            KPI(si, mi, 4) = M.EmergencyTimelyRate(1);
        catch ME
            fprintf(2, '  seed %d / %s failed: %s\n', s, methods{mi, 1}, ME.message);
        end
    end
    fprintf('  [%d/%d] seed %d done: Proposed Timely=%.4f Cost=%.4f\n', ...
        si, nseeds, s, KPI(si, 1, 1), KPI(si, 1, 3));
    save('audit_multiseed_partial.mat', 'KPI', 'seeds');
end

fprintf('=== Multi-seed validation (%d seeds, mainline DPP per_lookup) ===\n', nseeds);
fprintf('%-22s %-16s %-16s %-16s %-16s\n', 'Method', 'TimelyRate', 'LossRate', 'AvgTxCost', 'EmgTimely');
rows = {};
for mi = 1:nm
    cells = cell(1, 4);
    stats = zeros(1, 8);
    for ki = 1:4
        x = KPI(:, mi, ki); x = x(~isnan(x)); n = max(numel(x), 1);
        m = mean(x); ci = 1.96 * std(x) / sqrt(n);
        cells{ki} = sprintf('%.4f+/-%.4f', m, ci);
        stats(2*ki-1) = m; stats(2*ki) = ci;
    end
    fprintf('%-22s %-16s %-16s %-16s %-16s\n', methods{mi, 1}, cells{1}, cells{2}, cells{3}, cells{4});
    rows(end+1, :) = [methods(mi, 1), num2cell(stats)]; %#ok<AGROW>
end

T = cell2table(rows, 'VariableNames', {'Method', ...
    'Timely_mean','Timely_ci','Loss_mean','Loss_ci','Cost_mean','Cost_ci','Emg_mean','Emg_ci'});
writetable(T, 'audit_multiseed_validation.csv');
fprintf('Wrote audit_multiseed_validation.csv (%d seeds).\n', nseeds);
S = T;
end
