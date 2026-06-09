function params = get_default_fusion_nhc_params(dt)
%GET_DEFAULT_FUSION_NHC_PARAMS Return default parameters for residual-adaptive + NHC fusion.

params.dt = dt;
params.alpha_max = 0.25;
params.alpha_valid_min = 0.015;
params.zupt_velocity_gain = 0.15;
params.zupt_velocity_snap_threshold = 0.02;
params.residual_good_threshold = 1.2;
params.residual_bad_threshold = 4.5;
params.outlier_reject_threshold = 10.0;
params.residual_ema_decay = 0.92;
params.quality_smoothing = 0.92;
params.initial_quality = 0.9;
params.initial_residual_ema = 0.6;
params.residual_growth_no_gnss = 0.05;
params.quality_decay_no_gnss = 0.96;
params.max_position_correction = 0.12;
params.nhc_speed_threshold = 0.15;
params.nhc_eps_speed = 0.05;
params.nhc_velocity_gain = 0.90;
params.nhc_heading_gain = 0.10;
params.enable_nhc = true;
