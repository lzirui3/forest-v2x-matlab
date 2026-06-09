function q_link = compute_link_quality_rule(pdr, delay, loss)
%COMPUTE_LINK_QUALITY_RULE Rule-based link quality score in [0, 1].

s_pdr = min(max((pdr - 0.30) ./ (1.00 - 0.30), 0.0), 1.0);
s_delay = 1.0 - min(max((delay - 0.05) ./ (0.60 - 0.05), 0.0), 1.0);
s_loss = 1.0 - min(max(loss ./ 0.70, 0.0), 1.0);

q_link = 0.40 * s_pdr + 0.30 * s_delay + 0.30 * s_loss;
q_link = min(max(q_link, 0.0), 1.0);
end

