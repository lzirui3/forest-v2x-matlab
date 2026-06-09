# Forest Calibration Report

This report documents how forest-scene parameters are derived from packaged datasets and literature-guided mappings.

## Data Statistics

- Road length p75: 2482.70 m
- Road curvature mean: 0.1947 rad
- Vegetation cover p75: 255.0000
- Vegetation cover p90: 255.0000
- Point-cloud z p75: 18.0320 m
- Point-cloud z p90: 23.2531 m

## Derived Parameters

| Parameter | Value | Derivation |
|---|---:|---|
| link\_distance\_scale | 1.8000 | road length p75 / 60m |
| pathloss\_los\_exponent | 28.5000 | 10 × alpha\_los, alpha\_los derived from curvature and vegetation density |
| pathloss\_nlos\_exponent | 37.5000 | 10 × alpha\_nlos, alpha\_nlos > alpha\_los |
| nlosv\_extra\_loss\_dB | 7.0000 | vegetation attenuation severity |
| blind\_link\_loss\_scale\_dB | 7.5000 | vegetation density norm |
| position\_gnss\_independent\_noise\_std | 0.1339 | canopy severity from raster + pointcloud |
| position\_gnss\_multipath\_noise\_std | 0.2099 | canopy severity from raster + pointcloud |
| confidence\_regime\_qpos\_threshold | 0.7649 | harder canopy => earlier regime activation |
| utility\_blind\_relay\_threshold | 0.8600 | dense canopy => stronger relay trigger |

## Notes

- The pathloss exponents in the simulator use the `10*alpha` convention in dB/decade form, not the raw linear-domain exponent itself.
- Vegetation-induced attenuation is not claimed as a direct electromagnetic fit; it is a traceable data-guided calibration built on raster/pointcloud severity indicators and literature-inspired monotonic mappings.
