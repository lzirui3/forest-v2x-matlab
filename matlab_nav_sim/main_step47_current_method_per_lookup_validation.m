clc;
clear;
close all;

% Step47: PER lookup validation for the final proposed method.
% This step does not change Step40/45 results. It only compares whether
% sigmoid vs WiLabV2Xsim PER-table lookup changes end-to-end conclusions.

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_env_int_local('STEP47_NUM_SEEDS', 10);
scene_ids = get_env_string_list_local('STEP47_SCENES', ...
    ["10014", "10006", "10011", "10019", "10017"]);
config_names = get_env_string_list_local('STEP47_CONFIGS', ["Default", "ForestGeometry"]);
prefix = get_env_string_local('STEP47_PREFIX_TAG', ...
    "step47_current_method_per_lookup_validation_" + string(num_seeds) + "seed");

pdr_modes = ["sigmoid", "per_lookup"];
method_names = ["Link-delay-aware", "Confidence-heuristic", ...
    "Risk-constrained-v6", "Constrained Oracle"];

scene_matrix = filter_scene_matrix_local(get_paper_scene_matrix(), scene_ids);
rows = [];
stage_rows = [];

for scene_idx = 1:numel(scene_matrix)
    scene_meta = scene_matrix(scene_idx);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_meta.scene_id);

    for cfg = config_names
        for pdr_mode = pdr_modes
            for seed = 1:num_seeds
                fprintf('Step47 PER validation: scene=%s config=%s pdr=%s seed=%d/%d\n', ...
                    scene_meta.scene_id, cfg, pdr_mode, seed, num_seeds);
                [T_seed, T_stage_seed] = simulate_case_local( ...
                    scene_meta, scene_cfg, cfg, pdr_mode, seed, method_names);
                rows = append_table_local(rows, T_seed);
                stage_rows = append_table_local(stage_rows, T_stage_seed);
            end
        end
    end
end

delta = build_delta_table_local(rows);
stage_delta = build_delta_table_local(stage_rows(stage_rows.Stage == "PosDeg_Emerg", :));
sig = build_significance_table_local(rows);
stage_sig = build_significance_table_local(stage_rows(stage_rows.Stage == "PosDeg_Emerg", :));
decision = build_decision_table_local(delta);

writetable(rows, prefix + "_raw.csv");
writetable(stage_rows, prefix + "_stage_raw.csv");
writetable(delta, prefix + "_overall_delta.csv");
writetable(stage_delta, prefix + "_posdeg_delta.csv");
writetable(sig, prefix + "_overall_significance.csv");
writetable(stage_sig, prefix + "_posdeg_significance.csv");
writetable(decision, prefix + "_decision_table.csv");
write_report_local(delta, stage_delta, sig, stage_sig, decision, prefix + "_report.md");

disp(decision);
fprintf('Step47 complete: current-method PER lookup validation written with prefix %s.\n', prefix);

function [T_seed, T_stage_seed] = simulate_case_local(scene_meta, scene_cfg, cfg, pdr_mode, seed, method_names)
params = get_params_for_config_local(cfg);
params.scenario_input = scene_cfg;
params.random_seed = seed;
params.physical_pdr_mode = pdr_mode;

scenario = generate_step9_scenario(params);
results = { ...
    run_step9_baseline_link_delayaware(scenario, params), ...
    run_step9_confidence_driven_heuristic(scenario, params), ...
    run_step9_proposed_method(scenario, params), ...
    rename_result_local(run_step9_baseline_oracle(scenario, params), "Constrained Oracle")};

T_seed = evaluate_step9_metrics(scenario, results);
T_seed = add_meta_columns_local(T_seed, scene_meta, cfg, pdr_mode, seed);

stages = define_step9_stage_masks(scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
end
T_stage_seed = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
T_stage_seed = add_meta_columns_local(T_stage_seed, scene_meta, cfg, pdr_mode, seed);
end

function params = get_params_for_config_local(cfg)
if cfg == "Default"
    params = get_default_step9_mainline_params();
elseif cfg == "ForestGeometry"
    params = get_forest_geometry_mainline_params();
else
    error('Unknown Step47 config: %s', cfg);
end
end

function result = rename_result_local(result, name)
result.name = name;
end

function T = add_meta_columns_local(T, scene_meta, cfg, pdr_mode, seed)
T.Scene = repmat(scene_meta.scene_id, height(T), 1);
T.SceneRole = repmat(scene_meta.scene_role, height(T), 1);
T.GeometryType = repmat(scene_meta.geometry_type, height(T), 1);
T.DensityClass = repmat(scene_meta.density_class, height(T), 1);
T.VegetationClass = repmat(scene_meta.vegetation_class, height(T), 1);
T.Config = repmat(cfg, height(T), 1);
T.PdrMode = repmat(pdr_mode, height(T), 1);
T.Seed = repmat(seed, height(T), 1);
T = movevars(T, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Seed'}, 'Before', 'Method');
end

function T_delta = build_delta_table_local(T_raw)
key_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method'};
keys = unique(T_raw(:, key_vars), 'rows', 'stable');
metrics = {'TimelyRate', 'LossRate', 'AvgDelay_s', 'AvgTxCost', 'EmergencyTimelyRate'};
metric_labels = ["TimelyRate", "LossRate", "AvgDelay", "AvgTxCost", "EmgTimely"];
rows = [];

for i = 1:height(keys)
    base_mask = true(height(T_raw), 1);
    for k = 1:numel(key_vars)
        name = key_vars{k};
        base_mask = base_mask & T_raw.(name) == keys.(name)(i);
    end
    sig = T_raw(base_mask & T_raw.PdrMode == "sigmoid", :);
    per = T_raw(base_mask & T_raw.PdrMode == "per_lookup", :);
    if isempty(sig) || isempty(per)
        continue;
    end
    sig = sortrows(sig, 'Seed');
    per = sortrows(per, 'Seed');

    for m = 1:numel(metrics)
        vals_sig = sig.(metrics{m});
        vals_per = per.(metrics{m});
        d = vals_per - vals_sig;
        row = keys(i, :);
        row.Metric = metric_labels(m);
        row.SigmoidMean = mean(vals_sig, 'omitnan');
        row.PerLookupMean = mean(vals_per, 'omitnan');
        row.DeltaMean = mean(d, 'omitnan');
        row.DeltaCI95 = ci95_local(d);
        row.MaxAbsDelta = max(abs(d));
        row.DeltaPctOrPp = compute_delta_display_local(metric_labels(m), row.DeltaMean, row.SigmoidMean);
        rows = append_table_local(rows, row);
    end
end
T_delta = rows;
end

function T_sig = build_significance_table_local(T_raw)
key_vars = {'Scene','Config','Method'};
keys = unique(T_raw(:, key_vars), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = T_raw.Scene == keys.Scene(i) ...
        & T_raw.Config == keys.Config(i) ...
        & T_raw.Method == keys.Method(i);
    subT = T_raw(mask, :);
    sig = subT(subT.PdrMode == "sigmoid", :);
    per = subT(subT.PdrMode == "per_lookup", :);
    if isempty(sig) || isempty(per)
        continue;
    end
    sig = sortrows(sig, 'Seed');
    per = sortrows(per, 'Seed');
    sig.Method = repmat("Sigmoid", height(sig), 1);
    per.Method = repmat("PerLookup", height(per), 1);
    T_case = compute_step12_statistical_tests([sig; per], "Sigmoid", "PerLookup");
    T_case.Scene = repmat(keys.Scene(i), height(T_case), 1);
    T_case.Config = repmat(keys.Config(i), height(T_case), 1);
    T_case.TargetMethod = repmat(keys.Method(i), height(T_case), 1);
    T_case = movevars(T_case, {'Scene','Config','TargetMethod'}, 'Before', 'Metric');
    rows = append_table_local(rows, T_case);
end
T_sig = rows;
end

function T_decision = build_decision_table_local(T_delta)
prop = T_delta(T_delta.Method == "Risk-constrained-v6", :);
keys = unique(prop(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = prop.Scene == keys.Scene(i) & prop.Config == keys.Config(i);
    subT = prop(mask, :);
    row = keys(i, :);
    row.TimelyDelta_pp = get_metric_delta_local(subT, "TimelyRate");
    row.EmgDelta_pp = get_metric_delta_local(subT, "EmgTimely");
    row.LossDelta_pp = get_metric_delta_local(subT, "LossRate");
    row.DelayDelta_pct = get_metric_delta_local(subT, "AvgDelay");
    row.CostDelta_pct = get_metric_delta_local(subT, "AvgTxCost");
    row.MaxAbsRateDelta_pp = max(abs([row.TimelyDelta_pp, row.EmgDelta_pp, row.LossDelta_pp]));
    row.Decision = classify_per_effect_local(row.MaxAbsRateDelta_pp, row.DelayDelta_pct, row.CostDelta_pct);
    rows = append_table_local(rows, row);
end

T_decision = rows;
end

function value = get_metric_delta_local(T, metric)
subT = T(T.Metric == metric, :);
if isempty(subT)
    value = NaN;
else
    value = subT.DeltaPctOrPp(1);
end
end

function decision = classify_per_effect_local(max_rate_delta_pp, delay_delta_pct, cost_delta_pct)
if max_rate_delta_pp <= 1.0 && abs(delay_delta_pct) <= 5.0 && abs(cost_delta_pct) <= 5.0
    decision = "ApproximationStable";
elseif max_rate_delta_pp <= 2.0 && abs(delay_delta_pct) <= 10.0 && abs(cost_delta_pct) <= 10.0
    decision = "SmallBiasDiscuss";
else
    decision = "MaterialBias";
end
end

function value = compute_delta_display_local(metric, delta, sigmoid_mean)
if metric == "TimelyRate" || metric == "LossRate" || metric == "EmgTimely"
    value = 100.0 * delta;
elseif metric == "AvgDelay" || metric == "AvgTxCost"
    value = 100.0 * delta / max(abs(sigmoid_mean), 1.0e-12);
else
    value = delta;
end
end

function value = ci95_local(x)
x = x(~isnan(x));
if isempty(x)
    value = NaN;
else
    value = 1.96 * std(x, 0) / sqrt(numel(x));
end
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
        error('Unknown Step47 scene id: %s', scene_ids(i));
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
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end

function write_report_local(delta, stage_delta, sig, stage_sig, decision, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step47 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step47 Current-Method PER Lookup Validation Report\n\n');
fprintf(fid, 'Purpose: verify whether replacing the fitted sigmoid SINR-to-PDR approximation with WiLabV2Xsim PER-table lookup changes final-method conclusions.\n\n');
fprintf(fid, 'Compared PDR modes: `sigmoid` vs `per_lookup`.\n\n');
fprintf(fid, 'Target proposed method: `Risk-constrained-v6`.\n\n');

fprintf(fid, '## Decision Table\n\n');
fprintf(fid, '| Scene | Config | Timely delta (pp) | Emergency delta (pp) | Loss delta (pp) | Delay delta (%%) | Cost delta (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f | %.2f | %.2f | %s |\n', ...
        string(decision.Scene(i)), string(decision.Config(i)), ...
        decision.TimelyDelta_pp(i), decision.EmgDelta_pp(i), ...
        decision.LossDelta_pp(i), decision.DelayDelta_pct(i), ...
        decision.CostDelta_pct(i), string(decision.Decision(i)));
end

fprintf(fid, '\n## Overall Delta Table\n\n');
write_markdown_table_local(fid, delta);
fprintf(fid, '\n## PosDeg_Emerg Delta Table\n\n');
write_markdown_table_local(fid, stage_delta);
fprintf(fid, '\n## Overall Significance\n\n');
write_markdown_table_local(fid, sig);
fprintf(fid, '\n## PosDeg_Emerg Significance\n\n');
write_markdown_table_local(fid, stage_sig);

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- `ApproximationStable` means rate deltas are within 1 percentage point and delay/cost deltas are within 5%%.\n');
fprintf(fid, '- `SmallBiasDiscuss` means the approximation is usable but should be explicitly discussed.\n');
fprintf(fid, '- `MaterialBias` means final results should either use PER lookup or report sigmoid approximation as a limitation.\n');
end

function write_markdown_table_local(fid, T)
if isempty(T)
    fprintf(fid, '_No data_\n');
    return;
end

headers = string(T.Properties.VariableNames);
fprintf(fid, '| %s |\n', strjoin(headers, ' | '));
fprintf(fid, '| %s |\n', strjoin(repmat("---", size(headers)), ' | '));
for r = 1:height(T)
    cells = strings(1, width(T));
    for c = 1:width(T)
        v = T{r, c};
        if isnumeric(v)
            if isscalar(v)
                cells(c) = string(sprintf('%.4g', v));
            else
                cells(c) = strjoin(string(v), ',');
            end
        else
            cells(c) = string(v);
        end
    end
    fprintf(fid, '| %s |\n', strjoin(cells, ' | '));
end
end
