function write_step55_final_statistics_report_cn(T_core, T_sig, T_stage_sig, T_interpretation, coverage, out_path)
%WRITE_STEP55_FINAL_STATISTICS_REPORT_CN Write final statistical closure.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step55 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step55 最终统计显著性闭环报告\n\n');
fprintf(fid, '本报告读取 Step54 的最终 PER lookup 综合证据，不重新运行仿真，不调整主方法参数。\n\n');

fprintf(fid, '## 1. 输入覆盖率摘要\n\n');
fprintf(fid, '| Method | Cases | Min raw seeds | Min stage seeds |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
methods = unique(coverage.Method, 'stable');
for i = 1:numel(methods)
    subT = coverage(coverage.Method == methods(i), :);
    fprintf(fid, '| %s | %d | %d | %d |\n', methods(i), height(subT), ...
        min(subT.RawSeeds), min(subT.StageSeeds));
end

fprintf(fid, '\n## 2. 论文主结果表格式：mean ± 95%% CI\n\n');
fprintf(fid, '| Scene | Config | Method | Timely | Emergency timely | Loss | Delay | Tx cost |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(T_core)
    fprintf(fid, '| %s | %s | %s | %.4f ± %.4f | %.4f ± %.4f | %.4f ± %.4f | %.5f ± %.5f | %.4f ± %.4f |\n', ...
        T_core.Scene(i), T_core.Config(i), T_core.Method(i), ...
        T_core.TimelyRateMean(i), T_core.TimelyRateCI95(i), ...
        T_core.EmergencyTimelyRateMean(i), T_core.EmergencyTimelyRateCI95(i), ...
        T_core.LossRateMean(i), T_core.LossRateCI95(i), ...
        T_core.AvgDelayMean(i), T_core.AvgDelayCI95(i), ...
        T_core.AvgTxCostMean(i), T_core.AvgTxCostCI95(i));
end

fprintf(fid, '\n## 3. 场景级实践显著性摘要\n\n');
fprintf(fid, '| Scene | Config | Baseline | Proposed | ΔTimely (pp) | ΔEmergency (pp) | ΔCost (%%) | Holm p | Effect RBC | Class |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---|---:|---|\n');
for i = 1:height(T_interpretation)
    fprintf(fid, '| %s | %s | %s | %s | %.3f | %.3f | %.2f | %s | %.3f | %s |\n', ...
        T_interpretation.Scene(i), T_interpretation.Config(i), ...
        T_interpretation.BaselineMethod(i), T_interpretation.ProposedMethod(i), ...
        T_interpretation.TimelyDelta_pp(i), T_interpretation.EmgDelta_pp(i), ...
        T_interpretation.CostDelta_pct(i), T_interpretation.TimelyHolmP(i), ...
        T_interpretation.TimelyEffectRBC(i), T_interpretation.PracticalClass(i));
end

fprintf(fid, '\n## 4. PosDeg_Emerg 关键阶段统计\n\n');
fprintf(fid, '| Scene | Config | Baseline | Proposed | Metric | Delta | Holm p | Effect RBC | Practical note |\n');
fprintf(fid, '|---|---|---|---|---|---:|---|---:|---|\n');
keep_metrics = ["TimelyRate", "EmgTimely", "LossRate", "AvgTxCost"];
for i = 1:height(T_stage_sig)
    if ~any(T_stage_sig.Metric(i) == keep_metrics)
        continue;
    end
    fprintf(fid, '| %s | %s | %s | %s | %s | %.6f | %s | %.3f | %s |\n', ...
        T_stage_sig.Scene(i), T_stage_sig.Config(i), ...
        T_stage_sig.BaselineMethod(i), T_stage_sig.ProposedMethod(i), ...
        T_stage_sig.Metric(i), T_stage_sig.Delta_Mean(i), ...
        T_stage_sig.P_Value_Holm_Display(i), T_stage_sig.EffectSize_RBC(i), ...
        T_stage_sig.PracticalNote(i));
end

fprintf(fid, '\n## 5. 审稿口径\n\n');
fprintf(fid, '1. 统计表必须与 Step54 文献基线表共同使用，避免只报告均值。\n');
fprintf(fid, '2. `Below1pp` 或 `Boundary` 结果不能包装成强性能提升，应作为弱收益或适用边界。\n');
fprintf(fid, '3. Holm 校正和 effect size 已给出，可用于回应多重比较和实际显著性问题。\n');
end
