# 公开林区数据驱动的几何重建方案

## 1. 目标
本方案用于将当前项目中的公开林区数据，逐步转化为更具现实依据的林区消防应急道路场景。

当前不追求一次性重建完整高保真地图，而是优先完成三件事：
1. 道路尺度更像林区
2. 盲区/遮挡长度更像林区
3. GNSS 与链路退化的参数更像林区

## 2. 现有公开林区数据
### 2.1 Forest_Roads_USFS
路径：`external_data/Forest_Roads_USFS`

可提供的信息：
- 林区道路骨架
- 道路稀疏性
- 道路延伸尺度
- 路段长度分布

对当前模型最直接的作用：
- 增大平均车间有效传播距离
- 延长盲区阶段长度
- 增强道路稀疏结构下的中继必要性

对应当前主线参数：
- `link_distance_scale`
- `pathloss_los_offset_dB`
- `pathloss_los_exponent`
- `pathloss_nlos_offset_dB`
- `pathloss_nlos_exponent`

### 2.2 ForestPaths
路径：`external_data/ForestPaths`

可提供的信息：
- 林区路径网格
- 通行路径约束
- 栅格级路径覆盖区域

对当前模型最直接的作用：
- 约束盲区段的可视几何
- 增强关键路段遮挡与路径局促性
- 作为盲区长度和 blind segment 强度的几何参考

对应当前主线参数：
- `blind_link_loss_scale_dB`
- `blind_interference_scale_dB`
- `nlosv_extra_loss_dB`
- `utility_blind_protection_threshold`
- `utility_blind_pos_threshold`
- `utility_blind_relay_threshold`

### 2.3 Below_Canopy_Forestry
路径：`external_data/Below_Canopy_Forestry`

可提供的信息：
- 林下点云环境
- 林冠/林下遮挡复杂度
- GNSS 退化环境参考

对当前模型最直接的作用：
- 加强定位可信度下降幅度
- 限制 RSU 在严重遮挡时对定位可信度的过度补偿
- 使 blind-zone 触发更贴近林下环境

对应当前主线参数：
- `position_gnss_independent_noise_std`
- `position_gnss_multipath_noise_std`
- `position_blind_zone_sigma_penalty`
- `position_blind_zone_score_penalty`
- `position_rsu_relief_cap`
- `confidence_regime_blind_threshold`
- `confidence_regime_qpos_threshold`

## 3. 当前已实现的落地方式
目前已经通过：
- `get_forest_dataset_calibrated_params.m`
- `get_forest_geometry_mainline_params.m`

将上述三类数据映射为一套可直接调用的林区参数组。

使用方法：
```matlab
params = get_forest_geometry_mainline_params();
scenario = generate_step9_scenario(params);
```

## 4. 下一阶段如何从“参数校准”升级到“几何重建”
### 阶段 A：参数层几何重建（当前已具备）
特点：
- 不改轨迹骨架
- 只通过林区数据校准距离、遮挡、GNSS 退化和盲区门控

适合当前阶段：
- 快速推进论文主线
- 先验证方法在林区化参数下是否仍有效

### 阶段 B：道路骨架几何重建（下一步可做）
目标：
- 从 `Forest_Roads_USFS` 中选取一段典型林区道路
- 提取折线骨架
- 用骨架重新定义主车/邻车轨迹走向与弯道阶段

对应改动位置：
- `prepare_step9_v2xseq_inputs.m`
- 或新增 `prepare_forest_geometry_inputs.m`

### 阶段 C：盲区段显式几何重建（后续增强）
目标：
- 利用 `ForestPaths` 栅格与点云环境定义关键 blind segment
- 明确哪些路段属于开阔、过渡、盲区、恢复

对应改动位置：
- `define_step9_stage_masks.m`
- `step9_generate_link_state_wilab_like.m`
- `step9_generate_positioning_state_cv2x_loca_like.m`

## 5. 当前最推荐的用法
现阶段不建议立即重写整条轨迹生成链，而建议先做：
1. 默认主线参数运行一次
2. 林区几何校准参数运行一次
3. 比较 `Step9 / Step10 / Step12`

这样你就能回答一个对论文最重要的问题：
**当场景几何和环境参数更接近林区时，主方法是否仍然有效，甚至是否更有价值。**
