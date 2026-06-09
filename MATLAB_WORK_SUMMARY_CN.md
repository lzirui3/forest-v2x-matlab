# MATLAB 工作包总结

## 1. 项目目标
本工作包围绕“林区盲区/遮挡场景下的 V2X 应急预警消息调度与定位可信度支撑仿真”构建，核心目标是形成一条可复现实验主线，而不是停留在概念框架。

## 2. 现有内容结构
### 2.1 Step1-Step8：导航与可信度铺垫
- Step1 `main_step1_truth.m`：生成理想轨迹真值。
- Step2 `main_step2_imu.m`：IMU 误差注入与纯惯导漂移。
- Step3 `main_step3_fusion.m`：GNSS/IMU 融合基线。
- Step4 `main_step4_adaptive_fusion.m`：自适应融合。
- Step5 `main_step5_residual_adaptive.m`：残差驱动自适应。
- Step6 `main_step6_nhc.m`：非完整约束加入。
- Step7 `main_step7_sensitivity.m`：早期敏感性分析。
- Step8 `main_step8_constraint_scheduling.m` 及配套脚本：约束调度原型与阶段统计。

### 2.2 Step9-Step13：论文主线
- Step9 `main_step9_confidence_driven_scheduling.m`
  主线实验：比较 Fixed / Priority-only / Link-aware / Position-only / Event-only / Confidence-driven。
- Step10 `main_step10_position_ablation.m`
  模块消融：GNSS / RSU / 环境 / 轨迹等对子系统贡献分析。
- Step11 `main_step11_sensitivity.m`
  参数敏感性分析。
- Step12 `main_step12_multiseed_statistics.m`
  多随机种子统计验证。
- Step13 `main_step13_scenario_expansion.m`
  场景扩展分析。

### 2.3 核心方法文件
- 场景生成：`generate_step9_scenario.m`
- 外部数据接入：`load_step9_external_inputs.m`
- V2X-Seq 输入生成：`prepare_step9_v2xseq_inputs.m`
- 决策器：`decide_schedule_action.m`
- 效用函数：`compute_action_utility.m`
- 链路生成：`step9_generate_link_state_wilab_like.m`
- 定位状态生成：`step9_generate_positioning_state_cv2x_loca_like.m`
- 统一投递入口：`simulate_step9_delivery.m`
- 物理投递模型：`simulate_step9_delivery_physical.m`

## 3. 当前主线的重要升级
已纳入以下改动：
- `simulate_step9_delivery.m` 已改为统一入口，支持在主线中切换抽象投递模型与物理投递模型。
- `get_default_step9_mainline_params.m` 默认开启 `use_physical_delivery = true`。
- `step9_wilab_like_sinr_to_pdr.m` 已去除本地硬编码路径，支持：
  - `params.per_curves_dir`
  - 环境变量 `STEP9_PER_CURVES_DIR`
  - 项目内 `external_data/.../PERcurves`
- `step9_generate_link_state_wilab_like.m` 已将 `params` 透传给 PER 曲线映射函数。

## 4. 已携带数据资源
当前工作包中已复制：
- `external_data/V2X-Seq-TFD-Example`
- `external_data/DAIR-V2X-Seq`
- `matlab_nav_sim/step9_data_templates`

这些资源足以支撑 V2X-Seq 轨迹驱动的 Step9-Step13 场景生成。

## 5. 当前仍存在的资源缺口
物理投递主线依赖 WiLabV2Xsim 的 `PERcurves` 资源。当前工作包内未发现：
- `PER_LTE_MCS7_350B.txt`
- `PER_NR_MCS7_100B.txt`

因此：
- 抽象投递模型可直接运行。
- 物理投递模型代码已就位，但若没有额外 PER 曲线文件，主线运行到 SINR→PDR 映射时会报错。

## 6. 建议运行顺序
### 6.1 先做基础核查
1. `main_step1_truth.m`
2. `main_step2_imu.m`
3. `main_step3_fusion.m`

### 6.2 再做论文主线
1. `main_step9_confidence_driven_scheduling.m`
2. `main_step10_position_ablation.m`
3. `main_step11_sensitivity.m`
4. `main_step12_multiseed_statistics.m`
5. `main_step13_scenario_expansion.m`

## 7. 论文角度的当前状态
当前工作包已经具备：
- 一条完整 MATLAB 仿真主线
- V2X-Seq 轨迹支撑的数据输入能力
- 消融、敏感性、多种子、场景扩展四类论文常用实验
- 物理投递模型接口

但仍未完全解决的方法学问题是：
- 决策器与效用函数仍偏启发式
- 缺少更严格的目标函数推导和公平基线增强

这意味着：
- 工程框架已经成型
- 论文方法学仍需进一步打磨
