clc;
clear;
close all;

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);

params = get_default_step9_mainline_params();
scenario = generate_step9_scenario(params);

linkd = run_step9_baseline_link_delayaware(scenario, params);
conf = run_step9_confidence_driven(scenario, params);
oracle = run_step9_baseline_oracle(scenario, params);

stages = define_step9_stage_masks(scenario.t);
rows = [];

for i = 1:numel(stages)
    idx = stages(i).mask;

    linkd_timely = mean(linkd.delivery.deadline_hit(idx));
    conf_timely = mean(conf.delivery.deadline_hit(idx));
    oracle_timely = mean(oracle.delivery.deadline_hit(idx));

    linkd_loss = 1.0 - mean(linkd.delivery.delivered(idx));
    conf_loss = 1.0 - mean(conf.delivery.delivered(idx));
    oracle_loss = 1.0 - mean(oracle.delivery.delivered(idx));

    linkd_cost = mean(linkd.delivery.tx_cost(idx));
    conf_cost = mean(conf.delivery.tx_cost(idx));
    oracle_cost = mean(oracle.delivery.tx_cost(idx));

    timely_gain = conf_timely - linkd_timely;
    loss_reduction = linkd_loss - conf_loss;
    cost_delta = conf_cost - linkd_cost;

    if abs(cost_delta) > 1.0e-9
        benefit_cost_ratio = timely_gain / cost_delta;
        loss_cost_ratio = loss_reduction / cost_delta;
    else
        benefit_cost_ratio = NaN;
        loss_cost_ratio = NaN;
    end

    row = table( ...
        string(stages(i).name), ...
        linkd_timely, conf_timely, oracle_timely, ...
        linkd_loss, conf_loss, oracle_loss, ...
        linkd_cost, conf_cost, oracle_cost, ...
        timely_gain, loss_reduction, cost_delta, ...
        benefit_cost_ratio, loss_cost_ratio, ...
        'VariableNames', { ...
        'Stage', ...
        'Timely_LinkDelay', 'Timely_Conf', 'Timely_ConstrainedOracle', ...
        'Loss_LinkDelay', 'Loss_Conf', 'Loss_ConstrainedOracle', ...
        'Cost_LinkDelay', 'Cost_Conf', 'Cost_ConstrainedOracle', ...
        'TimelyGain_ConfVsLinkDelay', 'LossReduction_ConfVsLinkDelay', 'CostDelta_ConfVsLinkDelay', ...
        'TimelyGainPerCost', 'LossReductionPerCost'});

    if isempty(rows)
        rows = row;
    else
        rows = [rows; row]; %#ok<AGROW>
    end
end

T = rows;
disp(T);
writetable(T, 'step14_critical_stage_benefit_table.csv');

plot_step14_critical_stage_benefit(T);

disp('Step 14 complete: critical-stage benefit analysis generated.');
