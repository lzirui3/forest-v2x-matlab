function write_step62_vtc_revised_report_cn(main_performance, stronger_baseline, ...
    moderate_forest, applicability, negative_boundary, cost_efficiency, ...
    claim_boundary, fig_path, out_path)
%WRITE_STEP62_VTC_REVISED_REPORT_CN Write final VTC revised pack report.

fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step62 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step62 VTC 修订版最终结果包报告\n\n');
fprintf(fid, '本结果包整合 Step58-Step61，面向 VTC/车辆通信会议论文结果部分。核心原则是：保留负例、限定 claim、不把 inspired baseline 写成完整 SOTA、不把仿真写成实车实验。\n\n');

fprintf(fid, '## 1. 生成文件\n\n');
fprintf(fid, '| Artifact | Purpose |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| `step62_vtc_revised_main_performance_table.csv` | PER lookup 口径主性能表 |\n');
fprintf(fid, '| `step62_vtc_revised_stronger_baseline_table.csv` | DCC/AoI inspired strengthened baselines 对比 |\n');
fprintf(fid, '| `step62_vtc_revised_moderate_forest_table.csv` | ModerateForestGeometry 中等退化补充结果 |\n');
fprintf(fid, '| `step62_vtc_revised_applicability_table.csv` | Effective / Graceful / Failure 适用边界 |\n');
fprintf(fid, '| `step62_vtc_revised_negative_boundary_table.csv` | 负例和边界场景保留表 |\n');
fprintf(fid, '| `step62_vtc_revised_cost_efficiency_table.csv` | 代价-收益证据表 |\n');
fprintf(fid, '| `step62_vtc_revised_paper_claim_boundary_table.csv` | 论文 claim 限定表 |\n');
fprintf(fid, '| `%s` | 成本收益散点/Pareto 风格图 |\n\n', fig_path);

fprintf(fid, '## 2. 主性能证据规模\n\n');
fprintf(fid, '- Main performance rows: %d\n', height(main_performance));
fprintf(fid, '- Stronger baseline rows: %d\n', height(stronger_baseline));
fprintf(fid, '- Moderate forest rows: %d\n', height(moderate_forest));
fprintf(fid, '- Applicability rows: %d\n', height(applicability));
fprintf(fid, '- Negative/boundary rows: %d\n', height(negative_boundary));
fprintf(fid, '- Cost-efficiency rows: %d\n\n', height(cost_efficiency));

fprintf(fid, '## 3. 适用边界分类\n\n');
write_count_table_local(fid, applicability.ApplicabilityClass, 'ApplicabilityClass');

fprintf(fid, '\n## 4. 必须写入论文的 claim 边界\n\n');
fprintf(fid, '| Claim | Status | Evidence |\n');
fprintf(fid, '|---|---|---|\n');
for i = 1:height(claim_boundary)
    fprintf(fid, '| %s | %s | %s |\n', ...
        sanitize_md_local(claim_boundary.PaperClaim(i)), ...
        sanitize_md_local(claim_boundary.ClaimStatus(i)), ...
        sanitize_md_local(claim_boundary.Evidence(i)));
end

fprintf(fid, '\n## 5. 负例处理方式\n\n');
fprintf(fid, '| Scene | Config | Boundary class | Timely delta (pp) | Emergency delta (pp) | Handling |\n');
fprintf(fid, '|---|---|---|---:|---:|---|\n');
for i = 1:height(negative_boundary)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %s |\n', ...
        sanitize_md_local(negative_boundary.Scene(i)), ...
        sanitize_md_local(negative_boundary.Config(i)), ...
        sanitize_md_local(negative_boundary.BoundaryClass(i)), ...
        negative_boundary.TimelyDeltaVsHeuristic_pp(i), negative_boundary.EmergencyDeltaVsHeuristic_pp(i), ...
        sanitize_md_local(negative_boundary.PaperHandling(i)));
end

fprintf(fid, '\n## 6. VTC 写作口径\n\n');
fprintf(fid, '1. 主方法写作：`Risk-constrained-v6` 是 frozen-parameter finite-action online scheduler，基于风险约束效用/有限动作在线选择，不声称全局最优。\n');
fprintf(fid, '2. 基线写作：`DCC-like`、`DCC-CBR-window`、`AoI-aware`、`AoI-greedy` 均为 literature-inspired baselines，不是完整 ETSI DCC 协议栈或 AoI 最优策略。\n');
fprintf(fid, '3. 场景写作：`ForestGeometry` 是 extreme stress / boundary case；`ModerateForestGeometry` 是可部署中等退化补充场景。\n');
fprintf(fid, '4. 理论写作：Lyapunov 不作为主理论证明；主线应写成风险约束的有限动作在线调度。\n');
fprintf(fid, '5. Oracle 写作：`Constrained Oracle` 是同动作空间下的诊断参考，不是 global oracle。\n');
fprintf(fid, '6. 实验写作：本文是数据支撑仿真与 PER lookup 验证，不是实车或真实林区消防车实验。\n');
end

function write_count_table_local(fid, values, name)
[groups, labels] = findgroups(values);
counts = splitapply(@numel, values, groups);
fprintf(fid, '| %s | Count |\n', name);
fprintf(fid, '|---|---:|\n');
for i = 1:numel(labels)
    fprintf(fid, '| %s | %d |\n', labels(i), counts(i));
end
end

function value = sanitize_md_local(value)
value = string(value);
value = replace(value, newline, ' ');
value = replace(value, '|', '/');
value = char(value);
end
