clc;
clear;
close all;

% Step53: final VTC review-ready Chinese evidence report.
% This script reads Step49/50/51/52 outputs only. It does not rerun
% simulations and does not change method parameters.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

step49_prefix = get_env_string_local('STEP53_MAIN_PREFIX', ...
    "step49_per_lookup_final_validation_50seed");
step50_prefix = get_env_string_local('STEP53_HELDOUT_PREFIX', ...
    "step50_per_lookup_heldout_validation_50seed");
step52_prefix = get_env_string_local('STEP53_FAILURE_PREFIX', ...
    "step52_10019_forestgeometry");
step51_table = get_env_string_local('STEP53_APP_TABLE', ...
    "step51_per_lookup_applicability_evidence_table.csv");
report_path = get_env_string_local('STEP53_OUT_REPORT', ...
    "step53_vtc_final_review_ready_report_cn.md");

T49_decision = normalize_table_local(read_required_table_local(step49_prefix + "_decision_table.csv"));
T50_decision = normalize_table_local(read_required_table_local(step50_prefix + "_decision_table.csv"));
T51 = normalize_table_local(read_required_table_local(step51_table));
T52_failure = normalize_table_local(read_required_table_local(step52_prefix + "_failure_summary.csv"));
T52_overall = normalize_table_local(read_required_table_local(step52_prefix + "_overall_delta.csv"));

write_report_local(report_path, step49_prefix, step50_prefix, step52_prefix, ...
    T49_decision, T50_decision, T51, T52_failure, T52_overall);

fprintf('Step53 complete: final VTC review-ready report generated: %s\n', report_path);

function write_report_local(out_path, step49_prefix, step50_prefix, step52_prefix, ...
    T49_decision, T50_decision, T51, T52_failure, T52_overall)
fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step53 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step53 VTC 投稿前最终证据闭环报告\n\n');
fprintf(fid, '本报告用于 VTC 级别投稿前的最终内部审查。证据口径统一为 `PER lookup`，不再使用早期 sigmoid 结果作为最终物理层结论。\n\n');

fprintf(fid, '## 1. 输入证据\n\n');
fprintf(fid, '| Evidence | Prefix / file | Role |\n');
fprintf(fid, '|---|---|---|\n');
fprintf(fid, '| Step49 | `%s_*` | 主场景 5 scenes x 2 configs x 50 seeds，PER lookup |\n', step49_prefix);
fprintf(fid, '| Step50 | `%s_*` | Held-out 3 scenes x 2 configs x 50 seeds，PER lookup |\n', step50_prefix);
fprintf(fid, '| Step51 | `step51_per_lookup_applicability_evidence_*` | 最终适用范围分析 |\n');
fprintf(fid, '| Step52 | `%s_*` | 10019 ForestGeometry 负例诊断 |\n\n', step52_prefix);

fprintf(fid, '## 2. 主场景 Step49 结果\n\n');
write_decision_table_local(fid, T49_decision);

fprintf(fid, '\n## 3. Held-out Step50 结果\n\n');
write_decision_table_local(fid, T50_decision);

fprintf(fid, '\n## 4. 最终适用范围分类\n\n');
classes = unique(T51.ApplicabilityClass, 'stable');
fprintf(fid, '| Applicability class | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(classes)
    fprintf(fid, '| %s | %d |\n', classes(i), sum(T51.ApplicabilityClass == classes(i)));
end

fprintf(fid, '\n### 逐场景结论\n\n');
fprintf(fid, '| Dataset | Scene | Config | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Applicability | Note |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|---|\n');
for i = 1:height(T51)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.3f | %s | %s |\n', ...
        T51.Dataset(i), T51.Scene(i), T51.Config(i), ...
        T51.TimelyGainVsHeuristic_pp(i), T51.EmgGainVsHeuristic_pp(i), ...
        T51.TimelyGainVsLink_pp(i), T51.ApplicabilityClass(i), ...
        T51.ApplicabilityNote(i));
end

fprintf(fid, '\n## 5. 10019 ForestGeometry 负例处理\n\n');
fprintf(fid, 'Step52 将 `10019 / ForestGeometry` 归类为 `%s`，失败模式为 `%s`。\n\n', ...
    T52_failure.Step49Decision(1), T52_failure.FailureMode(1));
fprintf(fid, '核心证据：%s\n\n', T52_failure.Evidence(1));

fprintf(fid, '| Baseline | Metric | Baseline | V6 | Delta | Unit |\n');
fprintf(fid, '|---|---|---:|---:|---:|---|\n');
for i = 1:height(T52_overall)
    fprintf(fid, '| %s | %s | %.6f | %.6f | %.3f | %s |\n', ...
        T52_overall.Baseline(i), T52_overall.Metric(i), ...
        T52_overall.BaselineValue(i), T52_overall.V6Value(i), ...
        T52_overall.DeltaPctOrPp(i), T52_overall.Unit(i));
end

fprintf(fid, '\n## 6. 最终论文主张边界\n\n');
fprintf(fid, '可以主张：\n\n');
fprintf(fid, '1. 本文方法是面向林区应急 V2X 的在线有限动作风险约束调度方法，而不是全局最优或全场景支配方法。\n');
fprintf(fid, '2. 在 PER lookup 物理层下，方法在多个林区风险退化场景中获得明确收益，并在 held-out 场景中提供外部泛化证据。\n');
fprintf(fid, '3. 对于低风险、已饱和或短距密集遮挡导致 deadline-reliability tradeoff 失配的场景，方法应作为适用边界处理。\n\n');

fprintf(fid, '不能主张：\n\n');
fprintf(fid, '1. 不能声称方法在所有场景均显著优于全部基线。\n');
fprintf(fid, '2. 不能把 10019 ForestGeometry 隐藏在平均值中，或通过继续调参消除该负例。\n');
fprintf(fid, '3. 不能把 sigmoid 近似结果作为最终物理层证据的主口径。\n\n');

fprintf(fid, '## 7. VTC 投稿前状态判断\n\n');
fprintf(fid, '当前证据链已达到 VTC 会议仿真论文的基本闭环：主场景、多 seed、held-out、PER lookup、适用范围分析与负例诊断均有独立文件支撑。\n');
fprintf(fid, '剩余风险主要在论文写法：必须诚实限定适用范围，并将 10019 ForestGeometry 作为 boundary case，而不是包装成全局优势。\n');
end

function write_decision_table_local(fid, T)
fprintf(fid, '| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Cost delta (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f | %.2f | %s |\n', ...
        T.Scene(i), T.Config(i), T.TimelyGainVsHeuristic_pp(i), ...
        T.EmgGainVsHeuristic_pp(i), T.TimelyGainVsLink_pp(i), ...
        T.CostDeltaVsHeuristic_pct(i), T.Decision(i));
end
end

function T = read_required_table_local(path)
if ~isfile(path)
    error('Missing required Step53 input: %s', path);
end
T = readtable(path, 'TextType', 'string');
end

function T = normalize_table_local(T)
names = {'Dataset','Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Decision','RiskClass','GainClass','ApplicabilityClass','ApplicabilityNote', ...
    'Step49Decision','FailureMode','Evidence','Baseline','Metric','Unit'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
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
