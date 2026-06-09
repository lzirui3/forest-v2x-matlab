function metrics = compute_step9_effective_warning_metrics(scenario, result, qpos_threshold)
%COMPUTE_STEP9_EFFECTIVE_WARNING_METRICS
% Measure timely warning effectiveness under positioning-confidence constraints.

if nargin < 3 || isempty(qpos_threshold)
    qpos_threshold = 0.50;
end

idx_emg = scenario.msg_type == "emergency";
idx_posdeg = (scenario.t >= 68) & (scenario.t < 90) & idx_emg;

effective_mask = idx_posdeg & (scenario.q_pos >= qpos_threshold);

metrics.qpos_threshold = qpos_threshold;
metrics.posdeg_effective_warning_rate = mean(result.delivery.deadline_hit(effective_mask));
metrics.posdeg_effective_coverage = mean(effective_mask(idx_posdeg));
metrics.posdeg_effective_count = sum(effective_mask);
metrics.posdeg_emergency_count = sum(idx_posdeg);

if metrics.posdeg_effective_count > 0
    metrics.posdeg_effective_avg_delay_s = mean(result.delivery.delay(effective_mask & result.delivery.deadline_hit));
else
    metrics.posdeg_effective_avg_delay_s = NaN;
end
end
