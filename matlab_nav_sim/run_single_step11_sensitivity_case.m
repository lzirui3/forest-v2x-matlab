function result = run_single_step11_sensitivity_case(param_name, param_value)
%RUN_SINGLE_STEP11_SENSITIVITY_CASE Run one Step 11 scheduling sensitivity case.

params = get_default_step9_mainline_params();
default_value = params.(param_name);
params.(param_name) = param_value;

scenario = generate_step9_scenario(params);
method_result = run_step9_confidence_driven(scenario, params);
stage_metrics = compute_step9_stage_metrics(scenario, method_result, define_step9_stage_masks(scenario.t));

result.param_name = string(param_name);
result.param_value = param_value;
result.default_value = default_value;
result.avg_delay_s = get_overall_metric(method_result.delivery.delay, method_result.delivery.delivered);
result.timely_rate = mean(method_result.delivery.deadline_hit);
result.loss_rate = 1.0 - mean(method_result.delivery.delivered);
result.avg_tx_cost = mean(method_result.delivery.tx_cost);

idx_emg = scenario.msg_type == "emergency";
result.emergency_timely_rate = mean(method_result.delivery.deadline_hit(idx_emg));

result.posdeg_avg_delay_s = get_stage_metric(stage_metrics, 'PosDeg_Emerg', 'avg_delay_s');
result.posdeg_timely_rate = get_stage_metric(stage_metrics, 'PosDeg_Emerg', 'timely_rate');
result.posdeg_loss_rate = get_stage_metric(stage_metrics, 'PosDeg_Emerg', 'loss_rate');
result.posdeg_avg_tx_cost = get_stage_metric(stage_metrics, 'PosDeg_Emerg', 'avg_tx_cost');
result.posdeg_emergency_timely_rate = get_stage_metric(stage_metrics, 'PosDeg_Emerg', 'emergency_timely_rate');

function value = get_overall_metric(delay_vec, delivered_mask)
delay_stage = delay_vec(delivered_mask);
if isempty(delay_stage)
    value = NaN;
else
    value = mean(delay_stage);
end
end

function value = get_stage_metric(metrics, stage_name, field_name)
value = NaN;
for ii = 1:numel(metrics)
    if strcmp(metrics(ii).stage, stage_name)
        value = metrics(ii).(field_name);
        return;
    end
end
end
end
