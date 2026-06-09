function q_pos = compute_positioning_confidence_rule(n_sat, dop, sigma_pos, dt_upd)
%COMPUTE_POSITIONING_CONFIDENCE_RULE Rule-based positioning confidence score in [0, 1].

s_sat = (n_sat - 3.0) ./ (12.0 - 3.0);
s_sat = min(max(s_sat, 0.0), 1.0);

s_dop = 1.0 - (dop - 1.0) ./ (5.0 - 1.0);
s_dop = min(max(s_dop, 0.0), 1.0);

s_pos = 1.0 - (sigma_pos - 0.3) ./ (3.0 - 0.3);
s_pos = min(max(s_pos, 0.0), 1.0);

s_upd = 1.0 - (dt_upd - 0.1) ./ (0.8 - 0.1);
s_upd = min(max(s_upd, 0.0), 1.0);

q_pos = 0.25 * s_sat + 0.25 * s_dop + 0.30 * s_pos + 0.20 * s_upd;
q_pos = min(max(q_pos, 0.0), 1.0);
end

