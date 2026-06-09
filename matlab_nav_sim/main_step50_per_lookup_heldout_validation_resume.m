clc;
clear;
close all;

% Step50: held-out validation under WiLabV2Xsim PER lookup.
% This is the PER-lookup counterpart of Step45. It freezes the current
% proposed method and evaluates unseen scenes without changing parameters.
% The script is resumable per scene/config and does not overwrite Step45/49.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP50_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP50_PREFIX_TAG', ...
    "step50_per_lookup_heldout_validation_" + string(num_seeds) + "seed");
scene_ids = get_env_string_list_local('STEP50_SCENES', ...
    ["10013", "10007", "10015"]);
config_names = get_env_string_list_local('STEP50_CONFIGS', ["Default", "ForestGeometry"]);
method_names = ["Link-delay-aware", "Confidence-heuristic", ...
    "Risk-constrained-v6", "Constrained Oracle"];

scene_matrix = filter_scene_matrix_local(get_heldout_scene_matrix(), scene_ids);
seed_list = 1:num_seeds;

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_meta.scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_meta.scene_id, cfg);
        [T_case_raw, T_case_stage] = read_existing_case_tables_local(raw_path, stage_path);

        if isempty(T_case_raw)
            existing_seeds = [];
        else
            existing_seeds = unique(T_case_raw.Seed).';
        end
        missing_seeds = setdiff(seed_list, existing_seeds, 'stable');
        fprintf('Step50 PER held-out resume: scene=%s config=%s existing=%d missing=%d\n', ...
            scene_meta.scene_id, cfg, numel(existing_seeds), numel(missing_seeds));

        for seed = missing_seeds
            [T_seed, T_stage_seed] = simulate_case_seed_local( ...
                scene_meta, scene_cfg, cfg, seed, method_names);
            T_case_raw = append_table_local(T_case_raw, T_seed);
            T_case_stage = append_table_local(T_case_stage, T_stage_seed);
            writetable(T_case_raw, raw_path);
            writetable(T_case_stage, stage_path);
        end
    end
end

[T_raw, T_stage] = merge_case_tables_local(prefix, scene_matrix, config_names);
summary = build_step17_summary_table(T_raw);
stage_summary = build_step17_stage_summary_table(T_stage);
sig_h = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "Confidence-heuristic", "Risk-constrained-v6");
sig_link = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "Link-delay-aware", "Risk-constrained-v6");
sig_oracle = compute_significance_local(T_raw, scene_matrix, config_names, ...
    "Risk-constrained-v6", "Constrained Oracle");
decision = build_decision_table_local(summary);

sig_h = apply_familywise_holm_to_stats_table(sig_h);
sig_link = apply_familywise_holm_to_stats_table(sig_link);
sig_oracle = apply_familywise_holm_to_stats_table(sig_oracle);

writetable(T_raw, prefix + "_raw.csv");
writetable(T_stage, prefix + "_stage_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(stage_summary, prefix + "_stage_summary.csv");
writetable(sig_h, prefix + "_heuristic_vs_v6_significance.csv");
writetable(sig_link, prefix + "_link_vs_v6_significance.csv");
writetable(sig_oracle, prefix + "_v6_vs_oracle_significance.csv");
writetable(decision, prefix + "_decision_table.csv");
write_report_local(decision, prefix + "_report.md", num_seeds);

disp(decision);
fprintf('Step50 complete: PER-lookup held-out validation generated with %d seeds.\n', num_seeds);

function [T_seed, T_stage_seed] = simulate_case_seed_local(scene_meta, scene_cfg, cfg, seed, method_names)
params = get_params_for_config_local(cfg);
params.scenario_input = scene_cfg;
params.random_seed = seed;
params.physical_pdr_mode = "per_lookup";

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    run_step9_proposed_method(scenario, params), ...
    rename_result_local(run_step9_baseline_oracle(scenario, params), "Constrained Oracle")};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_meta_columns_local(T_seed, scene_meta, cfg, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_meta_columns_local(T_stage_seed, scene_meta, cfg, seed);
end

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step50 config: %s', cfg);
end
end

function result = rename_result_local(result, name)
result.name = name;
end

function T = add_meta_columns_local(T, scene_meta, cfg, seed)
T.Scene = repmat(scene_meta.scene_id, height(T), 1);
T.SceneRole = repmat(scene_meta.scene_role, height(T), 1);
T.GeometryType = repmat(scene_meta.geometry_type, height(T), 1);
T.DensityClass = repmat(scene_meta.density_class, height(T), 1);
T.VegetationClass = repmat(scene_meta.vegetation_class, height(T), 1);
T.Config = repmat(cfg, height(T), 1);
T.PdrMode = repmat("per_lookup", height(T), 1);
T.Seed = repmat(seed, height(T), 1);
T = movevars(T, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Seed'}, 'Before', 'Method');
end

function [T_raw, T_stage] = read_existing_case_tables_local(raw_path, stage_path)
if isfile(raw_path)
    T_raw = normalize_table_local(readtable(raw_path, 'TextType', 'string'));
else
    T_raw = [];
end

if isfile(stage_path)
    T_stage = normalize_table_local(readtable(stage_path, 'TextType', 'string'));
else
    T_stage = [];
end
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function [T_raw, T_stage] = merge_case_tables_local(prefix, scene_matrix, config_names)
T_raw = [];
T_stage = [];
for scene_idx = 1:numel(scene_matrix)
    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_matrix(scene_idx).scene_id, cfg);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing Step50 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = append_table_local(T_raw, normalize_table_local(readtable(raw_path, 'TextType', 'string')));
        T_stage = append_table_local(T_stage, normalize_table_local(readtable(stage_path, 'TextType', 'string')));
    end
end
end

function T_sig = compute_significance_local(T_raw, scene_matrix, config_names, baseline_name, proposed_name)
T_sig = [];
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
        T_case = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg, :);
        if isempty(T_case)
            continue;
        end
        T_case_sig = compute_step12_statistical_tests(T_case, baseline_name, proposed_name);
        T_case_sig.Scene = repmat(scene_id, height(T_case_sig), 1);
        T_case_sig.Config = repmat(cfg, height(T_case_sig), 1);
        T_case_sig = movevars(T_case_sig, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table_local(T_sig, T_case_sig);
    end
end
end

function decision = build_decision_table_local(summary)
keys = unique(summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];

for i = 1:height(keys)
    subT = summary(summary.Scene == keys.Scene(i) & summary.Config == keys.Config(i), :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    link = subT(subT.Method == "Link-delay-aware", :);
    v6 = subT(subT.Method == "Risk-constrained-v6", :);
    oracle = subT(subT.Method == "Constrained Oracle", :);
    if isempty(v6) || isempty(h)
        continue;
    end

    row = keys(i, :);
    row.TimelyGainVsHeuristic_pp = 100.0 * (v6.TimelyRateMean - h.TimelyRateMean);
    row.EmgGainVsHeuristic_pp = 100.0 * (v6.EmergencyTimelyRateMean - h.EmergencyTimelyRateMean);
    row.CostDeltaVsHeuristic_pct = pct_delta_local(v6.AvgTxCostMean, h.AvgTxCostMean);
    row.DelayDeltaVsHeuristic_pct = pct_delta_local(v6.AvgDelayMean, h.AvgDelayMean);
    if isempty(link)
        row.TimelyGainVsLink_pp = NaN;
    else
        row.TimelyGainVsLink_pp = 100.0 * (v6.TimelyRateMean - link.TimelyRateMean);
    end
    if isempty(oracle)
        row.OracleMinusV6Timely_pp = NaN;
    else
        row.OracleMinusV6Timely_pp = 100.0 * (oracle.TimelyRateMean - v6.TimelyRateMean);
    end
    row.Decision = classify_case_local(row.TimelyGainVsHeuristic_pp, ...
        row.EmgGainVsHeuristic_pp, row.TimelyGainVsLink_pp, row.CostDeltaVsHeuristic_pct);
    rows = append_table_local(rows, row);
end

decision = rows;
end

function label = classify_case_local(timely_h_pp, emg_h_pp, timely_link_pp, cost_pct)
if timely_h_pp >= 1.0 || emg_h_pp >= 1.0
    label = "PerLookupHeldoutStrong";
elseif timely_h_pp >= -0.1 && emg_h_pp >= -0.25 && timely_link_pp >= 0.0
    if cost_pct <= 15.0
        label = "PerLookupHeldoutWeak";
    else
        label = "PerLookupHeldoutCostly";
    end
elseif timely_h_pp >= -0.75 && emg_h_pp >= -0.75
    label = "PerLookupHeldoutBoundary";
else
    label = "PerLookupHeldoutRisk";
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
end

function write_report_local(decision, out_path, num_seeds)
fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step50 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step50 PER Lookup Held-Out Validation Report\n\n');
fprintf(fid, 'PDR mode is fixed to `per_lookup` for all held-out cases.\n\n');
fprintf(fid, 'Seeds per scene/config: %d.\n\n', num_seeds);
fprintf(fid, 'Held-out scenes: `10013`, `10007`, `10015`.\n\n');
fprintf(fid, '| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain vs heuristic (pp) | Timely gain vs link (pp) | Cost delta vs heuristic (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f | %.2f | %s |\n', ...
        string(decision.Scene(i)), string(decision.Config(i)), ...
        decision.TimelyGainVsHeuristic_pp(i), decision.EmgGainVsHeuristic_pp(i), ...
        decision.TimelyGainVsLink_pp(i), decision.CostDeltaVsHeuristic_pct(i), ...
        string(decision.Decision(i)));
end

fprintf(fid, '\nInterpretation: this is the held-out counterpart of Step49 under the final PER lookup physical-layer setting. It must be used together with Step49 before making final VTC claims.\n');
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
        error('Unknown Step50 held-out scene id: %s', scene_ids(i));
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
