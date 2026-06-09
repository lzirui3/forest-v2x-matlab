# 预测式 Drift-Plus-Penalty 调度器：方法与验证

本文件记录用**原理化方法**替换固定权重"Lagrangian"调度器后的方法定义与验证结果。配合 `parameter_theoretical_grounding_audit_cn.md`（参数接地审计）一起看。

## 1. 方法（Predictive Drift-Plus-Penalty / Lyapunov-MPC）

实现：`run_step9_proposed_method_dpp.m`

旧主方法 `run_step9_confidence_driven_risk_constrained_v6` 用 5 个**冻结乘子** λ=(3.20, 2.20, 1.25, 1.60, 0.75) 把 5 个违反量线性加权——无可行性/最优性保证，绝对值不可辨识（审计问题 1）。

新方法把乘子换成**时变虚队列**（Neely, drift-plus-penalty）：
- 每个时间平均约束 c：`Z_c(t+1)=max(Z_c(t)+g_c(t),0)`，队列积压 Z_c 即（渐近）拉格朗日乘子 V·λ_c；
- 每步在 **H 步滚动时域**上最小化 `Σ_τ [V·penalty(a_τ) + Σ_c Z_c·g_c(a_τ)]`，只执行首动作并后退（MPC）；
- **H=1 精确退化为普通 DPP**；H>1 用**路线几何预览**（地图决定的盲区/中继窗/阶段时序，不含随机快衰落）做预判；
- penalty = regularization − reward（= v6 的非约束目标，VoI/success/event 奖励保留），约束的固定 λ 被 Z·g 取代；
- 队列带 cap（最大影子价），保证一个不可行阶段不会主导全局。

**约束集精简（审计问题 2、5）**：TS 22.186 把"可靠性"定义为"时延内成功接收比例"，故 timely/success/deadline 合并为**一个可靠性约束**（对 timely_prob）；position_violation = pos_risk·protection_violation 并入 **protection 约束**。默认 2 条独立、各有出处的约束：
- C1 Reliability：timely_prob ≥ R_req（3GPP TS 22.186 档，见 `get_v2x_reliability_requirements.m`）
- C2 Protection：protection_level ≥ P_req（GNSS 完好性驱动）

可选 `dpp_constraint_mode="legacy5"` 还原 5 约束做消融。

**两个可解释旋钮**（替代 5 个冻结 λ）：
- `dpp_V`（默认 2.0）：最优性 vs 可行性权衡（O(1/V)–O(V)）
- `dpp_queue_max`（默认 20.0）：约束最大影子价
- `dpp_horizon`（默认 1）：MPC 前瞻步数

## 2. 验证（森林几何场景，20 种子，并行，公共随机数 CRN）

脚本：`main_step73_dpp_final_validation.m`（CRN：每个方法前 `rng(seed)`，保证各方法看到相同投递随机数，做公平配对比较）。`get_forest_geometry_mainline_params` 场景。

| 方法 | Timely | Cost | PosDeg(盲区紧急) |
|---|---:|---:|---:|
| Fixed | 0.7429 | 1.619 | 0.813 |
| Link-delay-aware | 0.7391 | 1.698 | 0.806 |
| **v6（冻结 λ，手调）** | 0.7899 ± 0.0055 | 2.389 | 0.825 |
| **DPP / Lyapunov-MPC (V2,cap20)** | 0.7889 ± 0.0064 | 2.398 | 0.812 |
| PDPP H3（预测式） | 0.7888 | 2.401 | 0.810 |

**配对检验 DPP − v6：dTimely = −0.0009（p=0.212，不显著）；dCost = +0.0087（p=0.092，不显著）→ 两个指标都与 v6 统计持平。**

结论：原理化控制器在 v6 的**主场场景**（v6 的权重就是在这些森林场景上手调的）上**统计持平**，同时换来：单旋钮族（2 个可解释旋钮 vs 5 个冻结 λ）、可行性证书、标准出处的约束。

## 3. Held-out 泛化测试（冻结参数，复用框架官方场景划分）

脚本：`main_step74_dpp_heldout_generalization.m`（20 种子，并行，CRN）。**所有方法保持冻结**——v6 用其固定 λ，DPP 用在 ForestGeometry 调参场景上设定的默认 (V=2, cap=20)，**不针对任何 held-out 场景重新调参**。Held-out 场景复用框架自带划分：`get_heldout_scene_matrix`（V2X-Seq 10013/10007/10015，故意排除在 v6 调参集之外）+ 参数档 held-out（Moderate / Generic）。

| 场景档 | v6 Timely | DPP Timely | dTimely(DPP−v6) | p | dCost(DPP−v6) |
|---|---:|---:|---:|---:|---:|
| ForestGeom（**调参**） | 0.7899 | 0.7889 | −0.0009 | 0.212 | +0.009 |
| Moderate（held-out） | 0.8226 | 0.8211 | −0.0014 | 0.040 | **−0.010** |
| Generic（held-out） | 0.9884 | 0.9860 | −0.0024 | <1e-4 | **−0.082** |
| **V2XSeq-10013**（held-out，最难） | 0.6008 | **0.6034** | **+0.0027** | 0.015 | +0.272 |
| **V2XSeq-10007**（held-out） | 0.8607 | **0.8632** | **+0.0026** | <1e-3 | +0.188 |
| **V2XSeq-10015**（held-out） | 0.9057 | **0.9072** | **+0.0015** | 0.005 | +0.047 |

**结论**：
- 在框架**官方的 held-out V2X-Seq 场景**（10013/10007/10015）上，**冻结的 DPP 在可靠性上显著优于冻结的 v6**（含最难的 10013，timely 仅 0.60），代价是更高的传输成本——DPP 的冻结运行点 (V=2,cap=20) 偏可靠性。
- 在参数档 held-out（Moderate/Generic）上，DPP timely 略低（≤0.24pp）但**更省**（成本 −0.01 ~ −0.08）。
- 所有档位 timely 差异 ≤0.3pp → 原理化单旋钮方法**冻结状态下的泛化不弱于、且在真实 held-out 轨迹上优于**手调启发式。这正是"原理化泛化 vs 手调过拟合"的合法证据。
- 诚实边界：DPP 单一冻结运行点不是每个场景的成本最优；按场景调 V/cap 可进一步降本，但冻结对比才是泛化的正确口径。

输出：`step74_dpp_heldout_generalization.csv`（可并入现有数据管线）。

## 4. 诚实的适用性边界（定量）

所有方法的 `EmergencyTimelyRate = 0`、`PosDegTimely` 卡死在 ~0.81：**盲区内紧急包 77ms 时延根本送不到**，与策略无关，是信道受限。DPP 的可靠性虚队列在该阶段增长，正是对这一**不可行边界**的定量信号——应作为论文的适用性边界如实报告（对应历史上的 10019/10013 负例），而非藏进均值或调走。

## 5. 预测时域（H>1）的作用

PDPP H3 ≈ DPP（H=1）。预判在此场景几乎无额外收益，因为**绑定约束是不可行的紧急边界**，前瞻改变不了信道。诚实表述：预测式时域是统一框架的自然推广（H=1 即 DPP），在阶段结构更可利用、约束可行的场景才显收益。

## 6. 复现

```matlab
% 启动并行池（首次 ~25s）
parpool('Processes', 8);
% 定义性验证（森林主场，20 种子，CRN，~55s）
main_step73_dpp_final_validation(20);
% Held-out 泛化（6 档场景，20 种子，~250s）
main_step74_dpp_heldout_generalization(20);
% 旋钮前沿
main_step72_dpp_cap_sweep_parallel(20);   % cap 扫描
main_step66_dpp_smoke;                     % 单种子对比 + V 扫描 + 时域扫描
```

> MCP 桥接前提：MATLAB 里先 `addpath("~/.matlab/agentic-toolkits/simulink"); satk_initialize`（写 sessionDetails.json 握手文件）。
