function quality = estimate_gnss_quality(gnss, params)
%ESTIMATE_GNSS_QUALITY Build a simple normalized GNSS quality indicator.
%
% quality = 1 means high confidence
% quality = 0 means very low confidence / outage

t = gnss.t;
N = numel(t);
quality = zeros(N, 1);

for k = 1:N
    if isnan(gnss.x(k)) || isnan(gnss.y(k)) || gnss.status(k) == 2
        quality(k) = 0.0;
    elseif gnss.status(k) == 0
        quality(k) = params.quality_normal;
    else
        quality(k) = params.quality_degraded;
    end
end

quality = min(max(quality, 0.0), 1.0);
