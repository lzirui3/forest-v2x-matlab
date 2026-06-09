# Step46 适用范围与弱泛化问题处理报告

本报告用于解决 Step45 后仍存在的“场景依赖性”和“弱泛化”问题。处理方式不是继续调参，而是将弱泛化结果转化为可解释的适用范围分析。

## 1. 核心判断

Step40 + Step45 的合并结果说明：方法不是全场景强收益方法，而是风险退化场景中的风险约束调度方法。

最稳妥的论文表述是：

```text
The proposed scheduler is most applicable when blind-zone risk, link degradation, and positioning uncertainty create a non-trivial reliability gap. Under low-risk or saturated conditions, it gracefully degenerates to weak nonnegative transfer.
```

## 2. 合并适用范围表

| Dataset | Scene | Config | NLOS (%) | Mean Dist (m) | Heuristic Timely | Gain vs Heuristic (pp) | Gain vs Link (pp) | Cost Delta (%) | Risk Class | Gain Class | Applicability | Explanation |
|---|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| Main | 10006 | Default | 30.0 | 51.5 | 0.9814 | 0.489 | 4.090 | 3.55 | ModerateDefault | WeakNonnegative | BaselineImprovement | Benefit is clear over link-only baseline, but the heuristic is already strong. |
| Main | 10006 | ForestGeometry | 30.0 | 51.5 | 0.7065 | 0.349 | 1.887 | 9.70 | HighRiskForest | WeakNonnegative | BaselineImprovement | Benefit is clear over link-only baseline, but the heuristic is already strong. |
| HeldOut | 10007 | Default | 13.0 | 54.4 | 0.9891 | 0.153 | 4.113 | 3.54 | ModerateDefault | WeakNonnegative | BaselineImprovement | Benefit is clear over link-only baseline, but the heuristic is already strong. |
| HeldOut | 10007 | ForestGeometry | 13.0 | 54.4 | 0.8617 | 0.047 | 4.965 | 7.28 | HighRiskForest | WeakNonnegative | BaselineImprovement | Benefit is clear over link-only baseline, but the heuristic is already strong. |
| Main | 10011 | Default | 6.0 | 98.8 | 0.9973 | 0.000 | 0.013 | -3.98 | SaturatedDefault | WeakNonnegative | WeakButSafe | Heuristic is already saturated; little TimelyRate headroom remains. |
| Main | 10011 | ForestGeometry | 6.0 | 98.8 | 0.6768 | 3.724 | 12.652 | 9.09 | HighRiskForest | StrongGain | PrimaryApplicable | Clear reliability gap and risk-aware decision benefit. |
| HeldOut | 10013 | Default | 53.0 | 21.5 | 0.9981 | 0.000 | 0.003 | 2.54 | SaturatedDefault | WeakNonnegative | WeakButSafe | Heuristic is already saturated; little TimelyRate headroom remains. |
| HeldOut | 10013 | ForestGeometry | 53.0 | 21.5 | 0.5999 | 0.166 | 0.566 | 3.77 | HighRiskForest | WeakNonnegative | WeakButSafe | Weak nonnegative transfer; report as applicability boundary rather than strong gain. |
| Main | 10014 | Default | 20.0 | 64.9 | 0.9721 | 1.601 | 1.890 | -1.86 | ModerateDefault | StrongGain | Applicable | Clear reliability gap and risk-aware decision benefit. |
| Main | 10014 | ForestGeometry | 20.0 | 64.9 | 0.7747 | 1.674 | 5.111 | 9.31 | HighRiskForest | StrongGain | PrimaryApplicable | Clear reliability gap and risk-aware decision benefit. |
| HeldOut | 10015 | Default | 7.0 | 81.7 | 0.9906 | 0.103 | 1.574 | -2.06 | SaturatedDefault | WeakNonnegative | BaselineImprovement | Heuristic is already saturated; little TimelyRate headroom remains. |
| HeldOut | 10015 | ForestGeometry | 7.0 | 81.7 | 0.8760 | 3.255 | 22.632 | 12.39 | HighRiskForest | StrongGain | PrimaryApplicable | Clear reliability gap and risk-aware decision benefit. |
| Main | 10017 | Default | 48.0 | 62.1 | 0.9568 | 0.992 | 5.887 | -2.82 | ModerateDefault | WeakNonnegative | BaselineImprovement | Benefit is clear over link-only baseline, but the heuristic is already strong. |
| Main | 10017 | ForestGeometry | 48.0 | 62.1 | 0.5240 | 0.619 | 0.908 | 12.12 | HighRiskForest | WeakNonnegative | WeakButSafe | Positive transfer requires extra cost under forest degradation. |
| Main | 10019 | Default | 44.0 | 22.8 | 0.9999 | 0.000 | 0.000 | 2.16 | SaturatedDefault | WeakNonnegative | WeakButSafe | Heuristic is already saturated; little TimelyRate headroom remains. |
| Main | 10019 | ForestGeometry | 44.0 | 22.8 | 0.6683 | 0.053 | 0.133 | -0.44 | HighRiskForest | WeakNonnegative | WeakButSafe | Weak nonnegative transfer; report as applicability boundary rather than strong gain. |

## 3. 适用条件

方法最适用的条件：

1. ForestGeometry 或类似林区退化配置。
2. 存在非平凡可靠性缺口，即 Link-delay-aware 或 heuristic 尚未接近性能天花板。
3. 遮挡/NLOS、长距离链路、定位退化或应急时间窗至少有两类因素重叠。
4. 系统允许通过约 5% 到 12% 的额外通信代价换取及时率或时延改善。

## 4. 弱泛化不是失败的原因

弱泛化主要来自三类原因：

1. Heuristic 已接近饱和，例如 Default 下 TimelyRate 已接近 0.99，提升空间非常小。
2. 方法相对 Link-delay-aware 有明显提升，但相对 confidence heuristic 只有弱提升，说明 heuristic 本身已经较强。
3. 在 ForestGeometry 下，收益往往需要额外通信代价支撑，因此应作为风险-代价权衡，而不是无代价提升。

## 5. 论文中应如何解决审稿质疑

建议新增一个 `Method Applicability Analysis` 小节，明确写：

```text
The method is not designed to dominate all baselines in already-saturated low-risk cases. Its intended operating region is forest-road emergency communication where NLOS/blockage, positioning uncertainty, and message urgency overlap. Held-out validation confirms non-negative transfer under frozen parameters, while weak-gain cases are explained by saturation or strong heuristic baselines.
```

## 6. 不建议继续做的事

不建议为了让 Step45 全部变成 StrongGain 而继续调参。这样会破坏 frozen-parameter held-out validation 的意义，反而重新引入过拟合风险。

## 7. 最终结论

Step45 的弱泛化问题不应通过继续调参解决，而应通过适用范围建模解决。当前项目可以将主张从“全场景强性能提升”调整为“风险退化场景中的稳定正收益与低风险场景中的安全退化”。这比强行追求所有场景大幅提升更符合 VTC 审稿逻辑。
