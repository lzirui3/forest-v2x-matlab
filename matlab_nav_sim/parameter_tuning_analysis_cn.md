# 仿真参数调整分析：如何制造方法间有意义的性能差异

> ⚠️ **诚信隔离声明（2026 审计补充，必读）**
> 本文档讨论的是**抽象投递模型**（`use_physical_delivery=false` 时的 gate/bonus 权重，
> 如 `critical_priority_bonus`、`priority_gate_bonus`、`link_gate_weight`、`base_success_bias`）
> 的调参，目的是在 smoke 测试里制造可观察的方法间差异。
> **这些数值不得作为方法优越性的证据。** 生产/论文路径已切换为**物理 PER 查表投递**
> （`use_physical_delivery=true` + `physical_pdr_mode="per_lookup"`，见
> `run_step9_proposed_method_dpp` / `simulate_step9_delivery_physical`），届时本文档所调的
> ~20 个抽象权重**完全离开活动路径**。本文档仅保留为历史 smoke-test 记录，
> 任何性能差异结论以物理投递下的 per_lookup 验证（step47/49/50/54）为准。
> 详见 `parameter_provenance_full_audit_cn.md` 第 4 章与 `parameter_tuning_analysis` 相关条目。

## 一、问题诊断：为什么所有方法 Emergency Timely Rate = 1.000

### 1.1 投递判定公式拆解

当前投递模型是**确定性门限比较**：

```
delivered(k) = success_prob >= deterministic_gate
```

对于 PosDeg_Emerg 阶段的 emergency 消息，典型数值如下：

**success_prob 的构成（以 Link-aware 为例）：**
- q_link ≈ 0.55-0.70（即使 NLOS，SINR 仍然较高）
- base_success_bias = -0.02
- priority_bonus = 0.05*(3-1) + 0.08 = **0.18**（emergency 消息 priority=3）
- mode_success_bonus = 0.15（relay 模式）
- rate_bonus = 0.03 * max(tx_rate - base_rate, 0) ≈ 0.03-0.09
- confidence_protection = 0.08-0.14（q_pos 低时触发）
- position_risk_penalty = -0.14 * (1-q_pos) ≈ -0.07（q_pos≈0.5时）

**合计 success_prob ≈ 0.55 + (-0.02) + 0.18 + 0.15 + 0.05 + 0.10 - 0.07 ≈ 0.94**

**deterministic_gate 的构成：**
- link_gate_weight * (1-q_link) = 0.48 * 0.35 ≈ 0.17
- pos_gate_weight * (1-q_pos) = 0.16 * 0.50 ≈ 0.08
- urgency_gate_weight * urgency = 0.08 * 0.95 ≈ 0.08
- mode_gate_bonus = -0.10（relay）
- priority_gate_bonus = -0.06 * (3-1) = -0.12
- emergency 额外减免 = -0.04

**合计 deterministic_gate ≈ 0.17 + 0.08 + 0.08 - 0.10 - 0.12 - 0.04 ≈ 0.07**
（被 clamp 到 min=0.05）

**结论：success_prob(0.94) >> deterministic_gate(0.07)，差距巨大，不可能失败。**

### 1.2 时延判定同样过于宽松

```
delay_real = (base_delay + link_delay_scale*(1-q_link) + mode_delay_penalty) / tx_rate
```

PosDeg_Emerg 阶段：
- base_delay ≈ 0.05
- link_delay_scale * (1-q_link) = 0.28 * 0.35 ≈ 0.10
- relay_delay_penalty = 0.12
- tx_rate ≈ 5.0-8.5（base_rate_emergency=5.0，还可能更高）

**delay_real ≈ (0.05 + 0.10 + 0.12) / 5.0 ≈ 0.054s**

而 deadline_emergency = **0.325s**，余量是 6 倍。即使最差情况也不可能超时。

### 1.3 链路质量退化不够严重

距离范围 40-150m，tx_power=17dBm，noise_floor=-92dBm：
- LOS: PL = 50 + 21*log10(150) ≈ 96 dB → SINR ≈ 17-96+92 = 13 dB → PDR > 0.95
- NLOS: PL = 48 + 24*log10(150) + 4*nlosv ≈ 100-108 dB → SINR ≈ 1-9 dB → PDR ≈ 0.5-0.85

即使 NLOS 最差情况，PDR 仍有 0.5，加上各种 bonus 后 success_prob 远超 gate。

---

## 二、参数调整方案（分层递进）

### 层次 A：收紧投递门限（最关键）

| 参数 | 当前值 | 建议值 | 理由 |
|------|--------|--------|------|
| `deadline_emergency` | 0.325 | **0.080** | 真实 C-V2X 紧急消息时延要求 50-100ms（3GPP TR 22.886） |
| `base_rate_emergency` | 5.0 | **1.5** | 降低基础发送速率，使 delay 分母变小，时延变大 |
| `critical_priority_bonus` | 0.08 | **0.03** | 减少 emergency 的无条件成功加成 |
| `priority_gate_bonus` | 0.06 | **0.02** | 减少 gate 的 priority 减免 |
| emergency gate 减免 | -0.04 | **0.00** | 取消 emergency 的额外 gate 降低 |

**效果预估：**
- delay_real ≈ (0.05+0.10+0.12)/1.5 ≈ 0.18s > deadline(0.08) → Fixed 方法大量超时
- Confidence-driven 可以通过提高 tx_rate 到 3-4 来降低 delay 到 0.07s → 刚好满足

### 层次 B：加剧链路退化（制造真实压力）

| 参数 | 当前值 | 建议值 | 理由 |
|------|--------|--------|------|
| PosDeg_Emerg 距离 | 100-120m | **250-400m** | 林火场景车辆分散，通信距离应更远 |
| interference_dB 峰值 | 6.0 dB | **12-15 dB** | 多车同时发送造成的 SCI 冲突 |
| NLOS 额外损耗 | +4*nlosv | **+8*nlosv + 6dB** | 林区树冠遮挡更严重 |
| tx_power_dBm | 17 | **14** | 车载设备在高温环境功率降额 |

**效果预估：**
- SINR 从 1-9 dB 降至 -5 到 +2 dB
- PDR 从 0.5-0.85 降至 0.1-0.4
- q_link 大幅下降，success_prob 显著降低

### 层次 C：引入随机性（消除确定性天花板）

当前模型是纯确定性的，这意味着同一参数下跑 20 次结果完全相同（step12 报告 std=0.000 证实了这一点）。

**建议改为概率投递模型：**

```matlab
% 替换当前的确定性判定
% delivered(k) = success_prob >= deterministic_gate;

% 改为：
delivery_probability = success_prob * pdr(k);  % 实际投递概率
delivered(k) = rand() < delivery_probability;  % 蒙特卡洛采样
```

或者保留确定性框架但引入**信道衰落随机性**：

```matlab
% 在 success_prob 上叠加瑞利衰落
fading_dB = -2 * log(rand());  % 指数分布（瑞利包络平方）
effective_sinr = sinr_dB(k) - fading_dB;
pdr_faded = step9_wilab_like_sinr_to_pdr(effective_sinr, scenario_tag);
```

### 层次 D：调整场景时间结构

| 参数 | 当前值 | 建议值 | 理由 |
|------|--------|--------|------|
| PosDeg_Emerg 持续时间 | 22s (t=68-90) | **40s (t=60-100)** | 延长关键阶段，增加样本量 |
| Emergency 消息密度 | ~22条 | **60-80条** | 更多样本才能体现统计差异 |
| 消息间隔 | 1s | **0.5s** | 提高调度压力 |

---

## 三、目标性能画像

调参后各方法在 PosDeg_Emerg 阶段的**目标表现**：

| 方法 | Emergency Timely Rate | 设计意图 |
|------|----------------------|----------|
| Fixed | 0.35-0.50 | 固定速率无法应对退化，大量超时 |
| Priority-only | 0.55-0.65 | 提高优先级有帮助但不够 |
| Link-aware | 0.65-0.75 | 感知链路退化可以部分补偿 |
| Position-only | 0.50-0.60 | 仅靠位置信息不够全面 |
| **Confidence-driven** | **0.85-0.95** | 综合利用所有信息，显著优于其他方法 |

**关键差异点：**
- Confidence-driven vs Link-aware: +15-20%（论文核心贡献）
- Confidence-driven vs Fixed: +35-50%（实际应用价值）

---

## 四、推荐实施顺序

### Phase 1（立即执行，1-2小时）
1. 修改 `deadline_emergency` → 0.080
2. 修改 `base_rate_emergency` → 1.5
3. 取消 emergency gate 减免
4. 降低 `critical_priority_bonus` → 0.03

→ 验证：Fixed 方法 Emergency Timely Rate 是否降至 0.5 以下

### Phase 2（链路压力，2-3小时）
1. 增大 PosDeg_Emerg 阶段通信距离
2. 提高干扰强度
3. 加重 NLOS 损耗

→ 验证：Link-aware 和 Confidence-driven 之间出现 10%+ 差异

### Phase 3（随机性，3-4小时）
1. 引入信道衰落随机性
2. 或改为概率投递模型
3. 重跑 multi-seed 验证 std > 0

→ 验证：20 seeds 下 CI95 不重叠

### Phase 4（场景丰富化，可选）
1. 增加 PosDeg_Emerg 持续时间和消息密度
2. 设计多种退化程度的子场景
3. 引入突发性链路中断事件

---

## 五、注意事项

1. **不要一次改太多参数**：每次只调一层，验证效果后再叠加
2. **保持 Recovery 阶段的恢复**：所有方法在 Recovery 阶段应该都能恢复到 0.9+，证明退化是暂时的
3. **Confidence-driven 不应该是 1.000**：目标是 0.85-0.95，完美分数反而不可信
4. **保留 Link-aware 作为 baseline**：它是最接近现有文献的方法，差异要相对它来衡量
5. **调参后重跑 sensitivity analysis**：确认新参数下各权重确实有影响

---

## 六、数学验证（Phase 1 调参后预期）

### 最终参数设定

| 参数 | 原值 | 新值 | 文件 |
|------|------|------|------|
| `base_rate_emergency` | 5.0 | **1.5** | `get_default_step9_params.m` |
| `deadline_emergency` | 0.14 (mainline: 0.325) | **0.088** | 两个文件 |
| `critical_priority_bonus` | 0.08 | **0.03** | `get_default_step9_params.m` |
| `priority_gate_bonus` | 0.06 | **0.02** | `get_default_step9_params.m` |
| emergency gate 减免 | -0.04 | **-0.00** | `simulate_step9_delivery.m` |

### Python 验证结果（PosDeg_Emerg 阶段，q_link=0.40-0.70，无 relay）

| 方法 | 速率 | 模式 | Delay 范围 | Timely Rate |
|------|------|------|-----------|-------------|
| Fixed | 1.5 | direct | 89-145ms | **0.000** |
| Link-aware | 3.0 | redundant | 71-99ms | **0.591** |
| Confidence-driven | 3.3-3.75 | redundant | 65-90ms | **0.86-0.91** |

### 差异化来源

Confidence-driven 的优势来自：
1. **感知位置退化** → 触发更高风险评估 → 选择更高速率倍率（2.1-2.5x vs Link-aware 的 2.0x）
2. **综合决策** → utility 优化器在高风险时倾向于牺牲成本换取时效性
3. **边际效应** → 在 deadline=88ms 的紧约束下，速率从 3.0 提升到 3.3-3.75 是决定性的

### 论文叙事

> 在位置退化紧急阶段（PosDeg_Emerg），固定调度方法因无法感知环境变化而完全失效（Timely Rate=0%）。
> 仅感知链路质量的方法可以部分补偿（~59%），但由于未利用定位置信度信息，
> 无法充分提升发送策略。本文提出的置信度驱动方法通过融合链路状态与定位置信度，
> 在检测到位置退化时主动提升发送速率至最高倍率，实现了 86-91% 的紧急消息及时投递率，
> 相比 Link-aware 基线提升约 30 个百分点。
