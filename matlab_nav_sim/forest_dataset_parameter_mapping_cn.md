# 林区数据到模型参数的映射说明

本文件说明 `external_data` 中新增的林区数据如何支撑 `Step9` 主线参数校准。

## 1. Forest_Roads_USFS
路径：`external_data/Forest_Roads_USFS`

用途：
- 提供林区道路骨架、稀疏道路结构与较大车辆间距的现实参考。
- 对应参数：
  - `link_distance_scale`
  - `pathloss_los_offset_dB`
  - `pathloss_los_exponent`
  - `pathloss_nlos_offset_dB`
  - `pathloss_nlos_exponent`

解释：
- 林区道路网络通常比城市道路更稀疏，车间距离更易拉大。
- 这会导致链路平均传播距离增加、盲区更长、无遮挡到遮挡转换更敏感。

## 2. Below_Canopy_Forestry
路径：`external_data/Below_Canopy_Forestry`

用途：
- 提供林下环境点云与 GNSS/SLAM 退化场景参考。
- 对应参数：
  - `position_gnss_independent_noise_std`
  - `position_gnss_multipath_noise_std`
  - `position_blind_zone_sigma_penalty`
  - `position_blind_zone_score_penalty`
  - `position_rsu_relief_cap`
  - `confidence_regime_blind_threshold`
  - `confidence_regime_qpos_threshold`

解释：
- 林冠遮挡与林下环境复杂度会削弱 GNSS 稳定性，使定位可信度在关键区域更易下降。
- 这些参数控制定位可信度下降幅度以及 blind-zone 门控触发强度。

## 3. ForestPaths
路径：`external_data/ForestPaths`

用途：
- 提供森林路径网格和栅格参考，用于近似刻画通行路径受限、可视几何复杂、遮挡增强的场景。
- 对应参数：
  - `nlosv_extra_loss_dB`
  - `interference_scale`
  - `blind_link_loss_scale_dB`
  - `blind_interference_scale_dB`
  - `utility_blind_protection_threshold`
  - `utility_blind_pos_threshold`
  - `utility_blind_relay_threshold`

解释：
- 路径约束越强、遮挡越明显，链路在关键盲区阶段更容易退化。
- 这些参数主要影响 `PosDeg_Emerg` 段的链路与调度动作分化。

## 4. 使用方法
如需启用这套校准参数，可在 MATLAB 中执行：

```matlab
params = get_default_step9_mainline_params();
params = get_forest_dataset_calibrated_params(params);
```

该函数不会改动默认主线，属于可选校准入口。
