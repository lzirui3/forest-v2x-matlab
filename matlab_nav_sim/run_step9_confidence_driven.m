function result = run_step9_confidence_driven(scenario, params)
%RUN_STEP9_CONFIDENCE_DRIVEN Main confidence-driven adaptive scheduling method.
% Paper mainline keeps the stronger heuristic selector; the Lyapunov
% version is evaluated separately as a formalized counterpart.

result = run_step9_confidence_driven_heuristic(scenario, params);
result.name = "Confidence-driven";
end
