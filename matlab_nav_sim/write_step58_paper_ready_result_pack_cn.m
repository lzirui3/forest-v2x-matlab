function write_step58_paper_ready_result_pack_cn(T_main, T_sota, T_stat, T_cost, ...
    T_app, T_negative, T_param, T54_coverage, T56_pareto, T57_resources, ...
    T57_values, T52_overall, audit, pareto_png, delta_png, out_path)
%WRITE_STEP58_PAPER_READY_RESULT_PACK_CN Write the final Chinese result pack.

fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step58 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step58 VTC 可投稿结果包总报告\n\n');
fprintf(fid, '本报告汇总 Step54 至 Step57 的最终证据链。报告只整理既有 PER lookup 结果，不重新仿真，不调 Risk-constrained-v6 参数，也不覆盖 Step40/45/46/49/50/51/52/53 的历史结果。\n\n');

fprintf(fid, '## 1. 最终证据口径\n\n');
fprintf(fid, '| 项目 | 结论 |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| 最终物理层 | PER-table lookup，不使用 sigmoid 作为最终主证据 |\n');
fprintf(fid, '| 实验覆盖 | 8 scenes x 2 configs x 50 seeds x 6 methods |\n');
fprintf(fid, '| 主方法 | Risk-constrained-v6，参数冻结，不为负例继续调参 |\n');
fprintf(fid, '| 文献风格基线 | ETSI DCC-like、AoI-aware |\n');
fprintf(fid, '| 诊断上界 | Constrained Oracle，仅作为受约束诊断上界，不是全局最优 oracle |\n');
fprintf(fid, '| 真实性边界 | forestry-data-informed PER-lookup simulation，不是实车通信实测 |\n\n');

fprintf(fid, '## 2. 输出文件\n\n');
fprintf(fid, '| 文件 | 用途 |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| `step58_paper_ready_main_performance_table.csv` | 主性能表 |\n');
fprintf(fid, '| `step58_paper_ready_sota_baseline_table.csv` | DCC-like / AoI-aware 文献风格基线对比 |\n');
fprintf(fid, '| `step58_paper_ready_statistical_table.csv` | Holm 校正、effect size 与实践显著性 |\n');
fprintf(fid, '| `step58_paper_ready_cost_efficiency_table.csv` | 成本收益分析 |\n');
fprintf(fid, '| `step58_paper_ready_applicability_table.csv` | 适用范围表 |\n');
fprintf(fid, '| `step58_paper_ready_negative_boundary_table.csv` | 负例与边界场景表 |\n');
fprintf(fid, '| `step58_paper_ready_parameter_credibility_table.csv` | 参数可信度表 |\n');
fprintf(fid, '| `%s` | Pareto trade-off 图 |\n', pareto_png);
fprintf(fid, '| `%s` | 成本-收益差分图 |\n\n', delta_png);

fprintf(fid, '## 3. 覆盖率审查\n\n');
fprintf(fid, '| Audit item | Observed | Expected | Pass |\n');
fprintf(fid, '|---|---:|---:|---|\n');
for i = 1:height(audit)
    fprintf(fid, '| %s | %.0f | %.0f | %s |\n', audit.Item(i), ...
        audit.Observed(i), audit.Expected(i), audit.Pass(i));
end

fprintf(fid, '\n### Step54 覆盖矩阵摘要\n\n');
methods = unique(T54_coverage.Method, 'stable');
fprintf(fid, '| Method | Cases | Min raw seeds | Min stage seeds |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
for i = 1:numel(methods)
    subT = T54_coverage(T54_coverage.Method == methods(i), :);
    fprintf(fid, '| %s | %d | %.0f | %.0f |\n', methods(i), height(subT), ...
        min(subT.RawSeeds), min(subT.StageSeeds));
end

fprintf(fid, '\n## 4. 主性能与文献基线结论\n\n');
fprintf(fid, 'Risk-constrained-v6 在若干林区风险场景中相对 DCC-like、AoI-aware、Link-delay-aware 或 Confidence-heuristic 存在有意义收益，但结果不是全场景支配。论文中应表述为“风险约束场景下的选择性优势”，而不是“所有场景全面最优”。\n\n');
fprintf(fid, '| Scene | Config | ΔTimely vs DCC (pp) | ΔTimely vs AoI (pp) | ΔTimely vs heuristic (pp) | ΔTimely vs link (pp) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(T_sota)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.3f | %.3f | %s |\n', ...
        T_sota.Scene(i), T_sota.Config(i), T_sota.TimelyGainVsDCC_pp(i), ...
        T_sota.TimelyGainVsAoI_pp(i), T_sota.TimelyGainVsHeuristic_pp(i), ...
        T_sota.TimelyGainVsLink_pp(i), T_sota.LiteratureBaselineDecision(i));
end

fprintf(fid, '\n## 5. 统计显著性与实践显著性\n\n');
classes = unique(T_stat.PracticalClass, 'stable');
fprintf(fid, '| Practical class | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(classes)
    fprintf(fid, '| %s | %d |\n', classes(i), nnz(T_stat.PracticalClass == classes(i)));
end
fprintf(fid, '\n统计表已使用 Holm-Bonferroni 口径。对小于 1%% 的收益，论文中必须补充工程意义说明，不能只依赖 p-value。\n\n');

fprintf(fid, '## 6. 成本收益与 Pareto 结论\n\n');
cost_classes = unique(T_cost.CostEfficiencyClass, 'stable');
fprintf(fid, '| Cost-efficiency class | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(cost_classes)
    fprintf(fid, '| %s | %d |\n', cost_classes(i), nnz(T_cost.CostEfficiencyClass == cost_classes(i)));
end
v6_front = T56_pareto(T56_pareto.Method == "Risk-constrained-v6" & ...
    T56_pareto.OnTimelyParetoFront == 1, :);
fprintf(fid, '\nRisk-constrained-v6 位于 Timely Pareto front 的场景配置数为 %d / 16。该结果可以作为成本-收益合理性的证据，但不能解释为全局最优。\n\n', height(v6_front));

fprintf(fid, '## 7. 适用范围与边界负例\n\n');
app_classes = unique(T_app.ApplicabilityClass, 'stable');
fprintf(fid, '| Applicability class | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(app_classes)
    fprintf(fid, '| %s | %d |\n', app_classes(i), nnz(T_app.ApplicabilityClass == app_classes(i)));
end

fprintf(fid, '\n### 必须显式讨论的边界/负例\n\n');
fprintf(fid, '| Scene | Config | Baseline | ΔTimely (pp) | ΔEmergency (pp) | ΔCost (%%) | Evidence |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|\n');
for i = 1:height(T_negative)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.2f | %s |\n', ...
        T_negative.Scene(i), T_negative.Config(i), T_negative.BaselineMethod(i), ...
        T_negative.DeltaTimely_pp(i), T_negative.DeltaEmergency_pp(i), ...
        T_negative.DeltaCost_pct(i), T_negative.BoundaryEvidence(i));
end

fprintf(fid, '\nStep52 对 10019 ForestGeometry 的诊断表明，该场景主要体现 deadline-reliability trade-off，不应通过继续调参消除。10013 ForestGeometry 同样应作为边界表现纳入适用性讨论。\n\n');

fprintf(fid, '## 8. 参数可信度边界\n\n');
fprintf(fid, 'Step57 将参数划分为数据支撑、PER 表支撑、文献/模型启发、工程冻结权重和诊断上界几类。论文中必须避免把工程冻结参数写成实测标定结果。\n\n');
fprintf(fid, '| Resource | Exists | Size bytes |\n');
fprintf(fid, '|---|---:|---:|\n');
for i = 1:height(T57_resources)
    fprintf(fid, '| %s | %s | %.0f |\n', T57_resources.Name(i), ...
        string(T57_resources.Exists(i)), T57_resources.FileSizeBytes(i));
end

fprintf(fid, '\n### 关键参数口径\n\n');
key_params = ["final_physical_pdr_mode","objective_timely_lambda", ...
    "objective_success_lambda","risk_v4_actual_cost_weight", ...
    "risk_v6_emergency_floor"];
fprintf(fid, '| Parameter | Default | ForestGeometry | Source note |\n');
fprintf(fid, '|---|---|---|---|\n');
for i = 1:numel(key_params)
    row = T57_values(T57_values.Parameter == key_params(i), :);
    if isempty(row)
        continue;
    end
    fprintf(fid, '| %s | %s | %s | %s |\n', safe_text_local(row.Parameter(1)), ...
        safe_text_local(row.DefaultValue(1)), ...
        safe_text_local(row.ForestGeometryValue(1)), safe_text_local(row.SourceNote(1)));
end

fprintf(fid, '\n## 9. Constrained Oracle 使用边界\n\n');
fprintf(fid, 'Constrained Oracle 只能作为有限动作集合、给定仿真模型和既定约束下的诊断上界。不能写成全局最优 oracle，也不能用它证明主方法达到理论最优。\n\n');

fprintf(fid, '## 10. 论文写作建议\n\n');
fprintf(fid, '可以主张：\n\n');
fprintf(fid, '1. 在 PER-table lookup 物理层和 8 个数据支撑场景下，Risk-constrained-v6 提供了风险约束应急消息调度的系统性证据链。\n');
fprintf(fid, '2. 与 DCC-like 和 AoI-aware 文献风格基线相比，方法在多个林区风险场景中具有可统计验证的收益。\n');
fprintf(fid, '3. 成本收益分析表明，部分收益来自额外通信成本，部分场景具有 cost-saving 或 Pareto-front 证据。\n');
fprintf(fid, '4. 10019 ForestGeometry 与 10013 ForestGeometry 是适用性边界，不是需要隐藏的异常点。\n\n');
fprintf(fid, '不能主张：\n\n');
fprintf(fid, '1. 方法全场景支配所有基线。\n');
fprintf(fid, '2. 当前结果来自真实林区实车通信测量。\n');
fprintf(fid, '3. Risk-constrained-v6 权重是全局最优估计。\n');
fprintf(fid, '4. Constrained Oracle 是无约束全局最优。\n\n');

fprintf(fid, '## 11. Step58 结论\n\n');
fprintf(fid, '当前结果包已经补齐 VTC 审稿最容易追问的四类证据：文献风格基线、统计严谨性、成本收益解释和参数可信度边界。项目可以进入论文写作与图表整理阶段，但写作时必须保持边界表述，尤其是对负例、工程冻结权重和非实测性质的限定。\n');
end

function out = safe_text_local(value)
out = string(value);
if ismissing(out)
    out = "";
end
out = char(out);
end
