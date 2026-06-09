function write_step54_literature_baselines_report_cn(decision, coverage, sig_dcc, sig_aoi, out_path, num_seeds)
%WRITE_STEP54_LITERATURE_BASELINES_REPORT_CN Write Step54 review report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step54 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step54 PER lookup 文献基线对比报告\n\n');
fprintf(fid, '本报告补齐最终物理层口径下的文献基线对比。PDR 口径固定为 `PER lookup`，并合并 Step49/Step50 已冻结结果。\n\n');
fprintf(fid, '新增运行的文献基线：`DCC-like` 与 `AoI-aware`。主方法 `Risk-constrained-v6` 参数未调整。\n\n');
fprintf(fid, '每个 scene/config 的随机种子数：%d。\n\n', num_seeds);

fprintf(fid, '## 1. 覆盖率检查\n\n');
fprintf(fid, '| Scene | Config | Method | Raw seeds | Stage seeds | Raw rows | Stage rows |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(coverage)
    fprintf(fid, '| %s | %s | %s | %d | %d | %d | %d |\n', ...
        coverage.Scene(i), coverage.Config(i), coverage.Method(i), ...
        coverage.RawSeeds(i), coverage.StageSeeds(i), coverage.RawRows(i), coverage.StageRows(i));
end

fprintf(fid, '\n## 2. Risk-constrained-v6 相对文献基线的逐场景增益\n\n');
fprintf(fid, '| Scene | Config | ΔTimely vs DCC (pp) | ΔEmg vs DCC (pp) | ΔCost vs DCC (%%) | ΔTimely vs AoI (pp) | ΔEmg vs AoI (pp) | ΔCost vs AoI (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.3f | %.3f | %.2f | %s |\n', ...
        decision.Scene(i), decision.Config(i), ...
        decision.TimelyGainVsDCC_pp(i), decision.EmgGainVsDCC_pp(i), decision.CostDeltaVsDCC_pct(i), ...
        decision.TimelyGainVsAoI_pp(i), decision.EmgGainVsAoI_pp(i), decision.CostDeltaVsAoI_pct(i), ...
        decision.LiteratureBaselineDecision(i));
end

fprintf(fid, '\n## 3. DCC-like vs Risk-constrained-v6 显著性摘要\n\n');
write_sig_subset(fid, sig_dcc);

fprintf(fid, '\n## 4. AoI-aware vs Risk-constrained-v6 显著性摘要\n\n');
write_sig_subset(fid, sig_aoi);

fprintf(fid, '\n## 5. 审稿口径\n\n');
fprintf(fid, '1. `DCC-like` 应解释为 ETSI DCC 风格的拥塞/链路负载响应基线，不是盲区感知方法。\n');
fprintf(fid, '2. `AoI-aware` 应解释为信息新鲜度驱动调度基线，不显式利用定位可信度和林区盲区风险。\n');
fprintf(fid, '3. 本 Step 的作用是补齐外部文献启发基线，不改变 Step49/Step50 的主方法参数和负例结论。\n');
end

function write_sig_subset(fid, T)
metrics = ["TimelyRate", "EmgTimely", "LossRate", "AvgTxCost"];
fprintf(fid, '| Scene | Config | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|---:|---|\n');
for i = 1:height(T)
    if ~any(T.Metric(i) == metrics)
        continue;
    end
    fprintf(fid, '| %s | %s | %s | %.6f | %.6f | %.6f | %s | %.3f | %s |\n', ...
        T.Scene(i), T.Config(i), T.Metric(i), ...
        T.Baseline_Mean(i), T.Proposed_Mean(i), T.Delta_Mean(i), ...
        T.P_Value_Holm_Display(i), T.EffectSize_RBC(i), T.PracticalNote(i));
end
end
