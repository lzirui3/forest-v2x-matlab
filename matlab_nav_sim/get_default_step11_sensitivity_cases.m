function cases = get_default_step11_sensitivity_cases()
%GET_DEFAULT_STEP11_SENSITIVITY_CASES Core Step 11 sensitivity cases.

cases = struct('param_name', {}, 'values', {});

cases(1).param_name = 'utility_weight_timely';
cases(1).values = [0.70, 0.85, 1.00, 1.15, 1.30];

cases(2).param_name = 'utility_weight_cost';
cases(2).values = [0.03, 0.05, 0.07, 0.10, 0.14];

cases(3).param_name = 'utility_weight_reliability';
cases(3).values = [0.35, 0.45, 0.55, 0.70, 0.85];

cases(4).param_name = 'utility_weight_position_risk';
cases(4).values = [0.12, 0.20, 0.28, 0.36, 0.44];

cases(5).param_name = 'utility_weight_event';
cases(5).values = [0.08, 0.15, 0.22, 0.30, 0.38];

cases(6).param_name = 'event_rate_scale_gain';
cases(6).values = [0.10, 0.16, 0.22, 0.30, 0.40];

cases(7).param_name = 'event_synergy_gain';
cases(7).values = [0.15, 0.30, 0.45, 0.60, 0.75];

cases(8).param_name = 'utility_constraint_penalty';
cases(8).values = [0.80, 1.20, 1.60, 2.00, 2.40];

cases(9).param_name = 'utility_margin_sigmoid_scale';
cases(9).values = [0.030, 0.045, 0.060, 0.080, 0.100];
end
