# Proposed Method 形式化说明：Risk-constrained-v6

## 1. 是否需要全局最优

本项目不主张求解全局最优 V2X 调度策略。

原因是：

- 林区应急场景中的链路状态、定位可信度、盲区风险和消息紧急度随时间变化。
- 完整全局最优需要未来状态、完整信道演化和消息到达过程，当前仿真条件下无法严谨获得。
- 强行写成全局最优会引入更大的审稿风险。

本文应采用的表述是：

```text
The proposed method performs online per-slot finite-action optimization under a risk-constrained Lagrangian objective.
```

也就是：

```text
不是全局最优；
而是在每个决策时刻，对有限动作集合进行风险约束目标函数最小化。
```

## 2. 主方法名称

推荐论文主方法名称：

```text
Actual-cost-aware risk-constrained emergency-safe scheduling
```

MATLAB 主方法入口：

```matlab
run_step9_proposed_method(scenario, params)
```

内部调用：

```matlab
run_step9_confidence_driven_risk_constrained_v6(scenario, params)
```

旧方法保留为基线：

```matlab
run_step9_confidence_driven_heuristic(scenario, params)
```

## 3. 决策变量

每个时刻 `k`，调度器从有限动作集合中选择动作：

```text
a_k = {priority, tx_rate, mode}
```

其中：

- `priority`：消息优先级
- `tx_rate`：发送速率或重复发送强度
- `mode`：通信模式，包括 direct / redundant / relay

动作集合由 `enumerate_schedule_actions.m` 生成。

## 4. 状态输入

每个时刻的输入状态包括：

```text
s_k = {urgency, q_link, q_pos, blind_zone_gate, relay_available, base_rate, deadline, SINR, NLOS}
```

对应含义：

- `urgency`：消息紧急度
- `q_link`：链路可信度
- `q_pos`：定位可信度
- `blind_zone_gate`：盲区风险门控
- `relay_available`：中继/路侧辅助是否可用
- `base_rate`：基础消息发送速率
- `deadline`：消息及时性约束
- `SINR / NLOS`：物理链路状态

## 5. 目标函数

主方法在每个时刻选择：

```text
a_k* = argmin_a J(a | s_k)
```

其中目标函数为：

```text
J(a | s_k) =
    regularization(a)
  + lagrangian_penalty(a, s_k)
  - reward(a, s_k)
```

MATLAB 对应文件：

```matlab
compute_action_risk_constrained_objective_v4.m
```

### 5.1 Reward 项

Reward 表示高价值消息被及时可靠投递的收益：

```text
reward =
    VoI(s_k) · P_timely(a)
  + w_success · P_success(a)
  + w_event · event_gain(a, s_k)
```

其中 `VoI` 由消息紧急度、定位风险、链路风险和盲区风险共同决定。

### 5.2 Lagrangian penalty 项

约束违反项包括：

```text
timely_violation     = max(required_timely - P_timely(a), 0)
success_violation    = max(required_success - P_success(a), 0)
deadline_violation   = max(pred_delay / deadline - 1, 0)
protection_violation = max(required_protection - protection_level(a), 0)
position_violation   = position_risk · protection_violation
```

对应惩罚：

```text
lagrangian_penalty =
    lambda_t · timely_violation
  + lambda_s · success_violation
  + lambda_d · deadline_violation
  + lambda_p · protection_violation
  + lambda_pos · position_violation
```

这个结构比原始启发式规则更容易解释为约束优化问题。

### 5.3 Regularization 项

Regularization 表示通信资源代价和附加风险：

```text
regularization =
    beta_cost · actual_tx_cost
  + beta_delay · delay_penalty
  + beta_pos · position_risk_penalty
  + beta_mis · misdecision_risk
  + beta_relay · relay_penalty
  + support_mismatch_penalty
```

其中：

```text
actual_tx_cost = mode_cost · tx_rate
```

该项已经与 `evaluate_step9_metrics.m` 中的实际通信代价指标对齐。

## 6. Emergency action floor

`Risk-constrained-v6` 增加了应急动作下界：

```text
if emergency:
    priority >= risk_v6_emergency_min_priority
    rate_multiplier >= risk_v6_emergency_min_rate_multiplier
```

目的：

- 避免稀有 emergency 消息被平均代价目标欠保护。
- 保证应急预警消息在高风险阶段至少获得基本通信保护。

这不是任意规则，而是风险约束目标在极端安全消息下的工程安全边界。

## 7. 与旧方法的关系

旧的 `Confidence-heuristic` 不再作为主方法。

建议定位：

| 方法 | 论文角色 |
|---|---|
| `Risk-constrained-v6` | Proposed Method |
| `Confidence-heuristic` | Heuristic baseline |
| `V4Cost0060` | Ablation without final emergency floor effect |
| `Link-delay-aware` | Strong engineering baseline |
| `DCC-like` | Literature-inspired baseline |
| `AoI-aware` | Literature-inspired baseline |
| `Constrained Oracle` | Upper-bound reference |

## 8. 当前证据

修复 relay 随机数一致性后，已完成：

```text
5 scenes × 2 configs × 10 seeds
```

输出前缀：

```text
step39_risk_constrained_v6_vtc_randomfix_10seed
```

结果：

- 10 个 scene-config 全部为 `MainCandidate`
- `Heuristic vs V6` 中 26/50 个指标行通过 family-wise Holm 校正
- 修复后主结论没有被推翻

## 9. 后续投稿级动作

下一步不需要寻找新的全局最优算法。

需要做的是：

1. 使用 `run_step9_proposed_method.m` 作为统一主方法入口。
2. 将 `Confidence-heuristic` 降级为 baseline。
3. 用同一主方法入口跑 50-seed 正式验证。
4. 整理 `Risk-constrained-v6` vs `Link-delay-aware / DCC-like / AoI-aware / Confidence-heuristic / V4Cost0060 / Constrained Oracle` 的完整对比。
5. 在论文中避免使用 global optimum，使用 online finite-action risk-constrained optimization。

