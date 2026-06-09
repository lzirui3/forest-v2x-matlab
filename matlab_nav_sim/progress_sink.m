function progress_sink(payload)
%PROGRESS_SINK afterEach handler for live HTML progress. Keeps running per-regime
%   accumulators in a persistent state and rewrites the dashboard on each update.
%   Send struct('init',true,'total',K,'html',path,'names',{names}) once to reset,
%   then struct('regime_idx',ri,'v6T',..,'dppT',..,'v6C',..,'dppC',..) per job.

persistent done total t0 html names sT6 sD6 sTc sDc nseed

if isfield(payload, 'init')
    total = payload.total;
    html = payload.html;
    names = payload.names;
    R = numel(names);
    done = 0; t0 = tic;
    sT6 = zeros(R, 1); sD6 = zeros(R, 1); sTc = zeros(R, 1); sDc = zeros(R, 1); nseed = zeros(R, 1);
    write_live_progress_html(html, 0, total, 0, names, nseed, sT6, sD6, sTc, sDc, false);
    return;
end

ri = payload.regime_idx;
sT6(ri) = sT6(ri) + payload.v6T;  sD6(ri) = sD6(ri) + payload.dppT;
sTc(ri) = sTc(ri) + payload.v6C;  sDc(ri) = sDc(ri) + payload.dppC;
nseed(ri) = nseed(ri) + 1;
done = done + 1;
finished = (done >= total);
write_live_progress_html(html, done, total, toc(t0), names, nseed, sT6, sD6, sTc, sDc, finished);
end
