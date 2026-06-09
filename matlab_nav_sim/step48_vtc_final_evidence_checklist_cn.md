# Step48 VTC 最终证据清单与下一步决策

本清单用于回答“当前项目还缺什么”。结论基于截至 Step47 的实际输出，不再按早期原型状态判断。

## 1. 已闭合证据

| 模块 | 状态 | 关键文件 | 结论 |
|---|---|---|---|
| 主方法定义 | Closed | `run_step9_proposed_method.m`, `proposed_method_formalization_vtc_cn.md` | 主方法已固定为 `Risk-constrained-v6`，旧 `Confidence-heuristic` 只作为 baseline/ablation。 |
| 主实验统计 | Closed | `step40_proposed_method_vtc_50seed_*` | 5 个主场景、2 个配置、50 seeds 已完成。 |
| 参数可信度 | Closed | `step45_parameter_credibility_closure_report.md` | 参数审计、核心参数敏感性、阈值标定和阈值扰动验证已闭合。 |
| Held-out 泛化 | Closed | `step45_heldout_frozen_validation_50seed_*` | 3 个 held-out 场景、2 个配置、50 seeds 已完成。 |
| 适用范围分析 | Closed | `step46_applicability_evidence_report_cn.md` | 已将弱泛化转化为适用条件分析，主张应定位为风险退化场景中的稳定正收益。 |
| 文献型基线 | Mostly closed | `run_step9_baseline_dcc_like.m`, `run_step9_baseline_aoi.m`, Step25/Step40 链 | 已具备 DCC-like、AoI-like 或相关 baseline 资源；最终论文中需要筛选呈现。 |
| PER lookup 最终实验脚本 | Smoke passed | `main_step49_per_lookup_final_validation_resume.m`, `step49_per_lookup_final_validation_smoke_1seed_*` | 已实现可断点续跑的 PER lookup 主实验链，1-seed 冒烟测试通过；正式 50-seed 尚未启动。 |

## 2. 新暴露的关键问题

### G1. 当前最终主方法的 PER lookup 交叉验证没有通过

Step47 输出：

```text
step47_current_method_per_lookup_validation_5seed_decision_table.csv
step47_current_method_per_lookup_validation_5seed_report.md
```

结果摘要：

| Decision | Count |
|---|---:|
| ApproximationStable | 4 |
| SmallBiasDiscuss | 1 |
| MaterialBias | 5 |

这意味着：

```text
sigmoid SINR-to-PDR 近似对当前最终方法的端到端结果有实质影响。
```

尤其是这些行属于 `MaterialBias`：

| Scene | Config | 主要问题 |
|---|---|---|
| 10014 | Default | Delay 和 Cost 偏差超过可忽略范围。 |
| 10006 | Default | Delay、Cost 和 EmergencyTimely 出现明显偏差。 |
| 10011 | ForestGeometry | Timely 和 EmergencyTimely 大幅变化。 |
| 10019 | ForestGeometry | Timely 和 EmergencyTimely 明显下降。 |
| 10017 | Default | Timely、Delay、Cost 均出现明显偏差。 |

因此不能再写：

```text
sigmoid approximation introduces negligible deviation.
```

更准确的说法是：

```text
The PER-table validation indicates that the fitted sigmoid PDR approximation can materially affect end-to-end scheduling results in several scene-config pairs. Therefore, final performance claims should either be based on PER lookup runs or explicitly report the sigmoid model as a limitation.
```

## 3. 当前项目最需要做的下一步

### P0. 决定最终物理层口径

现在有两个选择。

| 选择 | 做法 | 风险 |
|---|---|---|
| A. 推荐 | 将最终主结果切换到 `per_lookup` 物理层，并重跑正式主实验。 | 计算量较大，但审稿风险最低。 |
| B. 保守 | 保留 Step40 sigmoid 主结果，把 Step47 作为局限性讨论。 | VTC 仍可尝试，但物理层可信度会被审稿人重点攻击。 |

当前建议：

```text
选择 A。把 `per_lookup` 作为最终物理层口径。
```

原因：

1. Step47 已证明 sigmoid 偏差不是纯小误差。
2. WiLabV2Xsim PER 表比自拟 sigmoid 更容易被审稿人接受。
3. 这比继续调方法参数更重要。

### P1. 新增并运行 PER-lookup final validation

建议新增：

```text
main_step49_per_lookup_final_validation_resume.m
```

当前状态：

```text
已新增并通过 10014 Default × 1 seed 冒烟测试。
```

目标：

```text
5 main scenes × 2 configs × 50 seeds
PDR mode fixed to per_lookup
Methods: Link-delay-aware, Confidence-heuristic, Risk-constrained-v6, Constrained Oracle
```

输出前缀建议：

```text
step49_per_lookup_final_validation_50seed
```

正式运行命令建议：

```powershell
$env:STEP49_NUM_SEEDS='50'
$env:STEP49_PREFIX_TAG='step49_per_lookup_final_validation_50seed'
matlab -batch "cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim'); main_step49_per_lookup_final_validation_resume"
```

该脚本按 scene/config 写 checkpoint，中断后可直接重跑续接。

这一步完成后，Step40 的 sigmoid 结果不删除，但降级为：

```text
development / approximation baseline
```

Step49 才作为最终论文主结果。

### P2. Held-out 是否也重跑 PER lookup

如果 Step49 结果仍支持主结论，再补：

```text
main_step50_per_lookup_heldout_validation_resume.m
```

范围：

```text
3 held-out scenes × 2 configs × 50 seeds
PDR mode fixed to per_lookup
```

如果时间有限，Step50 可以降到 20 seeds，但需要明确是补充验证。

## 4. 不建议继续做的事

现在不建议：

1. 不建议继续调 `Risk-constrained-v6` 的权重。
2. 不建议为了让 Step47 变好而重新拟合 sigmoid。
3. 不建议把 Step47 结果解释成“已经验证 sigmoid 足够准确”。
4. 不建议在未重跑 PER lookup 主结果前开始正式论文结果章节。

## 5. 当前可写但不能夸大的项目定位

当前可以说：

```text
项目已形成完整的风险约束 V2X 调度仿真框架，完成了多场景、多种子、参数可信度、held-out 泛化和适用范围分析。
```

但暂时不能说：

```text
最终物理层模型已经完全闭合。
```

最准确的总判断：

```text
项目已经达到 VTC 级实验框架的主体要求，但 Step47 暴露出最终物理层口径需要升级。下一步应以 PER lookup 固定物理层重跑最终主结果，而不是继续改算法。
```
