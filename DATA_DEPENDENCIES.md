# Data Dependencies

Large datasets are not committed to this repository. Keep them under:

```text
D:\matlab bussiness\forest_v2x_matlab_package\external_data
```

Expected optional resources include:

- `V2X-Seq` or V2X-Seq example trajectories/maps for data-backed traffic scenes.
- `WiLabV2Xsim` or compatible `PERcurves` for PER table lookup validation.
- `Forest_Roads_USFS` for forest-road geometry reconstruction.
- `Below_Canopy_Forestry` point-cloud files for forest canopy and attenuation proxies.
- Forest path/grid data used by forest-specific blockage and GNSS degradation profiles.

PER curves can be placed in one of the following local paths:

```text
external_data/WiLabV2Xsim/PERcurves
external_data/WiLabV2Xsim-main/PERcurves
external_data/CV2X-LOCA/PERcurves
```

The code contains fallback modes for abstract link delivery when external PER tables are unavailable, but paper-level validation should use the PER lookup or another documented physical-layer calibration source.
