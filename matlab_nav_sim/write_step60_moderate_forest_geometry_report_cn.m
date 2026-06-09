function write_step60_moderate_forest_geometry_report_cn(decision, coverage, ...
    sig_dccw, sig_aoig, sig_h, out_path, num_seeds)
%WRITE_STEP60_MODERATE_FOREST_GEOMETRY_REPORT_CN Write Step60 report.

fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step60 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step60 ModerateForestGeometry 验证报告\n\n');
fprintf(fid, '本步骤新增 `ModerateForestGeometry`，作为可部署的中等林区退化补充场景。原 `ForestGeometry` 保留为 extreme stress / boundary case，不覆盖、不删除、不通过调参消除旧负例。\n\n');
fprintf(fid, '每个 scene 的随机种子数：%d。最终物理层口径仍为 PER lookup。\n\n', num_seeds);

fprintf(fid, '## 1. 覆盖率检查\n\n');
fprintf(fid, '| Scene | Config | Method | Raw seeds | Stage seeds | Raw rows | Stage rows |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(coverage)
    fprintf(fid, '| %s | %s | %s | %d | %d | %d | %d |\n', ...
        coverage.Scene(i), coverage.Config(i), coverage.Method(i), ...
        coverage.RawSeeds(i), coverage.StageSeeds(i), coverage.RawRows(i), coverage.StageRows(i));
end

fprintf(fid, '\n## 2. ModerateForestGeometry 逐场景结论\n\n');
fprintf(fid, '| Scene | V6 Timely (%%) | V6 Emergency (%%) | Constrained Oracle Emergency (%%) | Delta Timely vs Heuristic (pp) | Delta Emergency vs Heuristic (pp) | Delta Timely vs DCC-CBR (pp) | Delta Timely vs AoI-greedy (pp) | Decision |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(decision)
    fprintf(fid, '| %s | %.2f | %.2f | %.2f | %.3f | %.3f | %.3f | %.3f | %s |\n', ...
        decision.Scene(i), decision.V6Timely_pct(i), decision.V6EmergencyTimely_pct(i), ...
        decision.OracleEmergencyTimely_pct(i), decision.TimelyGainVsHeuristic_pp(i), ...
        decision.EmgGainVsHeuristic_pp(i), decision.TimelyGainVsDCCWindow_pp(i), ...
        decision.TimelyGainVsAoIGreedy_pp(i), decision.ModerateForestDecision(i));
end

fprintf(fid, '\n## 3. 显著性摘要\n\n');
fprintf(fid, '以下统计保留 Holm 多重比较校正和 effect size。DCC-CBR-window 与 AoI-greedy 均为文献风格 inspired baseline，不声称完整复现标准协议栈或 AoI 最优策略。\n\n');
fprintf(fid, '### DCC-CBR-window vs Risk-constrained-v6\n\n');
write_sig_subset_local(fid, sig_dccw);
fprintf(fid, '\n### AoI-greedy vs Risk-constrained-v6\n\n');
write_sig_subset_local(fid, sig_aoig);
fprintf(fid, '\n### Confidence-heuristic vs Risk-constrained-v6\n\n');
write_sig_subset_local(fid, sig_h);

fprintf(fid, '\n## 4. 审稿口径\n\n');
fprintf(fid, '1. `ModerateForestGeometry` 是补充可部署退化场景，不替代原 `ForestGeometry`。\n');
fprintf(fid, '2. 原 `ForestGeometry` 应写为 extreme stress test，用于暴露 deadline-reliability boundary。\n');
fprintf(fid, '3. 若某些 Moderate 场景仍然 emergency headroom 很低，应作为场景物理边界讨论，不能包装为主方法失效或成功。\n');
fprintf(fid, '4. 本步骤仅补充场景真实性与适用性证据，不改变 `Risk-constrained-v6` 冻结参数。\n');
end

function write_sig_subset_local(fid, T)
metrics = ["TimelyRate", "EmgTimely", "LossRate", "AvgTxCost"];
fprintf(fid, '| Scene | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |\n');
fprintf(fid, '|---|---|---:|---:|---:|---|---:|---|\n');
for i = 1:height(T)
    if ~any(T.Metric(i) == metrics)
        continue;
    end
    fprintf(fid, '| %s | %s | %.6f | %.6f | %.6f | %s | %.3f | %s |\n', ...
        T.Scene(i), T.Metric(i), T.Baseline_Mean(i), T.Proposed_Mean(i), ...
        T.Delta_Mean(i), T.P_Value_Holm_Display(i), T.EffectSize_RBC(i), T.PracticalNote(i));
end
end
