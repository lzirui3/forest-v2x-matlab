clc;
clear;
close all;

% Offline utility-weight calibration for the Step 9 confidence-driven scheduler.

cases = get_default_step9_weight_calibration_cases();

results = [];
case_id = 1;

for i = 1:numel(cases(1).values)
    for j = 1:numel(cases(2).values)
        for k = 1:numel(cases(3).values)
            for m = 1:numel(cases(4).values)
                for n = 1:numel(cases(5).values)
                    cfg.utility_weight_timely = cases(1).values(i);
                    cfg.utility_weight_reliability = cases(2).values(j);
                    cfg.utility_weight_cost = cases(3).values(k);
                    cfg.utility_weight_position_risk = cases(4).values(m);
                    cfg.utility_weight_event = cases(5).values(n);

                    result = evaluate_step9_calibration_objective(cfg);
                    result.case_id = case_id;

                    if isempty(results)
                        results = result;
                    else
                        results(end + 1) = result; %#ok<AGROW>
                    end
                    case_id = case_id + 1;
                end
            end
        end
    end
end

T = build_step9_weight_calibration_table(results);
disp(T(1:min(10, height(T)), :));

writetable(T, 'step9_weight_calibration_table.csv');
write_step9_weight_calibration_report(T, 'step9_weight_calibration_report.md');

disp('Step 9 weight calibration complete.');
