clc;
clear;
close all;

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;

num_seeds = 5;
seed_override = getenv('STEP18_LITE_NUM_SEEDS');
if ~isempty(seed_override)
    num_seeds = str2double(seed_override);
end
seed_list = 1:num_seeds;

scene_ids = ["10014", "10006", "10017"];

enter_blind_grid = [0.14, 0.18, 0.22];
enter_qpos_grid = [0.68, 0.72, 0.76];
hold_blind_grid = [0.30, 0.36, 0.42];
hold_qpos_grid = [0.48, 0.52, 0.58];

rows = [];
combo_id = 0;

for a = 1:numel(enter_blind_grid)
    for b = 1:numel(enter_qpos_grid)
        for c = 1:numel(hold_blind_grid)
            for d = 1:numel(hold_qpos_grid)
                params = get_default_step9_mainline_params();
                params.confidence_regime_blind_threshold = enter_blind_grid(a);
                params.confidence_regime_qpos_threshold = enter_qpos_grid(b);
                params.confidence_regime_hold_blind_threshold = hold_blind_grid(c);
                params.confidence_regime_hold_qpos_threshold = hold_qpos_grid(d);

                combo_id = combo_id + 1;
                row = evaluate_step18_lite_combo(params, scene_ids, seed_list);
                row.ComboID = combo_id;
                row = movevars(row, 'ComboID', 'Before', 'EnterBlindThr');

                if isempty(rows)
                    rows = row;
                else
                    rows = [rows; row]; %#ok<AGROW>
                end
            end
        end
    end
end

T = sortrows(rows, 'CompositeScore', 'descend');
disp(T(1:min(20, height(T)), :));
writetable(T, 'step18_lite_parameter_grid_search.csv');
disp('Step 18-lite complete: reduced parameter search generated.');
