function params = get_default_adaptive_constraint_params(dt)
%GET_DEFAULT_ADAPTIVE_CONSTRAINT_PARAMS Default parameters for adaptive constraint scheduling.

params = get_default_fusion_nhc_params(dt);

params.zupt_gain_min = 0.05;
params.zupt_gain_base = 0.15;
params.zupt_gain_max = 0.45;
params.zupt_gain_quality_scale = 0.25;

params.nhc_gain_min = 0.35;
params.nhc_gain_max = 0.90;
params.nhc_heading_min = 0.04;
params.nhc_heading_max = 0.18;
params.nhc_speed_ref = 0.8;
params.turn_rate_ref = deg2rad(6.0);
params.nhc_quality_floor = 0.25;
