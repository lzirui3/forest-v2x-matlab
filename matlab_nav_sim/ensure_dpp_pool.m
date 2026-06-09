function pool = ensure_dpp_pool(target)
%ENSURE_DPP_POOL Start (or grow) a local parallel pool sized to the machine.
%
%   pool = ENSURE_DPP_POOL() starts a local pool with one worker per physical
%   core so the multi-seed DPP sweeps use every core ON WHATEVER MACHINE RUNS
%   THEM. The worker count is discovered at run time from feature('numcores'),
%   so it adapts automatically to a different computer (a laptop, a friend's
%   box, a server) -- nothing about the core count is hard-coded.
%
%   pool = ENSURE_DPP_POOL(target) requests `target` workers instead.
%
%   Portability / robustness (this code is meant to be shared and run elsewhere):
%     * No Parallel Computing Toolbox  -> returns [], does nothing; the caller's
%       parfor then simply runs as an ordinary serial for loop.
%     * Stale/low local-profile worker cap -> raised IN MEMORY ONLY for this
%       session (no saveProfile, so the user's saved profile is never modified).
%     * License/resource limits or any parpool failure -> caught; falls back to
%       any pool that does exist, else to serial parfor. Never errors out.

pool = [];

% --- Parallel Computing Toolbox present? If not, parfor runs serially. ---
try
    has_pct = ~isempty(ver('parallel'));
catch
    has_pct = false;
end
if ~has_pct
    return;
end

% --- Discover this machine's core count at run time (adapts per computer). ---
if nargin < 1 || isempty(target)
    try
        target = feature('numcores');     % physical cores; avoids SMT oversubscription
    catch
        target = 4;                       % conservative fallback if probing fails
    end
end
target = max(1, round(target));

try
    pool = gcp('nocreate');
catch
    pool = [];
end

% Reuse an existing pool if it is already big enough.
if ~isempty(pool) && pool.NumWorkers >= target
    return;
end

try
    c = parcluster('local');
    if c.NumWorkers < target
        c.NumWorkers = target;            % in-memory cap bump; NOT persisted
    end
    if ~isempty(pool) && pool.NumWorkers < target
        delete(pool);                     % too small: replace with a bigger one
        pool = [];
    end
    if isempty(pool)
        pool = parpool(c, target);
    end
catch ME
    % License caps, resource pressure, or a transient pool error: do not fail the
    % whole run. Use whatever pool happens to exist; otherwise parfor goes serial.
    warning('ensure_dpp_pool:fallback', ...
        'Could not start a %d-worker pool (%s). Continuing with existing pool / serial.', ...
        target, ME.message);
    try
        pool = gcp('nocreate');
    catch
        pool = [];
    end
end
end
