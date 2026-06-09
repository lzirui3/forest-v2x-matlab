clc;
clear;
close all;

% Step44: validate calibrated thresholds without changing the mainline
% parameter file. Outputs use the step44_* prefix and do not overlap Step40.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP44_NUM_SEEDS', 3);
scene_ids = get_env_string_list_local('STEP44_SCENES', ...
    ["10014", "10006", "10011", "10019", "10017"]);
config_names = get_env_string_list_local('STEP44_CONFIGS', ["Default", "ForestGeometry"]);
prefix = get_env_string_local('STEP44_PREFIX_TAG', ...
    "step44_threshold_validation_" + string(num_seeds) + "seed");
threshold_table_path = get_threshold_table_path_local();
threshold_table = normalize_threshold_table_local(readtable(threshold_table_path));

scene_matrix = filter_scene_matrix_local(get_paper_scene_matrix(), scene_ids);
variants = build_threshold_variants_local();
raw_rows = [];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg = config_names
        for seed = 1:num_seeds
            fprintf('Step44 threshold validation: scene=%s config=%s seed=%d/%d\n', ...
                scene_meta.scene_id, cfg, seed, num_seeds);

            T_seed = simulate_case_local(scene_meta, scene_cfg, cfg, seed, variants, threshold_table);
            raw_rows = append_table_local(raw_rows, T_seed);
        end
    end
end

summary = build_step17_summary_table(raw_rows);
significance = compute_significance_local(raw_rows, scene_matrix, config_names);
decision = build_decision_table_local(summary);

writetable(raw_rows, prefix + "_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(significance, prefix + "_default_vs_calibrated_significance.csv");
writetable(decision, prefix + "_decision_table.csv");
write_report_local(decision, threshold_table, threshold_table_path, prefix + "_report.md", num_seeds);

disp(decision);
fprintf('Step44 complete: threshold validation written with prefix %s.\n', prefix);

function T_seed = simulate_case_local(scene_meta, scene_cfg, cfg, seed, variants, threshold_table)
base_params = get_params_for_config_local(cfg);
base_params.scenario_input = scene_cfg;
base_params.random_seed = seed;
scenario = generate_step9_scenario(base_params);

results = cell(numel(variants) + 2, 1);
results{1} = run_step9_baseline_link_delayaware(scenario, base_params);
results{2} = run_step9_confidence_driven_heuristic(scenario, base_params);

for i = 1:numel(variants)
    params_i = base_params;
    if variants(i).UseCalibration
        params_i = apply_threshold_table_local(params_i, threshold_table, variants(i).Scale);
    end
    result = run_step9_proposed_method(scenario, params_i);
    result.name = variants(i).Name;
    results{i + 2} = result;
end

T_seed = evaluate_step9_metrics(scenario, results);
T_seed.Scene = repmat(scene_meta.scene_id, height(T_seed), 1);
T_seed.SceneRole = repmat(scene_meta.scene_role, height(T_seed), 1);
T_seed.GeometryType = repmat(scene_meta.geometry_type, height(T_seed), 1);
T_seed.DensityClass = repmat(scene_meta.density_class, height(T_seed), 1);
T_seed.VegetationClass = repmat(scene_meta.vegetation_class, height(T_seed), 1);
T_seed.Config = repmat(cfg, height(T_seed), 1);
T_seed.Seed = repmat(seed, height(T_seed), 1);
T_seed = movevars(T_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, ...
    'Before', 'Method');
end

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step44 config: %s', cfg);
end
end

function variants = build_threshold_variants_local()
variants = repmat(struct('Name', "", 'UseCalibration', false, 'Scale', 1.0), 4, 1);
variants(1).Name = "DefaultThresholds";
variants(1).UseCalibration = false;
variants(1).Scale = 1.0;

variants(2).Name = "CalibratedThresholds";
variants(2).UseCalibration = true;
variants(2).Scale = 1.0;

variants(3).Name = "CalibratedMinus10";
variants(3).UseCalibration = true;
variants(3).Scale = 0.90;

variants(4).Name = "CalibratedPlus10";
variants(4).UseCalibration = true;
variants(4).Scale = 1.10;
end

function params = apply_threshold_table_local(params, T, scale)
for i = 1:height(T)
    name = string(T.Parameter(i));
    value = T.RecommendedValue(i) * scale;
    if isnan(value)
        continue;
    end
    params.(char(name)) = value;
end

params.utility_required_timely_qpos_high_threshold = clip_local( ...
    params.utility_required_timely_qpos_high_threshold, 0.55, 0.95);
params.utility_required_timely_qpos_low_threshold = clip_local( ...
    params.utility_required_timely_qpos_low_threshold, 0.25, 0.70);
if params.utility_required_timely_qpos_low_threshold ...
        >= params.utility_required_timely_qpos_high_threshold - 0.05
    params.utility_required_timely_qpos_high_threshold = 0.75;
    params.utility_required_timely_qpos_low_threshold = 0.50;
end

params.blind_zone_trigger_threshold = clip_local(params.blind_zone_trigger_threshold, 0.20, 0.85);
params.utility_required_protection_activation_pos = clip_local( ...
    params.utility_required_protection_activation_pos, 0.10, 0.70);
params.utility_required_protection_activation_blind = clip_local( ...
    params.utility_required_protection_activation_blind, 0.03, 0.35);
end

function T_sig = compute_significance_local(T_raw, scene_matrix, config_names)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
        T_case = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg, :);
        if isempty(T_case)
            continue;
        end
        T_case_stat = compute_step12_statistical_tests( ...
            T_case, "DefaultThresholds", "CalibratedThresholds");
        T_case_stat.Scene = repmat(scene_id, height(T_case_stat), 1);
        T_case_stat.Config = repmat(cfg, height(T_case_stat), 1);
        T_case_stat = movevars(T_case_stat, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table_local(T_sig, T_case_stat);
    end
end
end

function T_decision = build_decision_table_local(summary)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];

for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    def = subT(subT.Method == "DefaultThresholds", :);
    cal = subT(subT.Method == "CalibratedThresholds", :);
    low = subT(subT.Method == "CalibratedMinus10", :);
    high = subT(subT.Method == "CalibratedPlus10", :);
    heuristic = subT(subT.Method == "Confidence-heuristic", :);
    linkd = subT(subT.Method == "Link-delay-aware", :);
    if isempty(def) || isempty(cal)
        continue;
    end

    row = keys(i, :);
    row.TimelyDeltaCalVsDefault_pp = 100.0 * (cal.TimelyRateMean - def.TimelyRateMean);
    row.EmgDeltaCalVsDefault_pp = 100.0 * (cal.EmergencyTimelyRateMean - def.EmergencyTimelyRateMean);
    row.CostDeltaCalVsDefault_pct = pct_delta_local(cal.AvgTxCostMean, def.AvgTxCostMean);
    row.DelayDeltaCalVsDefault_pct = pct_delta_local(cal.AvgDelayMean, def.AvgDelayMean);

    if isempty(heuristic)
        row.EmgGainCalVsHeuristic_pp = NaN;
    else
        row.EmgGainCalVsHeuristic_pp = 100.0 * (cal.EmergencyTimelyRateMean - heuristic.EmergencyTimelyRateMean);
    end
    if isempty(linkd)
        row.TimelyGainCalVsLinkDelay_pp = NaN;
    else
        row.TimelyGainCalVsLinkDelay_pp = 100.0 * (cal.TimelyRateMean - linkd.TimelyRateMean);
    end

    perturb_timely = [];
    perturb_cost = [];
    if ~isempty(low)
        perturb_timely(end + 1) = 100.0 * (low.TimelyRateMean - cal.TimelyRateMean); %#ok<AGROW>
        perturb_cost(end + 1) = abs(pct_delta_local(low.AvgTxCostMean, cal.AvgTxCostMean)); %#ok<AGROW>
    end
    if ~isempty(high)
        perturb_timely(end + 1) = 100.0 * (high.TimelyRateMean - cal.TimelyRateMean); %#ok<AGROW>
        perturb_cost(end + 1) = abs(pct_delta_local(high.AvgTxCostMean, cal.AvgTxCostMean)); %#ok<AGROW>
    end
    row.WorstPerturbTimelyDelta_pp = min_or_nan_local(perturb_timely);
    row.MaxPerturbCostDelta_pct = max_or_nan_local(perturb_cost);
    row.StabilityFlag = classify_stability_local(row.WorstPerturbTimelyDelta_pp, row.MaxPerturbCostDelta_pct);
    rows = append_table_local(rows, row);
end

T_decision = rows;
end

function flag = classify_stability_local(worst_timely_pp, max_cost_pct)
if isnan(worst_timely_pp) || isnan(max_cost_pct)
    flag = "Insufficient";
elseif worst_timely_pp >= -1.0 && max_cost_pct <= 10.0
    flag = "Stable";
elseif worst_timely_pp >= -2.0 && max_cost_pct <= 20.0
    flag = "Borderline";
else
    flag = "Sensitive";
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
end

function value = min_or_nan_local(x)
if isempty(x)
    value = NaN;
else
    value = min(x);
end
end

function value = max_or_nan_local(x)
if isempty(x)
    value = NaN;
else
    value = max(x);
end
end

function T = normalize_threshold_table_local(T)
if ismember('Parameter', T.Properties.VariableNames)
    T.Parameter = string(T.Parameter);
else
    error('Threshold table is missing Parameter column.');
end
if ~ismember('RecommendedValue', T.Properties.VariableNames)
    error('Threshold table is missing RecommendedValue column.');
end
end

function path = get_threshold_table_path_local()
env_path = string(getenv('STEP44_THRESHOLD_TABLE'));
if strlength(env_path) > 0
    path = env_path;
    if ~isfile(path)
        error('STEP44_THRESHOLD_TABLE does not exist: %s', path);
    end
    return;
end

files = dir('step43_threshold_calibration_*_threshold_table.csv');
if isempty(files)
    error(['No Step43 threshold table found. Run main_step43_threshold_calibration first, ' ...
        'or set STEP44_THRESHOLD_TABLE to a threshold_table.csv path.']);
end
[~, idx] = max([files.datenum]);
path = string(files(idx).name);
end

function scenes = filter_scene_matrix_local(scene_matrix, scene_ids)
scenes = scene_matrix([]);
for i = 1:numel(scene_ids)
    matched = false;
    for j = 1:numel(scene_matrix)
        if scene_matrix(j).scene_id == scene_ids(i)
            scenes(end + 1) = scene_matrix(j); %#ok<AGROW>
            matched = true;
            break;
        end
    end
    if ~matched
        error('Unknown Step44 scene id: %s', scene_ids(i));
    end
end
end

function values = get_env_string_list_local(name, default_values)
raw = getenv(name);
if isempty(raw)
    values = default_values;
else
    parts = split(string(raw), ',');
    values = strtrim(parts(:)).';
    values = values(strlength(values) > 0);
end
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = string(raw);
end
end

function value = get_env_int_local(name, default_value)
raw = str2double(getenv(name));
if isnan(raw) || raw < 1
    value = default_value;
else
    value = round(raw);
end
end

function y = clip_local(x, lo, hi)
y = min(max(x, lo), hi);
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end

function write_report_local(T_decision, T_thresholds, threshold_table_path, out_path, num_seeds)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step44 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step44 Threshold Validation Report\n\n');
fprintf(fid, 'Purpose: test whether Step43 calibrated thresholds change or destabilize the proposed-method conclusion.\n\n');
fprintf(fid, '- Seeds per scene/config: %d\n', num_seeds);
fprintf(fid, '- Threshold table: `%s`\n\n', threshold_table_path);

fprintf(fid, '## Applied Thresholds\n\n');
fprintf(fid, '| Parameter | Default | Recommended |\n');
fprintf(fid, '|---|---:|---:|\n');
for i = 1:height(T_thresholds)
    fprintf(fid, '| `%s` | %.4f | %.4f |\n', ...
        T_thresholds.Parameter(i), T_thresholds.DefaultValue(i), T_thresholds.RecommendedValue(i));
end

fprintf(fid, '\n## Scene-Level Decision Table\n\n');
fprintf(fid, '| Scene | Config | Timely Cal-Default (pp) | Emg Cal-Default (pp) | Cost Cal-Default (%%) | Worst Perturb Timely (pp) | Max Perturb Cost (%%) | Stability |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.3f | %.2f | %s |\n', ...
        T_decision.Scene(i), T_decision.Config(i), ...
        T_decision.TimelyDeltaCalVsDefault_pp(i), ...
        T_decision.EmgDeltaCalVsDefault_pp(i), ...
        T_decision.CostDeltaCalVsDefault_pct(i), ...
        T_decision.WorstPerturbTimelyDelta_pp(i), ...
        T_decision.MaxPerturbCostDelta_pct(i), ...
        T_decision.StabilityFlag(i));
end

fprintf(fid, '\n## Interpretation Rule\n\n');
fprintf(fid, '`Stable` means the worst +/-10%% threshold perturbation loses less than 1 percentage point TimelyRate and changes cost by less than 10%%.\n');
fprintf(fid, 'If many rows are `Sensitive`, keep default thresholds and report Step43 as exploratory calibration evidence only.\n');
end
