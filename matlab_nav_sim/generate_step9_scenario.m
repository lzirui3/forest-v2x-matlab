function scenario = generate_step9_scenario(params, position_modules)
%GENERATE_STEP9_SCENARIO Create a simplified forest emergency communication scenario.

if nargin < 2 || isempty(position_modules)
    position_modules = get_default_position_module_config();
end

use_random = isfield(params, 'random_seed') && ~isempty(params.random_seed);
if use_random
    rng(params.random_seed, 'twister');
end

t = (0:params.dt:params.T_total)';
N = numel(t);
external = load_step9_external_inputs(params, t);

[msg_type, urgency, base_rate, deadline, relay_available] = ...
    resolve_step9_message_profile(params, t, use_random, external);
[n_sat, dop, sigma_pos, dt_upd] = resolve_step9_gnss_profile(params, t, use_random, external);

link = step9_generate_link_state_wilab_like(t, params, external);
pdr = link.pdr;
delay = link.delay;
loss = link.loss;

q_pos_rule = compute_positioning_confidence_rule(n_sat, dop, sigma_pos, dt_upd, params);
if external.has_rsu
    params.position_rsu_x = external.rsu.x;
    params.position_rsu_y = external.rsu.y;
    params.position_rsu_coverage = external.rsu.coverage;
end
position_state = step9_generate_positioning_state_cv2x_loca_like( ...
    t, n_sat, dop, sigma_pos, dt_upd, link, params, position_modules);
q_pos = position_state.q_pos;
q_link = compute_link_quality_rule(pdr, delay, loss);

scenario.t = t;
scenario.msg_type = msg_type;
scenario.urgency = urgency;
scenario.base_rate = base_rate;
scenario.deadline = deadline;
scenario.n_sat = n_sat;
scenario.dop = dop;
scenario.sigma_pos = sigma_pos;
scenario.dt_upd = dt_upd;
scenario.pdr = pdr;
scenario.delay = delay;
scenario.loss = loss;
scenario.distance = link.distance;
scenario.nlosv = link.nlosv;
scenario.is_nlos = link.is_nlos;
scenario.pathloss_dB = link.pathloss_dB;
scenario.shadowing_dB = link.shadowing_dB;
scenario.sinr_dB = link.sinr_dB;
scenario.relay_available = relay_available;
scenario.q_pos_rule = q_pos_rule;
scenario.q_pos = q_pos;
scenario.q_link = q_link;
scenario.gnss_score = position_state.gnss_score;
scenario.rsu_support_score = position_state.rsu_support_score;
scenario.env_score = position_state.env_score;
scenario.traj_score = position_state.traj_score;
scenario.blind_zone_gate = position_state.blind_zone_gate;
scenario.rsu_gain_gate = position_state.rsu_gain_gate;
scenario.env_correction_gate = position_state.env_correction_gate;
scenario.nearest_rsu_count = position_state.nearest_rsu_count;
scenario.nearest_rsu_distance = position_state.nearest_rsu_distance;
scenario.env_attenuation = position_state.env_attenuation;
scenario.position_coarse_sigma = position_state.coarse_sigma;
scenario.position_modules = position_state.modules;
scenario.position = position_state;
scenario.external_input = external;
scenario.random_draws = precompute_step9_random_draws(params, N);
end
