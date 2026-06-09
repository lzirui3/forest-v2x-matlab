# Forest V2X MATLAB Simulation Project

This repository contains MATLAB code and reports for a forest-road emergency V2X scheduling study. The current mainline focuses on positioning-confidence-aware and risk-constrained warning-message scheduling under forest geometry, GNSS degradation, and V2X link uncertainty.

## Main MATLAB Directory

```matlab
cd('D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim');
```

## Recommended Entry Points

- Basic navigation simulation: `main_step1_truth`, `main_step2_imu`, `main_step3_fusion`
- Scheduling mainline: `main_step9_confidence_driven_scheduling`
- Ablation and sensitivity: `main_step10_position_ablation`, `main_step11_sensitivity`
- Multi-seed and scenario experiments: `main_step12_multiseed_statistics`, `main_step13_scenario_expansion`
- VTC-oriented evidence chain: `main_step40_proposed_method_vtc_resume`, `main_step54_literature_baselines_per_lookup_50seed`, `main_step59_stronger_literature_baselines`, `main_step60_moderate_forest_geometry`

## Data Policy

Large public datasets, third-party repositories, PER curve resources, geospatial data, and point-cloud files are intentionally excluded from Git tracking. See `DATA_DEPENDENCIES.md` for expected local paths and dependency notes.

## Notes

The repository keeps source code, concise reports, small summary tables, and generated figures that are useful for reproducing the research workflow. Bulk raw CSV outputs and large external datasets are excluded to keep the GitHub repository usable.
