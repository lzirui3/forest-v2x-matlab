function write_step29_vtc_applicability_report(T, out_path)
%WRITE_STEP29_VTC_APPLICABILITY_REPORT Write VTC applicability-boundary evidence.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step29 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 29 VTC Applicability Boundary Report\n\n');
fprintf(fid, 'This report converts the Step17 5-scene formal statistics into an applicability-boundary argument. ');
fprintf(fid, 'It is intended to address P1/P4/P6 without retuning the mainline parameters.\n\n');

fprintf(fid, '## Classification Rule\n\n');
fprintf(fid, '- `PrimaryEvidence`: full timely-rate gain is at least 3 pp and the row is suitable for main performance claims.\n');
fprintf(fid, '- `SupportingEvidence`: full timely-rate gain is at least 1 pp but below 3 pp.\n');
fprintf(fid, '- `BoundaryOnly`: the row should be used for ceiling, uniformly-hard, or costly-low-gain boundary discussion.\n');
fprintf(fid, '- `StressBoundary`: emergency delivery is physically near-impossible because constrained-oracle emergency timely rate is below 10%%.\n\n');

fprintf(fid, '## Applicability Summary\n\n');
fprintf(fid, '| Scene | Role | Config | Class | Paper Use | Base Timely | Conf Timely | Oracle Timely | Timely Delta (pp) | Base Emg | Conf Emg | Oracle Emg | Emg Delta (pp) | Cost Delta (%%) | Activation Proxy | Peak Stage |\n');
fprintf(fid, '|---|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %s | %s | %s | %.4f | %.4f | %.4f | %.3f | %.4f | %.4f | %.4f | %.3f | %.2f | %.3f | %s |\n', ...
        text_value(T.Scene, i), text_value(T.SceneRole, i), text_value(T.Config, i), ...
        text_value(T.ApplicabilityClass, i), text_value(T.PaperUse, i), ...
        T.BaseTimely(i), T.ConfTimely(i), T.OracleTimely(i), T.FullDeltaTimely_pp(i), ...
        T.BaseEmgTimely(i), T.ConfEmgTimely(i), T.OracleEmgTimely(i), T.FullDeltaEmg_pp(i), ...
        T.DeltaTxCostPct(i), T.JointActivationProxy(i), text_value(T.PeakGainStage, i));
end

fprintf(fid, '\n## Main-Claim Rows\n\n');
primary_rows = T(T.PaperUse == "PrimaryEvidence", :);
support_rows = T(T.PaperUse == "SupportingEvidence", :);
if isempty(primary_rows)
    fprintf(fid, 'No row is classified as `PrimaryEvidence`. The paper should not claim broad performance superiority.\n');
else
    for i = 1:height(primary_rows)
        fprintf(fid, '- `%s / %s`: timely gain %.3f pp, cost increase %.2f%%, peak stage `%s`.\n', ...
            text_value(primary_rows.Scene, i), text_value(primary_rows.Config, i), ...
            primary_rows.FullDeltaTimely_pp(i), primary_rows.DeltaTxCostPct(i), ...
            text_value(primary_rows.PeakGainStage, i));
    end
end

fprintf(fid, '\n## Supporting Rows\n\n');
if isempty(support_rows)
    fprintf(fid, 'No supporting rows were identified.\n');
else
    for i = 1:height(support_rows)
        fprintf(fid, '- `%s / %s`: timely gain %.3f pp; use as moderate supporting evidence.\n', ...
            text_value(support_rows.Scene, i), text_value(support_rows.Config, i), ...
            support_rows.FullDeltaTimely_pp(i));
    end
end

fprintf(fid, '\n## Boundary and Stress Rows\n\n');
boundary_rows = T(T.PaperUse == "BoundaryOnly" | T.PaperUse == "StressBoundary", :);
for i = 1:height(boundary_rows)
    fprintf(fid, '- `%s / %s` [%s]: %s\n', ...
        text_value(boundary_rows.Scene, i), text_value(boundary_rows.Config, i), ...
        text_value(boundary_rows.PaperUse, i), text_value(boundary_rows.Interpretation, i));
end

fprintf(fid, '\n## P1 / P4 / P6 Closure\n\n');
fprintf(fid, '- P1 is not closed as a performance improvement problem. It is reframed as a feasibility-boundary result when constrained-oracle emergency timely rate is near zero.\n');
fprintf(fid, '- P4 is closed only if the paper separates primary evidence from boundary rows. Rows with below-1-pp gain must not be counted as broad superiority evidence.\n');
fprintf(fid, '- P6 should be reported through significance and feasibility context. A negative emergency delta in a near-impossible row is not strong evidence of method failure, but it remains a limitation.\n\n');

fprintf(fid, '## Recommended Paper Wording\n\n');
fprintf(fid, 'The proposed scheduler should be claimed to improve timely delivery in scenes where blind-zone risk and positioning degradation create a non-trivial but still feasible reliability gap. ');
fprintf(fid, 'When the baseline is already saturated, the method exhibits graceful-boundary behavior; when the constrained oracle is also poor, the scenario should be interpreted as physically near-impossible rather than algorithmically solvable.\n');
end

function value = text_value(col, idx)
value = char(string(col(idx)));
end
