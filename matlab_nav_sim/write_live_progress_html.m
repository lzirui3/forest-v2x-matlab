function write_live_progress_html(html_path, done, total, elapsed_s, names, nseed, v6T, dppT, v6C, dppC, finished)
%WRITE_LIVE_PROGRESS_HTML Render a self-refreshing progress dashboard to disk.
%   Called repeatedly (e.g. from a parallel.pool.DataQueue afterEach callback)
%   so a browser pointed at html_path shows live progress while a long parallel
%   run is in flight. The page auto-refreshes every second until finished.

if nargin < 11, finished = false; end
pct = 0; if total > 0, pct = 100 * done / total; end
eta = NaN;
if done > 0 && ~finished, eta = elapsed_s / done * (total - done); end

refresh_tag = '<meta http-equiv="refresh" content="1">';
status = 'RUNNING';
bar_color = '#2d7';
if finished, refresh_tag = ''; status = 'DONE'; bar_color = '#39f'; end

head = ['<!DOCTYPE html><html><head><meta charset="utf-8">' refresh_tag ...
    '<title>DPP experiment progress</title><style>' ...
    'body{font-family:Segoe UI,Arial,sans-serif;margin:24px;color:#222;background:#fafafa}' ...
    'h2{margin:0 0 4px}.sub{color:#777;font-size:13px;margin-bottom:16px}' ...
    '.track{background:#eee;border-radius:8px;height:26px;width:100%;overflow:hidden}' ...
    '.fill{height:26px;text-align:center;color:#fff;line-height:26px;font-size:13px}' ...
    'table{border-collapse:collapse;margin-top:18px;font-size:14px}' ...
    'th,td{border:1px solid #ddd;padding:6px 12px;text-align:right}' ...
    'th{background:#f0f0f0}td.l,th.l{text-align:left}' ...
    '.good{color:#137a13;font-weight:600}.bad{color:#b00;font-weight:600}' ...
    '</style></head><body>'];

hdr = sprintf(['<h2>DPP experiment &mdash; %s</h2>' ...
    '<div class="sub">%d / %d jobs &nbsp;|&nbsp; elapsed %.0fs &nbsp;|&nbsp; ETA %s &nbsp;|&nbsp; %s</div>'], ...
    status, done, total, elapsed_s, eta_str(eta), datestr(now, 'HH:MM:SS'));

bar = sprintf(['<div class="track"><div class="fill" style="width:%.1f%%;background:%s">%.0f%%</div></div>'], ...
    pct, bar_color, pct);

rows = ['<table><tr><th class="l">Regime</th><th>seeds</th>' ...
    '<th>v6 Timely</th><th>DPP Timely</th><th>&Delta;Timely</th>' ...
    '<th>v6 Cost</th><th>DPP Cost</th><th>&Delta;Cost</th></tr>'];
for r = 1:numel(names)
    if nseed(r) > 0
        a = v6T(r)/nseed(r); b = dppT(r)/nseed(r);
        c = v6C(r)/nseed(r); d = dppC(r)/nseed(r);
        dt = b - a; dc = d - c;
        cls = 'good'; if dt < 0, cls = 'bad'; end
        rows = [rows sprintf(['<tr><td class="l">%s</td><td>%d</td>' ...
            '<td>%.4f</td><td>%.4f</td><td class="%s">%+.4f</td>' ...
            '<td>%.3f</td><td>%.3f</td><td>%+.3f</td></tr>'], ...
            names(r), nseed(r), a, b, cls, dt, c, d, dc)]; %#ok<AGROW>
    else
        rows = [rows sprintf('<tr><td class="l">%s</td><td>0</td><td colspan="6">pending&hellip;</td></tr>', names(r))]; %#ok<AGROW>
    end
end
rows = [rows '</table>'];

footer = '<div class="sub" style="margin-top:14px">This page auto-refreshes every 1s while running.</div></body></html>';

fid = fopen(html_path, 'w');
if fid < 0, return; end
cleaner = onCleanup(@() fclose(fid));
fprintf(fid, '%s', [head hdr bar rows footer]);
end

function s = eta_str(eta)
if isnan(eta)
    s = '--';
elseif eta < 90
    s = sprintf('%.0fs', eta);
else
    s = sprintf('%.1fmin', eta/60);
end
end
