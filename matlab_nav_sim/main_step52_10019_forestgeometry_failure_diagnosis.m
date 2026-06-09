clc;
clear;
close all;

% Step52: focused diagnosis for the negative PER-lookup case.
% This script does not tune parameters. It reads Step49 outputs and explains
% why scene 10019 / ForestGeometry is an applicability boundary.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = get_env_string_local('STEP52_SOURCE_PREFIX', ...
    "step49_per_lookup_final_validation_50seed");
target_scene = get_env_string_local('STEP52_SCENE', "10019");
target_config = get_env_string_local('STEP52_CONFIG', "ForestGeometry");
out_prefix = get_env_string_local('STEP52_PREFIX_TAG', ...
    "step52_10019_forestgeometry");

raw = normalize_table_local(read_required_table_local(prefix + "_raw.csv"));
stage_raw = normalize_table_local(read_required_table_local(prefix + "_stage_raw.csv"));
summary = normalize_table_local(read_required_table_local(prefix + "_summary.csv"));
stage_summary = normalize_table_local(read_required_table_local(prefix + "_stage_summary.csv"));
decision = normalize_table_local(read_required_table_local(prefix + "_decision_table.csv"));

case_raw = raw(raw.Scene == target_scene & raw.Config == target_config, :);
case_stage_raw = stage_raw(stage_raw.Scene == target_scene & stage_raw.Config == target_config, :);
case_summary = summary(summary.Scene == target_scene & summary.Config == target_config, :);
case_stage_summary = stage_summary(stage_summary.Scene == target_scene & stage_summary.Config == target_config, :);
case_decision = decision(decision.Scene == target_scene & decision.Config == target_config, :);

if isempty(case_raw) || isempty(case_summary) || isempty(case_decision)
    error('Missing Step52 target case data: scene=%s config=%s source=%s', ...
        target_scene, target_config, prefix);
end

overall_delta = build_overall_delta_local(case_summary);
stage_delta = build_stage_delta_local(case_stage_summary);
seed_delta = build_seed_delta_local(case_raw);
significance_rows = read_significance_rows_local(prefix, target_scene, target_config);
main_failure = summarize_failure_local(overall_delta, stage_delta, case_decision);

writetable(overall_delta, out_prefix + "_overall_delta.csv");
writetable(stage_delta, out_prefix + "_stage_delta.csv");
writetable(seed_delta, out_prefix + "_seed_delta.csv");
writetable(significance_rows, out_prefix + "_significance_rows.csv");
writetable(main_failure, out_prefix + "_failure_summary.csv");
write_report_local(out_prefix + "_failure_diagnosis_cn.md", prefix, ...
    target_scene, target_config, case_decision, overall_delta, ...
    stage_delta, significance_rows, main_failure);

disp(main_failure);
fprintf('Step52 complete: negative-case diagnosis generated for scene=%s config=%s.\n', ...
    target_scene, target_config);

function T = build_overall_delta_local(case_summary)
baselines = ["Confidence-heuristic", "Link-delay-aware", "Constrained Oracle"];
metrics = ["TimelyRate", "EmergencyTimelyRate", "LossRate", "AvgDelay", "AvgTxCost"];
metric_cols = ["TimelyRateMean", "EmergencyTimelyRateMean", "LossRateMean", "AvgDelayMean", "AvgTxCostMean"];
rows = [];
v6 = get_method_row_local(case_summary, "Risk-constrained-v6");

for b = baselines
    base = get_method_row_local(case_summary, b);
    for i = 1:numel(metrics)
        base_value = base.(metric_cols(i));
        v6_value = v6.(metric_cols(i));
        delta = v6_value - base_value;
        if metrics(i) == "TimelyRate" || metrics(i) == "EmergencyTimelyRate" || metrics(i) == "LossRate"
            delta_pct_or_pp = 100.0 * delta;
            unit = "pp";
        else
            delta_pct_or_pp = pct_delta_local(v6_value, base_value);
            unit = "pct";
        end
        row = table(b, metrics(i), base_value, v6_value, delta, delta_pct_or_pp, unit, ...
            'VariableNames', {'Baseline','Metric','BaselineValue','V6Value','Delta','DeltaPctOrPp','Unit'});
        rows = append_table_local(rows, row);
    end
end

T = rows;
end

function T = build_stage_delta_local(case_stage_summary)
baselines = ["Confidence-heuristic", "Link-delay-aware"];
metrics = ["TimelyRate", "EmergencyTimelyRate", "LossRate", "AvgDelay", "AvgTxCost"];
metric_cols = ["TimelyRateMean", "EmergencyTimelyRateMean", "LossRateMean", "AvgDelayMean", "AvgTxCostMean"];
stages = unique(case_stage_summary.Stage, 'stable');
rows = [];

for s = 1:numel(stages)
    stage = stages(s);
    stageT = case_stage_summary(case_stage_summary.Stage == stage, :);
    v6 = get_method_row_local(stageT, "Risk-constrained-v6");
    for b = baselines
        base = get_method_row_local(stageT, b);
        for i = 1:numel(metrics)
            base_value = base.(metric_cols(i));
            v6_value = v6.(metric_cols(i));
            delta = v6_value - base_value;
            if metrics(i) == "TimelyRate" || metrics(i) == "EmergencyTimelyRate" || metrics(i) == "LossRate"
                delta_pct_or_pp = 100.0 * delta;
                unit = "pp";
            else
                delta_pct_or_pp = pct_delta_local(v6_value, base_value);
                unit = "pct";
            end
            row = table(stage, b, metrics(i), base_value, v6_value, delta, delta_pct_or_pp, unit, ...
                'VariableNames', {'Stage','Baseline','Metric','BaselineValue','V6Value','Delta','DeltaPctOrPp','Unit'});
            rows = append_table_local(rows, row);
        end
    end
end

T = rows;
end

function T = build_seed_delta_local(case_raw)
baselines = ["Confidence-heuristic", "Link-delay-aware"];
metrics = ["TimelyRate", "EmergencyTimelyRate", "LossRate", "AvgDelay_s", "AvgTxCost"];
seeds = unique(case_raw.Seed, 'stable');
rows = [];

for seed = seeds.'
    seedT = case_raw(case_raw.Seed == seed, :);
    v6 = get_method_row_local(seedT, "Risk-constrained-v6");
    for b = baselines
        base = get_method_row_local(seedT, b);
        for i = 1:numel(metrics)
            base_value = base.(metrics(i));
            v6_value = v6.(metrics(i));
            row = table(seed, b, metrics(i), base_value, v6_value, v6_value - base_value, ...
                'VariableNames', {'Seed','Baseline','Metric','BaselineValue','V6Value','Delta'});
            rows = append_table_local(rows, row);
        end
    end
end

T = rows;
end

function T = read_significance_rows_local(prefix, target_scene, target_config)
files = [ ...
    prefix + "_heuristic_vs_v6_significance.csv"; ...
    prefix + "_link_vs_v6_significance.csv"; ...
    prefix + "_v6_vs_oracle_significance.csv"];
labels = ["HeuristicVsV6"; "LinkVsV6"; "V6VsOracle"];
rows = [];

for i = 1:numel(files)
    if ~isfile(files(i))
        continue;
    end
    T_file = normalize_table_local(readtable(files(i), 'TextType', 'string'));
    T_case = T_file(T_file.Scene == target_scene & T_file.Config == target_config, :);
    T_case.Comparison = repmat(labels(i), height(T_case), 1);
    T_case = movevars(T_case, 'Comparison', 'Before', 'Scene');
    rows = append_table_local(rows, T_case);
end

T = rows;
end

function T = summarize_failure_local(overall_delta, stage_delta, case_decision)
timely_h = lookup_delta_local(overall_delta, "Confidence-heuristic", "TimelyRate");
emg_h = lookup_delta_local(overall_delta, "Confidence-heuristic", "EmergencyTimelyRate");
loss_h = lookup_delta_local(overall_delta, "Confidence-heuristic", "LossRate");
delay_h = lookup_delta_local(overall_delta, "Confidence-heuristic", "AvgDelay");
cost_h = lookup_delta_local(overall_delta, "Confidence-heuristic", "AvgTxCost");
timely_l = lookup_delta_local(overall_delta, "Link-delay-aware", "TimelyRate");
loss_l = lookup_delta_local(overall_delta, "Link-delay-aware", "LossRate");
delay_l = lookup_delta_local(overall_delta, "Link-delay-aware", "AvgDelay");
cost_l = lookup_delta_local(overall_delta, "Link-delay-aware", "AvgTxCost");

stage_t = stage_delta(stage_delta.Baseline == "Confidence-heuristic" & ...
    stage_delta.Metric == "TimelyRate" & ~isnan(stage_delta.DeltaPctOrPp), :);
if isempty(stage_t)
    worst_stage = "";
    worst_stage_delta = NaN;
else
    [worst_stage_delta, idx] = min(stage_t.DeltaPctOrPp);
    worst_stage = stage_t.Stage(idx);
end

failure_mode = "DeadlineReliabilityTradeoff";
if loss_h < 0 && timely_h < 0
    evidence = "V6 improves packet loss versus heuristic but loses timely/emergency delivery, indicating deadline mismatch rather than pure reliability failure.";
elseif delay_h > 0 && timely_h < 0
    evidence = "V6 increases delay while losing timely delivery, indicating deadline-side cost of risk-constrained decisions.";
else
    evidence = "V6 is negative against at least one strong baseline; classify as applicability boundary.";
end

T = table(case_decision.Scene, case_decision.Config, case_decision.Decision, ...
    timely_h, emg_h, loss_h, delay_h, cost_h, timely_l, loss_l, delay_l, cost_l, ...
    worst_stage, worst_stage_delta, failure_mode, evidence, ...
    'VariableNames', {'Scene','Config','Step49Decision', ...
    'TimelyDeltaVsHeuristic_pp','EmgDeltaVsHeuristic_pp', ...
    'LossDeltaVsHeuristic_pp','DelayDeltaVsHeuristic_pct','CostDeltaVsHeuristic_pct', ...
    'TimelyDeltaVsLink_pp','LossDeltaVsLink_pp','DelayDeltaVsLink_pct','CostDeltaVsLink_pct', ...
    'WorstStageVsHeuristic','WorstStageTimelyDelta_pp','FailureMode','Evidence'});
end

function value = lookup_delta_local(T, baseline, metric)
row = T(T.Baseline == baseline & T.Metric == metric, :);
if isempty(row)
    value = NaN;
else
    value = row.DeltaPctOrPp(1);
end
end

function write_report_local(out_path, source_prefix, target_scene, target_config, ...
    decision, overall_delta, stage_delta, significance_rows, failure)
fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step52 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step52 负例诊断报告：%s / %s\n\n', target_scene, target_config);
fprintf(fid, '证据来源：`%s_*`。本脚本只读取 Step49 PER lookup 结果，不调整主方法参数。\n\n', source_prefix);

fprintf(fid, '## 1. 结论\n\n');
fprintf(fid, '该场景应作为方法适用边界，而不是被隐藏或继续调参修正。Step49 分类为 `%s`。\n\n', string(decision.Decision(1)));
fprintf(fid, '诊断模式：`%s`。\n\n', failure.FailureMode(1));
fprintf(fid, '%s\n\n', failure.Evidence(1));

fprintf(fid, '## 2. Overall delta\n\n');
fprintf(fid, '| Baseline | Metric | Baseline | V6 | Delta | Delta unit |\n');
fprintf(fid, '|---|---|---:|---:|---:|---|\n');
for i = 1:height(overall_delta)
    fprintf(fid, '| %s | %s | %.6f | %.6f | %.3f | %s |\n', ...
        overall_delta.Baseline(i), overall_delta.Metric(i), ...
        overall_delta.BaselineValue(i), overall_delta.V6Value(i), ...
        overall_delta.DeltaPctOrPp(i), overall_delta.Unit(i));
end

fprintf(fid, '\n## 3. Stage-level timely delta vs heuristic\n\n');
stage_t = stage_delta(stage_delta.Baseline == "Confidence-heuristic" & ...
    stage_delta.Metric == "TimelyRate", :);
fprintf(fid, '| Stage | Heuristic | V6 | V6 - Heuristic (pp) |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
for i = 1:height(stage_t)
    fprintf(fid, '| %s | %.6f | %.6f | %.3f |\n', ...
        stage_t.Stage(i), stage_t.BaselineValue(i), stage_t.V6Value(i), stage_t.DeltaPctOrPp(i));
end

fprintf(fid, '\n## 4. Statistical rows\n\n');
if isempty(significance_rows)
    fprintf(fid, 'No significance rows found.\n\n');
else
    fprintf(fid, '| Comparison | Metric | Delta mean | Delta pct/pp | Holm-family p | Effect RBC | Practical note |\n');
    fprintf(fid, '|---|---|---:|---:|---|---:|---|\n');
    for i = 1:height(significance_rows)
        fprintf(fid, '| %s | %s | %.6f | %.3f | %s | %.3f | %s |\n', ...
            significance_rows.Comparison(i), significance_rows.Metric(i), ...
            significance_rows.Delta_Mean(i), significance_rows.DeltaPct(i), ...
            significance_rows.P_Value_Holm_Family_Display(i), ...
            significance_rows.EffectSize_RBC(i), significance_rows.PracticalNote(i));
    end
end

fprintf(fid, '\n## 5. 论文处理建议\n\n');
fprintf(fid, '1. 不要删除 10019 ForestGeometry；它是审稿人会要求看到的负例边界。\n');
fprintf(fid, '2. 不要把该场景并入平均值后只报告整体均值；需要在适用范围分析中单列。\n');
fprintf(fid, '3. 推荐表述为：短距密集遮挡条件下，风险约束调度可能提高投递可靠性但牺牲 deadline satisfaction，因此方法适用于“遮挡、定位退化、链路退化与应急窗口重叠且仍存在及时性提升空间”的场景。\n');
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if isempty(row)
    error('Missing method row for %s', method_name);
end
row = row(1, :);
end

function T = read_required_table_local(path)
if ~isfile(path)
    error('Missing required Step52 input: %s', path);
end
T = readtable(path, 'TextType', 'string');
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage','Decision','Metric','Baseline', ...
    'PracticalNote','P_Value_Holm_Family_Display'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = string(raw);
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
