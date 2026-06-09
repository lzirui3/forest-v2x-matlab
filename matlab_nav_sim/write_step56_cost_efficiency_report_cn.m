function write_step56_cost_efficiency_report_cn(T_eff, T_pareto, T_interpretation, pareto_png, delta_png, out_path)
%WRITE_STEP56_COST_EFFICIENCY_REPORT_CN Write cost-efficiency report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step56 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step56 成本收益与 Pareto trade-off 报告\n\n');
fprintf(fid, '本报告用于回应审稿人关于“是否用更高通信成本换取微小收益”的问题。输入来自 Step54/Step55，不重新运行仿真。\n\n');
fprintf(fid, 'Pareto 图：`%s`，差分 trade-off 图：`%s`。\n\n', pareto_png, delta_png);

fprintf(fid, '## 1. 成本收益分类统计\n\n');
classes = unique(T_eff.CostEfficiencyClass, 'stable');
fprintf(fid, '| Class | Count |\n|---|---:|\n');
for i = 1:numel(classes)
    fprintf(fid, '| %s | %d |\n', classes(i), nnz(T_eff.CostEfficiencyClass == classes(i)));
end

fprintf(fid, '\n## 2. Risk-constrained-v6 相对各 baseline 的逐场景成本收益\n\n');
fprintf(fid, '| Scene | Config | Baseline | ΔTimely (pp) | ΔEmergency (pp) | ΔLoss (pp) | ΔCost (%%) | Gain/cost | Class |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_eff)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.3f | %.2f | %.3f | %s |\n', ...
        T_eff.Scene(i), T_eff.Config(i), T_eff.BaselineMethod(i), ...
        T_eff.DeltaTimely_pp(i), T_eff.DeltaEmergency_pp(i), T_eff.DeltaLoss_pp(i), ...
        T_eff.DeltaCost_pct(i), T_eff.TimelyGainPerCostPct(i), T_eff.CostEfficiencyClass(i));
end

fprintf(fid, '\n## 3. Pareto 前沿成员\n\n');
fprintf(fid, '| Scene | Config | Method | Cost | Timely | Emergency timely | Timely front | Emergency front |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|---|\n');
for i = 1:height(T_pareto)
    if ~(T_pareto.OnTimelyParetoFront(i) || T_pareto.OnEmergencyParetoFront(i) || T_pareto.Method(i) == "Risk-constrained-v6")
        continue;
    end
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.4f | %s | %s |\n', ...
        T_pareto.Scene(i), T_pareto.Config(i), T_pareto.Method(i), ...
        T_pareto.AvgTxCostMean(i), T_pareto.TimelyRateMean(i), ...
        T_pareto.EmergencyTimelyRateMean(i), string(T_pareto.OnTimelyParetoFront(i)), ...
        string(T_pareto.OnEmergencyParetoFront(i)));
end

fprintf(fid, '\n## 4. 与 Step55 实践显著性的一致性\n\n');
fprintf(fid, '| Practical class | Count |\n|---|---:|\n');
classes2 = unique(T_interpretation.PracticalClass, 'stable');
for i = 1:numel(classes2)
    fprintf(fid, '| %s | %d |\n', classes2(i), nnz(T_interpretation.PracticalClass == classes2(i)));
end

fprintf(fid, '\n## 5. 审稿口径\n\n');
fprintf(fid, '1. 若 `DeltaCost_pct > 0` 且 `DeltaTimely_pp < 1`，不能表述为强性能提升，只能作为弱收益或边界结果。\n');
fprintf(fid, '2. 若相对 DCC 出现负成本且正及时率收益，可作为 cost-saving evidence。\n');
fprintf(fid, '3. 对 `Link-delay-aware` 的比较经常是 costly gain，论文中必须同时报告成本，否则会被认为隐藏通信开销。\n');
fprintf(fid, '4. 对 `10019 ForestGeometry` 和 `10013 ForestGeometry` 不应调参修正，应与 Step52/Step51 一起作为适用边界讨论。\n');
end
