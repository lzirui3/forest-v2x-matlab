# 物理驱动投递模型设计文档（最终版）

## 1. 问题诊断

当前 `simulate_step9_delivery.m` 的投递判定：

```matlab
success_prob = q_link + bonuses + confidence_protection - risk_penalty
deterministic_gate = weighted_sum(1-q_link, 1-q_pos, urgency) - bonuses
delivered(k) = success_prob >= deterministic_gate
```

**致命问题**：
- `success_prob` 和 `gate` 都是不同量纲量的线性组合，没有物理对应
- `scenario.pdr`（从 SINR→PER 曲线计算）存在但未被投递模型使用
- 审稿人可以直接质疑：为什么不用标准的 PDR 做投递概率？

## 2. 解决方案：两层分离架构

### Layer 1: 物理层（已有，不修改）

```
距离 → 路径损耗(LOS/NLOS) → SINR(含阴影衰落+干扰) → PDR(WiLabV2Xsim PER曲线)
```

由 `step9_generate_link_state_wilab_like.m` 完成，输出 `scenario.sinr_dB`。

### Layer 2: MAC/调度层（重构目标）

调度决策通过以下**物理机制**修改有效投递概率：

```
投递流程:
  1. 优先级 → SINR增益 (资源优势减少干扰)
  2. 快衰落 → 每包瞬时SINR (Rayleigh/Rician)
  3. SINR → PDR (sigmoid近似PER曲线)
  4. 模式分集 → 提升单次尝试成功率
  5. 多次传输尝试 → 时间分集 (rate_multiplier→n_attempts)
  6. 投递判定 → Bernoulli(pdr_effective)
```

## 3. 物理机制详述

### 3.1 优先级 SINR 增益

3GPP C-V2X 中，高优先级消息通过 SPS 资源预留获得更好的资源分配，
等效为降低碰撞干扰：

```matlab
sinr_gain = params.priority_sinr_gain * (priority - 1);  % 0.5 dB/level
if is_emergency
    sinr_gain = sinr_gain + params.emergency_sinr_bonus;  % +1.0 dB
end
```

参数依据：SPS资源预留将碰撞概率从 ~10% 降至 ~3%（3GPP TR 36.885），
等效 SINR 改善约 0.5-1.0 dB。

### 3.2 快衰落（每包独立）

`scenario.sinr_dB` 包含慢变分量（路径损耗+阴影衰落+平均干扰），
每个包还经历快衰落（小尺度衰落）：

```matlab
sigma_ff = is_nlos ? params.fast_fading_sigma_nlos : params.fast_fading_sigma_los;
sinr_instant = sinr_base + randn() * sigma_ff;
```

| 信道条件 | 衰落模型 | σ (dB) | 依据 |
|---------|---------|--------|------|
| LOS | Rician (K=3dB) | 3.0 | 3GPP TR 37.885 Table 6.2.1-1 |
| NLOS | Rayleigh-like | 4.5 | 3GPP TR 37.885, 林区多径更严重 |

### 3.3 SINR → PDR（sigmoid近似PER曲线）

使用sigmoid函数近似 WiLabV2Xsim 的 PER 曲线，避免运行时文件IO：

```matlab
function pdr = sinr_to_pdr_fast(sinr_dB, is_nlos)
    if is_nlos
        pdr = 1 / (1 + exp(-0.7 * (sinr_dB - 6.0)));  % NLOS midpoint=6dB
    else
        pdr = 1 / (1 + exp(-0.9 * (sinr_dB - 4.0)));  % LOS midpoint=4dB
    end
    pdr = min(max(pdr, 0.01), 0.999);
end
```

| SINR (dB) | PDR (NLOS) | PDR (LOS) |
|-----------|-----------|-----------|
| 0 | 0.015 | 0.027 |
| 3 | 0.109 | 0.289 |
| 6 | 0.500 | 0.858 |
| 9 | 0.891 | 0.989 |
| 12 | 0.985 | 0.999 |

### 3.4 传输模式分集增益

**Direct (mode=0)**: 单次传输

```matlab
pdr_attempt = pdr_single;
```

**Redundant (mode=1)**: HARQ盲重传（2个独立副本，选择合并）

```matlab
% 第二份副本经历独立快衰落
pdr_copy2 = sinr_to_pdr_fast(sinr_base + randn()*sigma_ff, is_nlos);
pdr_attempt = 1 - (1 - pdr_single) * (1 - pdr_copy2);
```

物理依据：NR-V2X 配置授权支持盲重传，两次传输在不同子帧经历独立衰落。
额外开销：+12ms（一个子帧间隔）。

**Relay (mode=2)**: 双跳中继

```matlab
pdr_relay = pdr_single * params.relay_link_ratio;  % 0.80
pdr_attempt = 1 - (1 - pdr_single) * (1 - pdr_relay);
```

物理依据：中继车辆提供空间分集，但中继链路SINR通常低于直连。
额外开销：+30ms（解码+重编码+转发）。

### 3.5 多次传输尝试（时间分集）

`rate_multiplier` 映射为传输尝试次数：`n_attempts = ceil(rate_multiplier)`。

每次尝试经历独立快衰落。首次成功即停止（early stopping）：

```matlab
for attempt = 1:n_attempts
    [delivered, pdr_attempt] = try_deliver(sinr_base, mode, ...);
    if rand() < pdr_attempt
        delivered = true;
        attempts_used = attempt;
        break;
    end
end
```

**关键权衡**：更多尝试提高 PDR，但每次额外尝试增加 14ms 延迟。
当延迟预算紧张时（如 70ms deadline），2att+redundant 的最坏延迟
可能超过 deadline。

### 3.6 投递判定

```matlab
delivered(k) = rand() < pdr_effective;  % Bernoulli trial
```

## 4. 延迟模型

```matlab
delay = base_access + congestion + mode_overhead + attempt_gaps + jitter
```

| 分量 | 公式 | 依据 |
|------|------|------|
| base_access | 12 ms | SPS资源选择+编码 |
| congestion | 45ms × (1-PDR_raw) | 信道质量差→重传队列长 |
| mode_overhead | redundant: 12ms, relay: 30ms | 重传子帧/中继转发 |
| attempt_gaps | 14ms × (attempts_used - 1) | 子帧间等待 |
| jitter | N(0, 0.12 × nominal) | MAC调度随机性 |

## 5. Utility 优化器更新

### 5.1 PDR 预测（无快衰落，使用期望值）

```matlab
sinr_pred = sinr_dB + priority_gain + emergency_bonus;
pdr_single = sinr_to_pdr_fast(sinr_pred, is_nlos);
pdr_attempt = mode_diversity(pdr_single, mode);
pdr_overall = 1 - (1 - pdr_attempt)^n_attempts;
```

### 5.2 混合延迟模型（mixture delay）

优化器计算 timely 概率为各尝试次数的加权和：

```matlab
timely_prob = Σ_{k=1}^{n} P(succeed on attempt k) × P(delay_k < deadline)
```

其中：
- `P(succeed on k) = pdr_attempt × (1-pdr_attempt)^(k-1)`
- `delay_k = base_delay + (k-1) × attempt_gap`
- `P(delay_k < deadline) = Φ((deadline - delay_k) / (jitter_scale × delay_k))`

## 6. 验证结果（Python v5, PosDeg_Emerg, 50 seeds）

```
Method                Timely    Std    CI95
Fixed                  0.583   0.103  [0.554, 0.611]
Link-aware             0.749   0.091  [0.724, 0.774]
Position-only          0.728   0.095  [0.702, 0.755]
Confidence-driven      0.765   0.107  [0.736, 0.795]
```

- 正确排序：Conf > Link > Pos > Fixed
- CI95：Conf vs Fixed 无重叠 ✓
- 所有方法 timely < 1.0（存在真实失败场景） ✓
- 所有方法 std > 0（随机性有效） ✓

**差异化机理**：
- Fixed 只有 1att+direct → PDR受限于单次快衰落 → 0.583
- Link-aware 盲目用 2att+redundant → 高 PDR 但低 SINR 时延迟超标 → 0.749
- Confidence-driven 按 SINR 自适应选择 1att+red 或 2att+dir → 最优 timely → 0.765

## 7. 参数总结

| 参数 | 值 | 物理依据 |
|------|-----|---------|
| priority_sinr_gain | 0.5 dB/level | SPS 资源预留减少碰撞 |
| emergency_sinr_bonus | 1.0 dB | Emergency 资源池优先接入 |
| fast_fading_sigma_los | 3.0 dB | Rician K=3dB (TR 37.885) |
| fast_fading_sigma_nlos | 4.5 dB | Rayleigh (TR 37.885) |
| relay_link_ratio | 0.80 | 中继链路 SINR 衰减 |
| pdr_midpoint_nlos | 6.0 dB | 拟合 WiLabV2Xsim NR MCS7 |
| pdr_midpoint_los | 4.0 dB | 拟合 WiLabV2Xsim LTE MCS7 |
| pdr_slope_nlos | 0.7 | 拟合 WiLabV2Xsim |
| pdr_slope_los | 0.9 | 拟合 WiLabV2Xsim |
| base_access_delay | 12 ms | SPS 授权周期 |
| mode_overhead_redundant | 12 ms | HARQ 盲重传子帧间隔 |
| mode_overhead_relay | 30 ms | 中继解码转发 |
| congestion_delay_max | 45 ms | 最大拥塞延迟 |
| attempt_gap | 14 ms | 传输尝试间隔 |
| delay_jitter_scale | 0.12 | MAC 调度随机性 |
| deadline_emergency | 70 ms | Emergency 消息时延要求 |

## 8. 对论文的写法建议

> "Packet delivery is modeled as a Bernoulli trial whose success probability
> is derived from calibrated PER curves (WiLabV2Xsim [ref]).
> The instantaneous SINR is computed from 3GPP path loss models with
> per-packet Rayleigh/Rician fast fading. Scheduling actions modify the
> effective delivery probability through three physically-grounded mechanisms:
> (i) HARQ blind retransmission providing selection combining gain,
> (ii) relay forwarding providing spatial diversity, and
> (iii) resource priority reducing collision probability.
> Multiple transmission attempts provide time diversity at the cost of
> additional delay, creating a fundamental PDR-delay tradeoff that the
> confidence-driven optimizer navigates per-packet."

## 9. 实施清单

- [x] Python 验证 v5 通过（方法排序正确，物理机制有效）
- [ ] 实现 `sinr_to_pdr_fast.m`
- [ ] 实现 `simulate_step9_delivery_physical.m`
- [ ] 更新 `predict_action_success.m` → 使用 SINR→PDR
- [ ] 更新 `predict_action_delay.m` → 使用物理延迟模型
- [ ] 更新 `compute_action_utility.m` → 混合延迟 timely 概率
- [ ] 更新 `get_default_step9_params.m` → 添加新参数
- [ ] 全场景运行验证（5个阶段）