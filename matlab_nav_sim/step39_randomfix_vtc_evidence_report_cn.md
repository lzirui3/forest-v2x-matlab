# Step39 Random-Fix VTC 证据链报告

## 1. 本轮修复目标

本轮针对审稿风险 F2：

> 物理仿真器与决策器模型不一致，尤其是 relay 模式是否使用一致的两跳链路模型，以及多方法比较时是否共享随机信道扰动。

该问题不能只在文字中解释，必须在 MATLAB 代码和统计结果中闭合。因此本轮工作做了三件事：

1. 检查 `predict_action_pdr_physical.m` 与 `simulate_step9_delivery_physical.m` 的 relay 模型。
2. 修复 relay 分支中未使用共享随机数的部分。
3. 用修复后的代码重新跑 `Step39` 的 5 scenes × 2 configs × 10 seeds 验证。

## 2. 代码层修复

### 2.1 已确认的模型一致性

`predict_action_pdr_physical.m` 中 relay 预测已经采用两跳独立链路：

```matlab
pdr_relay_chain = pdr_hop1 * pdr_hop2;
pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay_chain);
```

`simulate_step9_delivery_physical.m` 中 relay 仿真也采用 Source-Relay 与 Relay-Destination 两跳独立链路。

因此，“relay 是否为两跳模型”这一点已经一致。

### 2.2 已修复的随机数一致性

修复前，`simulate_step9_delivery_physical.m` 的 relay 分支仍有直接调用：

```matlab
rand()
randn()
```

这会导致同一个 `scenario.random_draws` 下，不同方法的 relay 随机扰动不完全共享。严格审稿时，这会削弱多方法公平比较的可信度。

本轮新增了 relay 专用共享随机量：

```matlab
random_draws.relay_los_uniform
random_draws.fast_fading_relay_hop1
random_draws.fast_fading_relay_hop2
```

并在 relay 分支中优先读取这些共享随机量。没有 `shared_draws` 时仍保留 `rand/randn` 作为 fallback，保证旧脚本兼容。

## 3. 验证过程

### 3.1 确定性复现实验

使用强制 relay 的人工 policy，对同一个 `scenario` 连续调用两次 `simulate_step9_delivery`。

验证结果：

```text
relay_shared_random_repeatable=1
```

含义：

同一场景、同一策略、同一预生成随机数下，物理投递输出完全一致，包括：

- `delivered`
- `deadline_hit`
- `delay`
- `tx_cost`

这说明 relay 分支随机数一致性问题已在代码层修复。

### 3.2 修复后 Step39 重新运行

为避免覆盖旧结果，本轮使用新前缀：

```text
step39_risk_constrained_v6_vtc_randomfix_10seed
```

实验规模：

```text
5 scenes × 2 configs × 10 seeds
```

方法集合：

- `Link-delay-aware`
- `Confidence-heuristic`
- `V4Cost0060`
- `Risk-constrained-v6`
- `Constrained Oracle`

输出文件：

- `step39_risk_constrained_v6_vtc_randomfix_10seed_decision_table.csv`
- `step39_risk_constrained_v6_vtc_randomfix_10seed_summary.csv`
- `step39_risk_constrained_v6_vtc_randomfix_10seed_heuristic_vs_v6_significance.csv`
- `step39_risk_constrained_v6_vtc_randomfix_10seed_link_vs_v6_significance.csv`
- `step39_risk_constrained_v6_vtc_randomfix_10seed_v4_vs_v6_significance.csv`
- `step39_risk_constrained_v6_vtc_randomfix_10seed_report.md`

三份显著性 CSV 均为：

```text
50 rows × 23 columns
empty cells: none
```

说明 `p-value`、Holm 校正、effect size 等字段已正常生成。

## 4. 修复后核心结果

### 4.1 决策表结论

修复后的 10 个 scene-config 行全部为：

```text
MainCandidate
```

核心范围：

```text
TimelyRate gain vs Confidence-heuristic: 0.0000 pp 到 3.8602 pp
EmergencyTimely gap vs Confidence-heuristic: 最小 0.0000 pp
Cost delta vs Confidence-heuristic: 最大 +12.5994%
```

这说明：修复 relay 随机数一致性后，主方法 `Risk-constrained-v6` 的总体结论没有被推翻。

### 4.2 关键场景结果

| Scene | Config | Timely Gain vs Heuristic | Emergency Gap | Cost Delta | Delay Delta | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | +1.631 pp | 0.000 pp | -1.77% | -31.37% | MainCandidate |
| 10014 | ForestGeometry | +1.498 pp | 0.000 pp | +9.66% | -9.37% | MainCandidate |
| 10006 | Default | +0.433 pp | 0.000 pp | +3.53% | -13.75% | MainCandidate |
| 10006 | ForestGeometry | +0.250 pp | 0.000 pp | +9.98% | -1.92% | MainCandidate |
| 10011 | Default | 0.000 pp | 0.000 pp | -3.94% | 0.00% | MainCandidate |
| 10011 | ForestGeometry | +3.860 pp | 0.000 pp | +9.11% | -11.44% | MainCandidate |
| 10019 | Default | 0.000 pp | 0.000 pp | +2.03% | 0.00% | MainCandidate |
| 10019 | ForestGeometry | +0.116 pp | +0.128 pp | -0.46% | +0.05% | MainCandidate |
| 10017 | Default | +1.065 pp | 0.000 pp | -2.86% | -16.16% | MainCandidate |
| 10017 | ForestGeometry | +0.649 pp | 0.000 pp | +12.60% | -1.73% | MainCandidate |

### 4.3 显著性结果

`Heuristic vs V6` 的 50 个指标行中：

```text
26 / 50 rows pass family-wise Holm correction
```

典型强结果：

- `10014 Default TimelyRate`: +1.631 pp, family-wise Holm `p < 1e-15`
- `10014 ForestGeometry TimelyRate`: +1.498 pp, family-wise Holm `p = 3.699e-13`
- `10011 ForestGeometry TimelyRate`: +3.860 pp, family-wise Holm `p < 1e-15`
- `10017 Default TimelyRate`: +1.065 pp, family-wise Holm `p = 2.961e-06`
- `10017 ForestGeometry TimelyRate`: +0.649 pp, family-wise Holm `p = 1.895e-10`

弱结果或退化保护结果：

- `10011 Default`: TimelyRate 无提升，但成本下降 3.94%，可解释为低风险场景下的 graceful degradation。
- `10019 Default`: TimelyRate 已达 1.0，无提升空间，只能讨论不恶化。
- `10019 ForestGeometry`: TimelyRate 仅 +0.116 pp，且不显著，应作为弱增益场景讨论，不能夸大。
- `10006 Default / ForestGeometry`: TimelyRate 提升未通过 family-wise Holm 校正，但 delay 和 cost 变化显著，需要以综合收益而非单一 TimelyRate 强行宣称。

## 5. 对 F2 的结论

从 MATLAB 项目层面看，F2 已经实质解决：

1. relay 预测模型与仿真模型均为两跳独立链路。
2. relay 仿真分支已使用共享随机数。
3. 通过强制 relay policy 的重复调用确定性测试。
4. 修复后重新跑了完整 5-scene、2-config、10-seed 验证。
5. 修复后主结论没有被推翻。

论文写法建议：

```text
To ensure a fair paired comparison, all candidate methods are evaluated on identical pre-generated random channel draws. The relay mode is modeled as a two-hop independent Source-Relay-Destination path in both the predictor and the physical delivery simulator. After this correction, the full five-scene validation was rerun and the main conclusions remained unchanged.
```

## 6. 仍需注意的限制

本轮解决的是 F2，不等于整个 VTC 级别证据链完全闭合。

仍需保留的风险：

1. 当前是 10-seed 验证，适合内部定版和预正式证据；投稿级别建议进一步跑 50 seeds。
2. `10019 ForestGeometry` 的主方法增益很弱，论文中必须作为适用边界或 graceful degradation 讨论。
3. `10006` 的 TimelyRate 提升在 family-wise Holm 校正后不显著，不能只挑显著场景讲。
4. 林区参数与真实数据映射仍需要继续强化，尤其是植被衰减、GNSS 退化和遮挡几何的参数来源。
5. 物理层仍是 WiLab/PER 曲线与自建调度仿真的耦合验证，不等价于完整 WiLabV2Xsim/ns-3 MAC 层端到端仿真。

## 7. 当前可写成论文贡献的部分

在修复后，方法主线可以更稳地表述为：

```text
An actual-cost-aware risk-constrained emergency-safe V2X scheduling method for forest road scenarios.
```

对应贡献：

1. 将预警消息调度建模为风险约束的有限动作优化问题，而不是纯规则堆叠。
2. 使用实际通信代价对风险约束目标进行校准，避免过度保护导致成本失控。
3. 引入 emergency action floor，防止稀有应急消息在平均目标下被欠保护。
4. 在五类林区/准林区场景和两类配置下验证，且修复 relay 随机数一致性后结论保持稳定。

当前最稳妥的论文表述不是“全局最优”，而是：

```text
calibrated finite-action risk-constrained scheduling with emergency-safe action floor
```

