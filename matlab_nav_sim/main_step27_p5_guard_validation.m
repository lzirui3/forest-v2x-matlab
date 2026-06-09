clc;
clear;

num_seeds = 10;
seed_override = getenv('STEP27_NUM_SEEDS');
if ~isempty(seed_override)
    num_seeds = str2double(seed_override);
end

target_scenes = get_env_string_list('STEP27_SCENES', ["10019", "10017", "10014", "10006"]);
target_configs = get_env_string_list('STEP27_CONFIGS', ["Default", "ForestGeometry"]);
method_names = ["Link-delay-aware", "Confidence-GuardOff", "Confidence-GuardOn"];

rows = [];
stage_rows = [];
scene_matrix = get_paper_scene_matrix();

for scene_id = target_scenes
    scene_meta = scene_matrix([scene_matrix.scene_id] == scene_id);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_id);

    for cfg_name = target_configs
        for seed = 1:num_seeds
            params_on = get_params_for_config(cfg_name);
            params_on.scenario_input = scene_cfg;
            params_on.random_seed = seed;

            params_off = params_on;
            params_off.deadline_guard_ratio = inf;
            params_off.regime_pdr_bypass_threshold = inf;

            scenario = generate_step9_scenario(params_on);

            rng(seed, 'twister');
            linkd = run_step9_baseline_link_delayaware(scenario, params_on);
            rng(seed, 'twister');
            guard_off = run_step9_confidence_driven(scenario, params_off);
            guard_off.name = "Confidence-GuardOff";
            rng(seed, 'twister');
            guard_on = run_step9_confidence_driven(scenario, params_on);
            guard_on.name = "Confidence-GuardOn";

            results = {linkd, guard_off, guard_on};
            T_seed = evaluate_step9_metrics(scenario, results);
            T_seed.Scene = repmat(scene_id, height(T_seed), 1);
            T_seed.SceneRole = repmat(scene_meta.scene_role, height(T_seed), 1);
            T_seed.GeometryType = repmat(scene_meta.geometry_type, height(T_seed), 1);
            T_seed.DensityClass = repmat(scene_meta.density_class, height(T_seed), 1);
            T_seed.VegetationClass = repmat(scene_meta.vegetation_class, height(T_seed), 1);
            T_seed.Config = repmat(cfg_name, height(T_seed), 1);
            T_seed.Seed = repmat(seed, height(T_seed), 1);
            T_seed = movevars(T_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');
            rows = append_table(rows, T_seed);

            stages = define_step9_stage_masks(scenario.t);
            metrics_list = cell(numel(results), 1);
            for i = 1:numel(results)
                metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
            end
            T_stage = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
            T_stage.Scene = repmat(scene_id, height(T_stage), 1);
            T_stage.SceneRole = repmat(scene_meta.scene_role, height(T_stage), 1);
            T_stage.GeometryType = repmat(scene_meta.geometry_type, height(T_stage), 1);
            T_stage.DensityClass = repmat(scene_meta.density_class, height(T_stage), 1);
            T_stage.VegetationClass = repmat(scene_meta.vegetation_class, height(T_stage), 1);
            T_stage.Config = repmat(cfg_name, height(T_stage), 1);
            T_stage.Seed = repmat(seed, height(T_stage), 1);
            T_stage = movevars(T_stage, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');
            stage_rows = append_table(stage_rows, T_stage);
        end
    end
end

summary = build_step17_summary_table(rows);
stage_summary = build_step17_stage_summary_table(stage_rows);
posdeg = stage_rows(stage_rows.Stage == "PosDeg_Emerg", :);
posdeg_summary = build_step17_stage_summary_table(posdeg);
overall_delta = build_guard_delta_table(summary);
posdeg_delta = build_guard_delta_table(posdeg_summary);

writetable(rows, 'step27_p5_guard_validation_raw.csv');
writetable(stage_rows, 'step27_p5_guard_validation_stage_raw.csv');
writetable(summary, 'step27_p5_guard_validation_summary.csv');
writetable(stage_summary, 'step27_p5_guard_validation_stage_summary.csv');
writetable(posdeg_summary, 'step27_p5_guard_validation_posdeg_summary.csv');
writetable(overall_delta, 'step27_p5_guard_validation_overall_delta.csv');
writetable(posdeg_delta, 'step27_p5_guard_validation_posdeg_delta.csv');

disp(summary);
disp(posdeg_summary);
disp(posdeg_delta);
fprintf('Step 27 complete: P5 guard validation (%d seeds).\n', num_seeds);

function params = get_params_for_config(cfg_name)
if cfg_name == "Default"
    params = get_default_step9_mainline_params();
else
    params = get_forest_geometry_mainline_params();
end
end

function values = get_env_string_list(name, default_values)
raw = strtrim(string(getenv(name)));
if strlength(raw) == 0
    values = default_values;
    return;
end

parts = strtrim(split(raw, ','));
values = parts(strlength(parts) > 0).';
end

function T = append_table(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end

function T_delta = build_guard_delta_table(T_summary)
key_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'};
if ismember('Stage', T_summary.Properties.VariableNames)
    key_vars = [key_vars, {'Stage'}];
end

keys = unique(T_summary(:, key_vars), 'rows', 'stable');
rows = [];
for i = 1:height(keys)
    mask = true(height(T_summary), 1);
    for j = 1:numel(key_vars)
        key = key_vars{j};
        mask = mask & T_summary.(key) == keys.(key)(i);
    end

    guard_off = T_summary(mask & T_summary.Method == "Confidence-GuardOff", :);
    guard_on = T_summary(mask & T_summary.Method == "Confidence-GuardOn", :);
    if isempty(guard_off) || isempty(guard_on)
        continue;
    end

    row = keys(i, :);
    row.GuardOffAvgDelayMean = guard_off.AvgDelayMean(1);
    row.GuardOnAvgDelayMean = guard_on.AvgDelayMean(1);
    row.DeltaAvgDelay_s = guard_on.AvgDelayMean(1) - guard_off.AvgDelayMean(1);
    row.DeltaAvgDelay_pct = safe_pct_delta(guard_on.AvgDelayMean(1), guard_off.AvgDelayMean(1));
    row.GuardOffAvgTxCostMean = guard_off.AvgTxCostMean(1);
    row.GuardOnAvgTxCostMean = guard_on.AvgTxCostMean(1);
    row.DeltaAvgTxCost = guard_on.AvgTxCostMean(1) - guard_off.AvgTxCostMean(1);
    row.DeltaTimelyRate_pp = 100.0 * (guard_on.TimelyRateMean(1) - guard_off.TimelyRateMean(1));
    row.DeltaLossRate_pp = 100.0 * (guard_on.LossRateMean(1) - guard_off.LossRateMean(1));
    row.DeltaEmergencyTimelyRate_pp = 100.0 * (guard_on.EmergencyTimelyRateMean(1) - guard_off.EmergencyTimelyRateMean(1));

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
    end
end

T_delta = rows;
end

function pct = safe_pct_delta(new_value, old_value)
if abs(old_value) < 1.0e-12
    pct = NaN;
else
    pct = 100.0 * (new_value - old_value) / old_value;
end
end
