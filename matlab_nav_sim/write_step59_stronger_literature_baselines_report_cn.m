function write_step59_stronger_literature_baselines_report_cn(decision, coverage, ...
    sig_dcc_window, sig_aoi_greedy, out_path, num_seeds)
%WRITE_STEP59_STRONGER_LITERATURE_BASELINES_REPORT_CN Write Step59 report.

fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step59 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step59 强化文献启发基线对比报告\n\n');
fprintf(fid, '本步骤在最终 PER lookup 口径下新增 `DCC-CBR-window` 与 `AoI-greedy` 两个更强的文献启发基线，并合并 Step54 的冻结证据。该步骤不修改 Risk-constrained-v6 参数，不覆盖 Step54-58。\n\n');
fprintf(fid, '注意：这些方法仍然是 DCC/AoI-inspired baselines，不是完整 ETSI DCC 协议栈，也不是 AoI 最优策略。\n\n');
fprintf(fid, '每个 scene/config 的随机种子数：%d。\n\n', num_seeds);

fprintf(fid, '## 1. 覆盖率检查\n\n');
fprintf(fid, '| Scene | Config | Method | Raw seeds | Stage seeds | Raw rows | Stage rows |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(coverage)
    fprintf(fid, '| %s | %s | %s | %d | %d | %d | %d |\n', ...
        coverage.Scene(i), coverage.Config(i), coverage.Method(i), ...
        coverage.RawSeeds(i), coverage.StageSeeds(i), coverage.RawRows(i), coverage.StageRows(i));
end

fprintf(fid, '\n## 2. Risk-constrained-v6 相对强化基线的逐场景增益\n\n');
fprintf(fid, '| Scene | Config | ΔTimely vs DCC-CBR (pp) | ΔEmg vs DCC-CBR (pp) | ΔCost vs DCC-CBR (%%) | ΔTimely vs AoI-greedy (pp) | ΔEmg vs AoI-greedy (pp) | ΔCost vs AoI-greedy (%%) | Decision |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(decision)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.3f | %.3f | %.2f | %s |\n', ...
        decision.Scene(i), decision.Config(i), ...
        decision.TimelyGainVsDCCWindow_pp(i), decision.EmgGainVsDCCWindow_pp(i), ...
        decision.CostDeltaVsDCCWindow_pct(i), ...
        decision.TimelyGainVsAoIGreedy_pp(i), decision.EmgGainVsAoIGreedy_pp(i), ...
        decision.CostDeltaVsAoIGreedy_pct(i), decision.StrongerBaselineDecision(i));
end

fprintf(fid, '\n## 3. DCC-CBR-window vs Risk-constrained-v6 显著性摘要\n\n');
write_sig_subset_local(fid, sig_dcc_window);

fprintf(fid, '\n## 4. AoI-greedy vs Risk-constrained-v6 显著性摘要\n\n');
write_sig_subset_local(fid, sig_aoi_greedy);

fprintf(fid, '\n## 5. 审稿口径\n\n');
fprintf(fid, '1. `DCC-CBR-window` 使用滑动窗口信道占用代理，比 `DCC-like` 更接近拥塞控制逻辑，但仍不是完整 ETSI DCC 标准栈。\n');
fprintf(fid, '2. `AoI-greedy` 使用预期 AoI 降低、链路成功率与发送成本的贪心目标，不使用定位可信度或林区风险项。\n');
fprintf(fid, '3. 若 Risk-constrained-v6 在某些场景低于强化基线，应作为适用边界或 cost-risk trade-off 讨论，不应隐藏。\n');
end

function write_sig_subset_local(fid, T)
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
