function result = run_step9_proposed_method(scenario, params)
%RUN_STEP9_PROPOSED_METHOD Paper main method entry point.
%   The proposed method is the predictive drift-plus-penalty (DPP) scheduler
%   (run_step9_proposed_method_dpp). Time-varying virtual queues replace the
%   five FROZEN multipliers of the earlier risk-constrained v6 objective,
%   yielding the O(1/V)-O(V) optimality/backlog trade-off and a time-average
%   feasibility certificate (Neely, "Stochastic Network Optimization"), and
%   consolidating the five constraints to two (TS 22.186 reliability + GNSS
%   protection). On the production (physical per_lookup) path it matches v6 on
%   reliability at lower cost (see audit_mainline_matrix).
%
%   BASELINES (still available, documented as superseded):
%     run_step9_confidence_driven_risk_constrained_v6  -- frozen-weight objective
%     run_step9_confidence_driven_heuristic            -- earlier confidence rule

result = run_step9_proposed_method_dpp(scenario, params);
end
