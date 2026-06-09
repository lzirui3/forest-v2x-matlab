clc;
clear;
close all;

% Step50 finalizer: merge already-generated held-out case files only.
% It does not run simulations. Use this after the independent case workers
% have produced 50-seed raw/stage files for all held-out scene/config pairs.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP50_NUM_SEEDS', 50);
prefix = get_env_string_local('STEP50_PREFIX_TAG', ...
    "step50_per_lookup_heldout_validation_" + string(num_seeds) + "seed");
scene_ids = get_env_string_list_local('STEP50_SCENES', ...
    ["10013", "10007", "10015"]);
config_names = get_env_string_list_local('STEP50_CONFIGS', ["Default", "ForestGeometry"]);

scene_matrix = filter_scene_matrix_local(get_heldout_scene_matrix(), scene_ids);
merge_shards_into_cases_local(prefix, scene_matrix, config_names);
assert_case_completion_local(prefix, scene_matrix, config_names, num_seeds);

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
fprintf('Step50 finalize complete: merged PER-lookup held-out validation with %d seeds.\n', num_seeds);

function merge_shards_into_cases_local(prefix, scene_matrix, config_names)
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg);
        shard_raw_files = dir(sprintf('%s_%s_%s_shard_*_raw.csv', prefix, scene_id, cfg));
        shard_stage_files = dir(sprintf('%s_%s_%s_shard_*_stage_raw.csv', prefix, scene_id, cfg));
        if ~isempty(shard_raw_files)
            shard_raw_files = shard_raw_files(~contains(string({shard_raw_files.name}), "_stage_raw.csv"));
        end

        T_raw = read_optional_table_local(raw_path);
        for i = 1:numel(shard_raw_files)
            T_raw = append_table_local(T_raw, normalize_table_local(readtable(shard_raw_files(i).name, 'TextType', 'string')));
        end
        if ~isempty(T_raw)
            T_raw = sortrows(unique(T_raw, 'rows', 'stable'), {'Seed','Method'});
            [~, ia] = unique(T_raw(:, {'Seed','Method'}), 'rows', 'stable');
            T_raw = sortrows(T_raw(ia, :), {'Seed','Method'});
            writetable(T_raw, raw_path);
        end

        T_stage = read_optional_table_local(stage_path);
        for i = 1:numel(shard_stage_files)
            T_stage = append_table_local(T_stage, normalize_table_local(readtable(shard_stage_files(i).name, 'TextType', 'string')));
        end
        if ~isempty(T_stage)
            T_stage = sortrows(unique(T_stage, 'rows', 'stable'), {'Seed','Method','Stage'});
            [~, ia] = unique(T_stage(:, {'Seed','Method','Stage'}), 'rows', 'stable');
            T_stage = sortrows(T_stage(ia, :), {'Seed','Method','Stage'});
            writetable(T_stage, stage_path);
        end
    end
end
end

function T = read_optional_table_local(path)
if isfile(path)
    T = normalize_table_local(readtable(path, 'TextType', 'string'));
else
    T = [];
end
end

function assert_case_completion_local(prefix, scene_matrix, config_names, num_seeds)
for scene_idx = 1:numel(scene_matrix)
    scene_id = scene_matrix(scene_idx).scene_id;
    for cfg = config_names
        raw_path = sprintf('%s_%s_%s_raw.csv', prefix, scene_id, cfg);
        stage_path = sprintf('%s_%s_%s_stage_raw.csv', prefix, scene_id, cfg);
        if ~isfile(raw_path) || ~isfile(stage_path)
            error('Missing Step50 case output: %s / %s', raw_path, stage_path);
        end
        T_raw = normalize_table_local(readtable(raw_path, 'TextType', 'string'));
        T_stage = normalize_table_local(readtable(stage_path, 'TextType', 'string'));
        raw_seeds = unique(T_raw.Seed);
        stage_seeds = unique(T_stage.Seed);
        if numel(raw_seeds) ~= num_seeds || numel(stage_seeds) ~= num_seeds
            error('Incomplete Step50 case: scene=%s config=%s raw_seeds=%d stage_seeds=%d expected=%d', ...
                scene_id, cfg, numel(raw_seeds), numel(stage_seeds), num_seeds);
        end
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

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
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
