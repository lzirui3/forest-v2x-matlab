clc;
clear;
close all;

% Check whether the utility-based scheduler obeys monotonic risk-response trends.

params = get_default_step9_params();
base_rate = params.base_rate_emergency;
relay_available = 1.0;

urgency_grid = [0.30, 0.60, 0.95];
q_link_grid = linspace(0.20, 0.90, 8);
q_pos_grid = linspace(0.20, 0.90, 8);
blind_grid = [0.0, 0.35, 0.60, 0.85];

rows = [];
for iu = 1:numel(urgency_grid)
    for ib = 1:numel(blind_grid)
        event_state.blind_zone_gate = blind_grid(ib);
        event_state.rsu_gain_gate = 0.70 * blind_grid(ib);
        event_state.env_correction_gate = 0.60 * blind_grid(ib);
        event_state.use_gnss = true;
        event_state.use_rsu = true;
        event_state.use_env = true;
        event_state.use_traj = true;

        intensity_map = zeros(numel(q_link_grid), numel(q_pos_grid));
        for i = 1:numel(q_link_grid)
            for j = 1:numel(q_pos_grid)
                action = decide_schedule_action(urgency_grid(iu), q_link_grid(i), q_pos_grid(j), ...
                    relay_available, base_rate, params, event_state);
                intensity_map(i, j) = action.priority + 0.35 * action.rate_multiplier + 0.45 * double(action.mode > 0);
            end
        end

        mono_link = mean(all(diff(intensity_map, 1, 1) <= 1.0e-9, 2));
        mono_pos = mean(all(diff(intensity_map, 1, 2) <= 1.0e-9, 1));

        row = table(urgency_grid(iu), blind_grid(ib), mono_link, mono_pos, ...
            'VariableNames', {'Urgency', 'BlindZoneGate', 'LinkMonotonicRatio', 'PosMonotonicRatio'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

disp(rows);
writetable(rows, 'step9_monotonicity_check.csv');
disp('Monotonicity check complete.');
