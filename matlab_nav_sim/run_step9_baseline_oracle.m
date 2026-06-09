function result = run_step9_baseline_oracle(scenario, params)
%RUN_STEP9_BASELINE_ORACLE Per-message oracle upper bound under the same action space.

N = numel(scenario.t);
priority = zeros(N, 1);
tx_rate = zeros(N, 1);
mode = zeros(N, 1);
score = zeros(N, 1);

for k = 1:N
    event_state = build_event_state(scenario, k);
    context.sinr_dB = scenario.sinr_dB(k);
    context.is_nlos = scenario.is_nlos(k);
    context.msg_type = scenario.msg_type(k);
    context.deadline = scenario.deadline(k);
    actions = enumerate_schedule_actions(scenario.relay_available(k), scenario.base_rate(k), params);
    best_idx = 1;
    best_score = -inf;
    best_relaxed_idx = 1;
    best_relaxed_score = -inf;
    best_relaxed_violation = inf;
    required_timely = compute_required_timely_target( ...
        scenario.urgency(k), scenario.q_link(k), scenario.q_pos(k), event_state, params);

    for i = 1:numel(actions)
        action = actions(i);
        action.is_emergency = scenario.urgency(k) >= 0.80;

        aux = evaluate_action_metrics( ...
            scenario.urgency(k), scenario.q_link(k), scenario.q_pos(k), action, ...
            scenario.relay_available(k), scenario.base_rate(k), params, event_state, context);
        oracle_score = 1.20 * aux.timely_prob + 0.80 * aux.success_prob - 0.03 * aux.tx_cost;

        violation = compute_action_violation_score( ...
            action, scenario.urgency(k), scenario.q_link(k), scenario.q_pos(k), ...
            scenario.relay_available(k), params, event_state, required_timely, aux);
        if violation < best_relaxed_violation - 1.0e-9 ...
                || (abs(violation - best_relaxed_violation) <= 1.0e-9 && oracle_score > best_relaxed_score)
            best_relaxed_idx = i;
            best_relaxed_score = oracle_score;
            best_relaxed_violation = violation;
        end

        if ~is_action_feasible(action, scenario.urgency(k), scenario.q_link(k), ...
                scenario.q_pos(k), scenario.relay_available(k), params, event_state)
            continue;
        end

        if oracle_score > best_score
            best_score = oracle_score;
            best_idx = i;
        end
    end

    if ~isfinite(best_score)
        best_idx = best_relaxed_idx;
        best_score = best_relaxed_score;
    end

    best_action = actions(best_idx);
    priority(k) = best_action.priority;
    tx_rate(k) = best_action.tx_rate;
    mode(k) = best_action.mode;
    score(k) = best_score;
end

policy.priority = priority;
policy.tx_rate = tx_rate;
policy.mode = mode;
policy.score = score;

delivery = simulate_step9_delivery(scenario, policy, params);

result.name = "Constrained Oracle";
result.policy = policy;
result.delivery = delivery;
end

function event_state = build_event_state(scenario, k)
event_state.blind_zone_gate = 0.0;
event_state.rsu_gain_gate = 0.0;
event_state.env_correction_gate = 0.0;
if isfield(scenario, 'blind_zone_gate')
    event_state.blind_zone_gate = scenario.blind_zone_gate(k);
end
if isfield(scenario, 'rsu_gain_gate')
    event_state.rsu_gain_gate = scenario.rsu_gain_gate(k);
end
if isfield(scenario, 'env_correction_gate')
    event_state.env_correction_gate = scenario.env_correction_gate(k);
end
event_state.use_gnss = false;
event_state.use_rsu = false;
event_state.use_env = false;
event_state.use_traj = false;
if isfield(scenario, 'position_modules')
    event_state.use_gnss = scenario.position_modules.use_gnss;
    event_state.use_rsu = scenario.position_modules.use_rsu;
    event_state.use_env = scenario.position_modules.use_env;
    event_state.use_traj = scenario.position_modules.use_traj;
end
end

function tx_cost = infer_oracle_cost(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
tx_cost = mode_cost * action.tx_rate;
end
