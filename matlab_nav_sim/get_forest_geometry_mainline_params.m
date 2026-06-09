function params = get_forest_geometry_mainline_params()
%GET_FOREST_GEOMETRY_MAINLINE_PARAMS
% Mainline params with optional forest-geometry calibration enabled.

params = get_default_step9_mainline_params();
params = get_forest_dataset_calibrated_params(params);
end
