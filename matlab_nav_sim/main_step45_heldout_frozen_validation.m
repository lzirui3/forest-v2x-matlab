clc;
clear;
close all;

% Step45: frozen-parameter held-out validation.
% The proposed scheduler and parameter files are not modified here. This
% script only evaluates fixed Risk-constrained-v6 settings on scenes that
% were not used in Step40.

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP45_NUM_SEEDS', 50);
seed_list = 1:num_seeds;
scene_matrix = filter_scene_matrix_local(get_heldout_scene_matrix(), ...
    get_env_string_list_local('STEP45_SCENES', ["10013", "10007", "10015"]));
config_names = get_env_string_list_local('STEP45_CONFIGS', ["Default", "ForestGeometry"]);
prefix = get_env_string_local('STEP45_PREFIX_TAG', ...
    "step45_heldout_frozen_validation_" + string(num_seeds) + "seed");

method_names = ["Link-delay-aware", "Confidence-heuristic", ...
    "V4Cost0060", "Risk-constrained-v6", "Constrained Oracle"];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_meta.scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg_name);
        [T_case_raw, T_case_stage] = read_existing_case_tables_local(raw_path, stage_path);

        if isempty(T_case_raw)
            existing_seeds = [];
        else
            existing_seeds = unique(T_case_raw.Seed).';
        end
        missing_seeds = setdiff(seed_list, existing_seeds, 'stable');

        fprintf('Step45 held-out frozen: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_meta.scene_id, cfg_name, numel(existing_seeds), numel(missing_seeds));

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_case_seed_local( ...
                scene_meta, scene_cfg, cfg_name, seed, method_names);

            T_case_raw = append_table_local(T_case_raw, T_seed);
            T_case_stage = append_table_local(T_case_stage, T_stage_seed);
            writetable(T_case_raw, raw_path);
            writetable(T_case_stage, stage_path);
        end
    end
end

[T_raw, T_stage_raw] = merge_case_tables_local(prefix, scene_matrix, config_names);
T_summary = build_step17_summary_table(T_raw);
T_stage_summary = build_step17_stage_summary_table(T_stage_raw);
T_sig_h_vs_v6 = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "Confidence-heuristic", "Risk-constrained-v6");
T_sig_link_vs_v6 = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "Link-delay-aware", "Risk-constrained-v6");
T_sig_v4_vs_v6 = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "V4Cost0060", "Risk-constrained-v6");
T_decision = build_decision_table_local(T_summary);

T_sig_h_vs_v6 = apply_familywise_holm_to_stats_table(T_sig_h_vs_v6);
T_sig_link_vs_v6 = apply_familywise_holm_to_stats_table(T_sig_link_vs_v6);
T_sig_v4_vs_v6 = apply_familywise_holm_to_stats_table(T_sig_v4_vs_v6);

writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage_raw, prefix + "_stage_raw.csv");
writetable(T_summary, prefix + "_summary.csv");
writetable(T_stage_summary, prefix + "_stage_summary.csv");
writetable(T_sig_h_vs_v6, prefix + "_heuristic_vs_v6_significance.csv");
writetable(T_sig_link_vs_v6, prefix + "_link_vs_v6_significance.csv");
writetable(T_sig_v4_vs_v6, prefix + "_v4_vs_v6_significance.csv");
writetable(T_decision, prefix + "_decision_table.csv");
write_report_local(T_summary, T_decision, T_sig_h_vs_v6, ...
    T_sig_link_vs_v6, T_sig_v4_vs_v6, prefix + "_report.md", num_seeds);

disp(T_decision);
fprintf('Step45 complete: frozen held-out validation generated with %d seeds x %d scenes x %d configs.\n', ...
    num_seeds, numel(scene_matrix), numel(config_names));

function [T_seed, T_stage_seed] = simulate_case_seed_local(scene_meta, scene_cfg, cfg_name, seed, method_names)
if cfg_name == "Default"
    params = get_default_step9_mainline_params();
elseif cfg_name == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step45 config: %s', cfg_name);
end

params.scenario_input = scene_cfg;
params.random_seed = seed;

scenario = generate_step9_scenario(params);
v4_params = params;
v4_params.risk_v4_actual_cost_weight = 0.060;

results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    rename_result_local(run_step9_confidence_driven_risk_constrained_v4(scenario, v4_params), "V4Cost0060"), ...
    run_step9_proposed_method(scenario, params), ...
    rename_result_local(run_step9_baseline_oracle(scenario, params), "Constrained Oracle")};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_meta_columns_local(T_seed, scene_meta, cfg_name, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_meta_columns_local(T_stage_seed, scene_meta, cfg_name, seed);
end

function result = rename_result_local(result, name)
result.name = name;
end

function T = add_meta_columns_local(T, scene_meta, cfg_name, seed)
T.Scene = repmat(scene_meta.scene_id, height(T), 1);
T.SceneRole = repmat(scene_meta.scene_role, height(T), 1);
T.GeometryType = repmat(scene_meta.geometry_type, height(T), 1);
T.DensityClass = repmat(scene_meta.density_class, height(T), 1);
T.VegetationClass = repmat(scene_meta.vegetation_class, height(T), 1);
T.Config = repmat(cfg_name, height(T), 1);
T.Seed = repmat(seed, height(T), 1);
T = movevars(T, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, ...
    'Before', 'Method');
end

function [T_raw, T_stage] = read_existing_case_tables_local(raw_path, stage_path)
if isfile(raw_path)
    T_raw = normalize_case_table_local(readtable(raw_path));
else
    T_raw = [];
end

if isfile(stage_path)
    T_stage = normalize_case_table_local(readtable(stage_path));
else
    T_stage = [];
end
end

function T = normalize_case_table_local(T)
if isempty(T)
    return;
end

string_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method','Stage'};
for i = 1:numel(string_vars)
    name = string_vars{i};
    if ismember(name, T.Properties.VariableNames)
        T.(name) = string(T.(name));
    end
end
end

function [T_raw, T_stage_raw] = merge_case_tables_local(prefix, scene_matrix, config_names)
T_raw = [];
T_stage_raw = [];

for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg_name);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg_name);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing Step45 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table_local(T_raw, normalize_case_table_local(readtable(raw_path)));
        T_stage_raw = append_table_local(T_stage_raw, normalize_case_table_local(readtable(stage_path)));
    end
end
end

function T_sig = compute_significance_local(T_raw, scene_matrix, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg_idx = 1:numel(config_names)
        cfg_name = config_names(cfg_idx);
        T_cfg = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, baseline_name, proposed_name);
        T_cfg_stat.Scene = repmat(scene_id, height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(cfg_name, height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table_local(T_sig, T_cfg_stat);
    end
end
end

function T_decision = build_decision_table_local(T_summary)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i);
    subT = T_summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    l = subT(subT.Method == "Link-delay-aware", :);
    v4 = subT(subT.Method == "V4Cost0060", :);
    v6 = subT(subT.Method == "Risk-constrained-v6", :);
    o = subT(subT.Method == "Constrained Oracle", :);
    if isempty(h) || isempty(v6)
        continue;
    end

    timely_gap_h_pp = 100.0 * (v6.TimelyRateMean - h.TimelyRateMean);
    emg_gap_h_pp = 100.0 * (v6.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
    cost_delta_h_pct = pct_delta_local(v6.AvgTxCostMean, h.AvgTxCostMean);
    delay_delta_h_pct = pct_delta_local(v6.AvgDelayMean, h.AvgDelayMean);

    if isempty(l)
        timely_gap_link_pp = NaN;
        emg_gap_link_pp = NaN;
    else
        timely_gap_link_pp = 100.0 * (v6.TimelyRateMean - l.TimelyRateMean);
        emg_gap_link_pp = 100.0 * (v6.EmergencyTimelyRateMean - l.EmergencyTimelyRateMean);
    end

    if isempty(v4)
        emg_gain_v4_pp = NaN;
        cost_delta_v4_pct = NaN;
    else
        emg_gain_v4_pp = 100.0 * (v6.EmergencyTimelyRateMean - v4.EmergencyTimelyRateMean);
        cost_delta_v4_pct = pct_delta_local(v6.AvgTxCostMean, v4.AvgTxCostMean);
    end

    if isempty(o)
        oracle_timely_gap_pp = NaN;
    else
        oracle_timely_gap_pp = 100.0 * (o.TimelyRateMean - v6.TimelyRateMean);
    end

    decision = classify_heldout_row_local(timely_gap_h_pp, timely_gap_link_pp, emg_gap_h_pp, cost_delta_h_pct);

    row = table(keys.Scene(i), keys.SceneRole(i), keys.GeometryType(i), ...
        keys.DensityClass(i), keys.VegetationClass(i), keys.Config(i), ...
        h.TimelyRateMean, v6.TimelyRateMean, timely_gap_h_pp, ...
        h.EmergencyTimelyRateMean, v6.EmergencyTimelyRateMean, emg_gap_h_pp, ...
        h.AvgTxCostMean, v6.AvgTxCostMean, cost_delta_h_pct, ...
        h.AvgDelayMean, v6.AvgDelayMean, delay_delta_h_pct, ...
        timely_gap_link_pp, emg_gap_link_pp, emg_gain_v4_pp, cost_delta_v4_pct, ...
        oracle_timely_gap_pp, string(decision), ...
        'VariableNames', {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
        'HeuristicTimely','V6Timely','V6MinusHeuristicTimely_pp', ...
        'HeuristicEmgTimely','V6EmgTimely','V6MinusHeuristicEmg_pp', ...
        'HeuristicTxCost','V6TxCost','V6CostDeltaPct', ...
        'HeuristicDelay','V6Delay','V6DelayDeltaPct', ...
        'V6MinusLinkTimely_pp','V6MinusLinkEmg_pp', ...
        'V6MinusV4Emg_pp','V6CostDeltaVsV4Pct','OracleMinusV6Timely_pp','HeldoutDecision'});
    rows = append_table_local(rows, row);
end

T_decision = rows;
end

function decision = classify_heldout_row_local(timely_gap_h_pp, timely_gap_link_pp, emg_gap_h_pp, cost_delta_h_pct)
if timely_gap_h_pp >= 1.0 && timely_gap_link_pp >= 1.0 && emg_gap_h_pp >= -0.25 && cost_delta_h_pct <= 30.0
    decision = "GeneralizesStrong";
elseif timely_gap_h_pp >= 0.0 && timely_gap_link_pp >= 0.0 && emg_gap_h_pp >= -0.50 && cost_delta_h_pct <= 35.0
    decision = "GeneralizesWeak";
elseif timely_gap_h_pp >= -0.50 && emg_gap_h_pp >= -0.50 && cost_delta_h_pct <= 35.0
    decision = "GracefulBoundary";
else
    decision = "HeldoutRisk";
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
end

function write_report_local(T_summary, T_decision, T_sig_h_vs_v6, T_sig_link_vs_v6, T_sig_v4_vs_v6, out_path, num_seeds)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step45 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step45 Frozen-Parameter Held-Out Validation Report\n\n');
fprintf(fid, 'Purpose: test overfitting risk by freezing the Step40 main method and evaluating unseen V2X-Seq scenes without retuning.\n\n');
fprintf(fid, 'Frozen method: `Risk-constrained-v6` through `run_step9_proposed_method.m`.\n');
fprintf(fid, 'No parameter file is modified by this script. V4 uses the same Step40 ablation cost weight `0.060`.\n\n');
fprintf(fid, '- Seeds per scene/config: %d\n', num_seeds);
fprintf(fid, '- Held-out scenes: `10013`, `10007`, `10015`\n');
fprintf(fid, '- Configs: `Default`, `ForestGeometry`\n\n');

fprintf(fid, '## Held-Out Scene Rationale\n\n');
fprintf(fid, '| Scene | Role | Geometry | Density | Vegetation | Rationale |\n');
fprintf(fid, '|---|---|---|---|---|---|\n');
fprintf(fid, '| 10013 | HeldOutHighNLOS | ShortHighNLOS | High | Dense | High-NLOS short-range unseen scene. |\n');
fprintf(fid, '| 10007 | HeldOutLongMixed | LongMixed | Medium | Mixed | Long-range mixed unseen scene. |\n');
fprintf(fid, '| 10015 | HeldOutBoundary | LongLowNLOS | Low | Sparse | Low-NLOS long-range boundary scene. |\n\n');

fprintf(fid, '## Decision Table\n\n');
fprintf(fid, '| Scene | Config | Timely Gap vs Heuristic (pp) | Emergency Gap vs Heuristic (pp) | Cost Delta vs Heuristic (%%) | Delay Delta vs Heuristic (%%) | Timely Gap vs Link (pp) | Emergency Gain vs V4 (pp) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.2f | %.3f | %.3f | %s |\n', ...
        text_value_local(T_decision.Scene, i), text_value_local(T_decision.Config, i), ...
        T_decision.V6MinusHeuristicTimely_pp(i), T_decision.V6MinusHeuristicEmg_pp(i), ...
        T_decision.V6CostDeltaPct(i), T_decision.V6DelayDeltaPct(i), ...
        T_decision.V6MinusLinkTimely_pp(i), T_decision.V6MinusV4Emg_pp(i), ...
        text_value_local(T_decision.HeldoutDecision, i));
end

fprintf(fid, '\n## Method Means\n\n');
fprintf(fid, '| Scene | Config | Method | Timely Rate | Emergency Timely | Avg Cost | Avg Delay |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value_local(T_summary.Scene, i), text_value_local(T_summary.Config, i), ...
        text_value_local(T_summary.Method, i), T_summary.TimelyRateMean(i), ...
        T_summary.EmergencyTimelyRateMean(i), T_summary.AvgTxCostMean(i), ...
        T_summary.AvgDelayMean(i));
end

fprintf(fid, '\n## Significance Row Counts\n\n');
fprintf(fid, '- Heuristic vs v6 rows: %d\n', height(T_sig_h_vs_v6));
fprintf(fid, '- Link-delay-aware vs v6 rows: %d\n', height(T_sig_link_vs_v6));
fprintf(fid, '- V4Cost0060 vs v6 rows: %d\n\n', height(T_sig_v4_vs_v6));

fprintf(fid, '## Interpretation Rule\n\n');
fprintf(fid, 'This held-out validation is not a new tuning loop. Results should be interpreted as frozen-parameter generalization evidence. ');
fprintf(fid, 'Rows marked `GeneralizesStrong` support out-of-sample benefit. `GeneralizesWeak` supports non-negative transfer with limited gain. ');
fprintf(fid, '`GracefulBoundary` indicates acceptable non-degradation on a boundary scene. `HeldoutRisk` should be discussed as evidence of limited applicability.\n');
end

function value = text_value_local(col, idx)
value = char(string(col(idx)));
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
        error('Unknown Step45 held-out scene id: %s', scene_ids(i));
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

function T = append_table_local(T, rows)
if isempty(rows)
    return;
end

if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
