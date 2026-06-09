function cases = get_default_step9_weight_calibration_cases()
%GET_DEFAULT_STEP9_WEIGHT_CALIBRATION_CASES Small candidate sets for utility-weight calibration.

cases = struct('name', {}, 'values', {});

cases(1).name = 'utility_weight_timely';
cases(1).values = [0.90, 1.10, 1.30];

cases(2).name = 'utility_weight_reliability';
cases(2).values = [0.55];

cases(3).name = 'utility_weight_cost';
cases(3).values = [0.04, 0.07, 0.10];

cases(4).name = 'utility_weight_position_risk';
cases(4).values = [0.18, 0.28, 0.38];

cases(5).name = 'utility_weight_event';
cases(5).values = [0.12, 0.22, 0.32];
end
