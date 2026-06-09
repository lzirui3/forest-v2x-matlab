function T = main_step75_live_heldout(num_seeds, pdr_mode)
%MAIN_STEP75_LIVE_HELDOUT Parallel held-out comparison (v6 vs DPP) with a LIVE
%   HTML progress dashboard. Open the printed html path in a browser to watch
%   progress / running means update in real time while the run is in flight.
%
%   Uses a lightweight Threads pool when the scheduler is thread-compatible,
%   otherwise falls back to a Processes pool. PDPP (H>1) is dropped (no benefit).
%
%   T = main_step75_live_heldout(num_seeds, pdr_mode)
%     num_seeds : seeds per regime (default 3, for a quick trend)
%     pdr_mode  : "sigmoid" (default) or "per_lookup"

if nargin < 1 || isempty(num_seeds), num_seeds = 3; end
if nargin < 2 || strlength(string(pdr_mode)) == 0, pdr_mode = "sigmoid"; end
pdr_mode = string(pdr_mode);

regimes = { ...
    "ForestGeom (TUNING)",    @() get_forest_geometry_mainline_params(); ...
    "Moderate (heldout)",     @() get_moderate_forest_geometry_mainline_params(); ...
    "Generic (heldout)",      @() get_default_step9_mainline_params(); ...
    "V2XSeq-10013 (heldout)", @() local_v2xseq_params("10013"); ...
    "V2XSeq-10007 (heldout)", @() local_v2xseq_params("10007"); ...
    "V2XSeq-10015 (heldout)", @() local_v2xseq_params("10015") };
R = size(regimes, 1);
names = string(regimes(:, 1));

% --- build scenarios serially (evalc suppresses calibration table) ---
regimeParams = cell(R, 1);
regimeScen = cell(R, 1);
for ri = 1:R
    [~, params] = evalc('feval(regimes{ri, 2})'); %#ok<ASGLU>
    params.physical_pdr_mode = pdr_mode;
    regimeParams{ri} = params;
    sc = cell(num_seeds, 1);
    for si = 1:num_seeds
        p = params; p.random_seed = si;
        [~, sc{si}] = evalc('generate_step9_scenario(p)');
    end
    regimeScen{ri} = sc;
end

% --- flatten jobs ---
K = R * num_seeds;
jobR = zeros(K, 1); jobSeed = zeros(K, 1); jobSc = cell(K, 1); jobP = cell(K, 1);
k = 0;
for ri = 1:R
    for si = 1:num_seeds
        k = k + 1;
        jobR(k) = ri; jobSeed(k) = si; jobSc{k} = regimeScen{ri}{si}; jobP{k} = regimeParams{ri};
    end
end

% --- pick a working pool (Threads if the scheduler runs on it, else Processes) ---
backend = local_ensure_pool(jobSc{1}, jobP{1});
fprintf('Parallel backend: %s\n', backend);

% --- live progress dashboard ---
html_path = fullfile(pwd, 'dpp_live_progress.html');
progress_sink(struct('init', true, 'total', K, 'html', html_path, 'names', {names}));
q = parallel.pool.DataQueue;
afterEach(q, @progress_sink);
fprintf('LIVE PROGRESS -> open this in a browser:\n  %s\n', html_path);

resT6 = zeros(K, 1); resD6 = zeros(K, 1); resTc = zeros(K, 1); resDc = zeros(K, 1);
parfor k = 1:K
    sc = jobSc{k}; p = jobP{k}; sd = jobSeed(k);
    rng(sd); r6 = run_step9_proposed_method(sc, p);
    rng(sd); rd = run_step9_proposed_method_dpp(sc, p);
    t6 = mean(r6.delivery.deadline_hit); d6 = mean(rd.delivery.deadline_hit);
    c6 = mean(r6.delivery.tx_cost);      dc = mean(rd.delivery.tx_cost);
    resT6(k) = t6; resD6(k) = d6; resTc(k) = c6; resDc(k) = dc;
    send(q, struct('regime_idx', jobR(k), 'v6T', t6, 'dppT', d6, 'v6C', c6, 'dppC', dc));
end

% --- aggregate ---
v6_Timely = zeros(R, 1); DPP_Timely = zeros(R, 1); v6_Cost = zeros(R, 1); DPP_Cost = zeros(R, 1);
for ri = 1:R
    m = (jobR == ri);
    v6_Timely(ri) = mean(resT6(m)); DPP_Timely(ri) = mean(resD6(m));
    v6_Cost(ri) = mean(resTc(m));   DPP_Cost(ri) = mean(resDc(m));
end
Regime = names;
dTimely = DPP_Timely - v6_Timely;
dCost = DPP_Cost - v6_Cost;
T = table(Regime, v6_Timely, DPP_Timely, dTimely, v6_Cost, DPP_Cost, dCost);
fprintf('\n=== Held-out (pdr_mode=%s, %d seeds, backend=%s) ===\n', pdr_mode, num_seeds, backend);
disp(T);
writetable(T, sprintf('step75_live_heldout_%s.csv', pdr_mode));
end

function params = local_v2xseq_params(scene_id)
params = get_forest_geometry_mainline_params();
params.scenario_input = get_step9_v2xseq_config_by_scene(scene_id);
end

function backend = local_ensure_pool(testSc, testP)
%LOCAL_ENSURE_POOL Use a Threads pool if the scheduler runs on it; else Processes.
pool = gcp('nocreate');
if isa(pool, 'parallel.ThreadPool')
    backend = "Threads (existing)"; return;
end
delete(pool);   % drop any process pool to honor the lightweight request
try
    tp = parpool('Threads');
    f = parfeval(tp, @local_probe, 1, testSc, testP);
    local_probe_out = fetchOutputs(f); %#ok<NASGU>
    backend = "Threads"; return;
catch ME
    fprintf('Threads backend unusable for the scheduler (%s) -> Processes.\n', ME.message);
    delete(gcp('nocreate'));
    parpool('Processes', 8);
    backend = "Processes";
end
end

function y = local_probe(sc, p)
r = run_step9_proposed_method_dpp(sc, p);
y = mean(r.delivery.deadline_hit);
end
