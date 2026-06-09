function params = apply_step13_scenario_profile(params, gnss_level, rsu_level, load_level)
%APPLY_STEP13_SCENARIO_PROFILE Map Step 13 scenario labels into Step 9 parameters.

switch char(gnss_level)
    case 'Weak'
        params.gnss_degradation_scale = 0.75;
    case 'Medium'
        params.gnss_degradation_scale = 1.00;
    case 'Strong'
        params.gnss_degradation_scale = 1.30;
    otherwise
        error('Unknown GNSS degradation level: %s', gnss_level);
end

switch char(rsu_level)
    case 'Sparse'
        params.position_rsu_x = [26.0, 108.0];
        params.position_rsu_y = [9.0, -8.0];
        params.position_rsu_coverage = [42.0, 48.0];
    case 'Medium'
        params.position_rsu_x = [22.0, 64.0, 96.0, 142.0];
        params.position_rsu_y = [8.0, -9.0, 10.0, -8.0];
        params.position_rsu_coverage = [58.0, 52.0, 46.0, 62.0];
    case 'Dense'
        params.position_rsu_x = [18.0, 48.0, 78.0, 108.0, 132.0, 152.0];
        params.position_rsu_y = [8.0, -6.0, 9.0, -8.0, 7.0, -5.0];
        params.position_rsu_coverage = [64.0, 58.0, 54.0, 52.0, 58.0, 64.0];
    otherwise
        error('Unknown RSU sparsity level: %s', rsu_level);
end

if isfield(params, 'scenario_input') && isstruct(params.scenario_input)
    params.scenario_input.rsu_level = string(rsu_level);
    params.scenario_input.gnss_level = string(gnss_level);
end

switch char(load_level)
    case 'Low'
        load_scale = 0.75;
    case 'Medium'
        load_scale = 1.00;
    case 'High'
        load_scale = 1.35;
    otherwise
        error('Unknown load level: %s', load_level);
end

params.base_rate_normal = load_scale * params.base_rate_normal;
params.base_rate_coop = load_scale * params.base_rate_coop;
params.base_rate_emergency = load_scale * params.base_rate_emergency;
if isfield(params, 'scenario_input') && isstruct(params.scenario_input)
    params.scenario_input.load_level = string(load_level);
end
end
