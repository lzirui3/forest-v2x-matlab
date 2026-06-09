function result = run_step9_proposed_method(scenario, params)
%RUN_STEP9_PROPOSED_METHOD Paper main method entry point.
%   The VTC mainline uses the actual-cost-aware risk-constrained scheduler
%   with an emergency action floor. The earlier confidence heuristic remains
%   available through run_step9_confidence_driven_heuristic as a baseline.

result = run_step9_confidence_driven_risk_constrained_v6(scenario, params);
end
