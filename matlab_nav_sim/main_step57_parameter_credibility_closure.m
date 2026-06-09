clc;
clear;
close all;

% Step57: parameter credibility closure.
% This is a documentation/evidence step; it does not run simulations or tune
% Risk-constrained-v6 parameters.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step57_parameter_credibility_closure";
params_default = get_default_step9_mainline_params();
params_forest = get_forest_geometry_mainline_params();
calib = calibrate_forest_scene_params();

T_resources = build_resource_table_local();
T_categories = build_parameter_category_table_local(params_default, params_forest, calib);
T_values = build_key_parameter_values_local(params_default, params_forest, calib);
T_claims = build_claim_boundary_table_local();

writetable(T_resources, prefix + "_resources.csv");
writetable(T_categories, prefix + "_parameter_categories.csv");
writetable(T_values, prefix + "_key_parameter_values.csv");
writetable(T_claims, prefix + "_claim_boundaries.csv");
write_step57_parameter_credibility_report_cn(T_resources, T_categories, T_values, T_claims, ...
    prefix + "_report_cn.md");

disp(T_categories);
fprintf('Step57 complete: parameter credibility closure generated.\n');

function T = build_resource_table_local()
repo_dir = fileparts(fileparts(mfilename('fullpath')));
resources = [
    "USFS forest road shapefile", "external_data/Forest_Roads_USFS/S_USA.RoadCore_FS.shp", "Road geometry / curvature / segment-length statistics";
    "ForestPaths vegetation raster", "external_data/ForestPaths/merged_pred_q050_ulx_5900_uly_1640.tif", "Vegetation cover and attenuation severity proxy";
    "Below-canopy point cloud", "external_data/Below_Canopy_Forestry/Below_canopy_pointcloud_2024-11-15-08-45-11.pcd", "Canopy-density proxy for GNSS degradation";
    "WiLabV2Xsim PER LOS table", "external_data/WiLabV2Xsim-main/PERcurves/G5-UrbanLOS/PER_LTE_MCS7_350B.txt", "PER lookup physical-layer calibration";
    "WiLabV2Xsim PER NLOS table", "external_data/WiLabV2Xsim-main/PERcurves/G5-UrbanNLOS/PER_NR_MCS7_100B.txt", "PER lookup physical-layer calibration"];

Name = resources(:, 1);
RelativePath = resources(:, 2);
Role = resources(:, 3);
Exists = false(size(Name));
FileSizeBytes = zeros(size(Name));
for i = 1:numel(Name)
    p = fullfile(repo_dir, replace(RelativePath(i), "/", filesep));
    Exists(i) = isfile(p);
    if Exists(i)
        info = dir(p);
        FileSizeBytes(i) = info.bytes;
    end
end
T = table(Name, RelativePath, Role, Exists, FileSizeBytes);
end

function T = build_parameter_category_table_local(~, ~, ~)
Category = [
    "Scenario trajectory and topology";
    "PER lookup physical layer";
    "Default physical deadlines";
    "Forest pathloss and attenuation";
    "GNSS / positioning degradation";
    "Risk-constrained objective weights";
    "DCC-like literature baseline";
    "AoI-aware literature baseline";
    "Constrained Oracle"];
SourceType = [
    "V2X-Seq scene metadata + generated scenario";
    "External PER tables";
    "Engineering safety-deadline setting";
    "Forestry data statistics + literature-guided monotonic mapping";
    "Vegetation raster + point-cloud proxy mapping";
    "Frozen engineering Lagrangian weights";
    "Literature-inspired standard-style baseline";
    "Literature-inspired freshness baseline";
    "Bounded-action diagnostic reference"];
EvidenceStrength = [
    "Medium";
    "Medium-High";
    "Medium";
    "Medium";
    "Medium";
    "Medium-Low";
    "Medium";
    "Medium";
    "DiagnosticOnly"];
PaperClaimAllowed = [
    "Data-informed simulation scenarios";
    "PER-table-calibrated physical-layer lookup";
    "Deadline-constrained safety-message evaluation";
    "Forestry-data-informed attenuation model";
    "Canopy-informed positioning degradation model";
    "Risk-constrained online finite-action scheduler with frozen parameters";
    "ETSI-DCC-style comparison baseline";
    "AoI-aware comparison baseline";
    "Constrained oracle, not global optimum"];
PaperClaimForbidden = [
    "Do not claim real field driving experiment";
    "Do not claim forest-measured V2X PER validation";
    "Do not claim regulatory deadline certification";
    "Do not claim direct electromagnetic fitting";
    "Do not claim measured GNSS receiver calibration";
    "Do not claim globally optimal weights";
    "Do not claim full ETSI stack implementation";
    "Do not claim full AoI theory optimum";
    "Do not call it an unconstrained global oracle"];
T = table(Category, SourceType, EvidenceStrength, PaperClaimAllowed, PaperClaimForbidden);
end

function T = build_key_parameter_values_local(params_default, params_forest, calib)
names = [
    "deadline_normal";
    "deadline_coop";
    "deadline_emergency";
    "final_physical_pdr_mode";
    "pathloss_los_exponent";
    "pathloss_nlos_exponent";
    "nlosv_extra_loss_dB";
    "position_gnss_independent_noise_std";
    "position_gnss_multipath_noise_std";
    "utility_blind_protection_threshold";
    "utility_blind_pos_threshold";
    "objective_timely_lambda";
    "objective_success_lambda";
    "risk_v4_actual_cost_weight";
    "risk_v6_emergency_floor";
    "dcc_cbr_low_threshold";
    "dcc_cbr_high_threshold";
    "aoi_age_norm_cap";
    "aoi_critical_threshold"];

DefaultValue = strings(numel(names), 1);
ForestGeometryValue = strings(numel(names), 1);
SourceNote = strings(numel(names), 1);
for i = 1:numel(names)
    name = names(i);
    DefaultValue(i) = value_to_string_local(params_default, name);
    ForestGeometryValue(i) = value_to_string_local(params_forest, name);
    SourceNote(i) = source_note_local(name, calib);
end
T = table(names, DefaultValue, ForestGeometryValue, SourceNote, ...
    'VariableNames', {'Parameter','DefaultValue','ForestGeometryValue','SourceNote'});
end

function T = build_claim_boundary_table_local()
Claim = [
    "The final physical-layer evidence uses PER lookup.";
    "Forest geometry parameters are data-informed.";
    "Risk-constrained-v6 is frozen for Step49-58.";
    "DCC-like and AoI-aware are literature-inspired baselines.";
    "Negative cases 10019/10013 are applicability boundaries."];
AllowedWording = [
    "PER-table-calibrated physical-layer lookup";
    "forestry-data-informed simulation";
    "frozen-parameter validation";
    "ETSI-DCC-style and AoI-aware baseline comparisons";
    "boundary cases caused by deadline-reliability/cost trade-off"];
ForbiddenWording = [
    "real forest V2X measurement validation";
    "fully realistic forest propagation model";
    "globally optimal or adaptively tuned after seeing test scenes";
    "complete standards-compliant DCC stack or optimal AoI policy";
    "hide in averages or tune away the negative cases"];
T = table(Claim, AllowedWording, ForbiddenWording);
end

function out = value_to_string_local(params, name)
if name == "final_physical_pdr_mode"
    out = "per_lookup_forced_step49_step50_step54";
elseif name == "objective_timely_lambda"
    out = "3.20";
elseif name == "objective_success_lambda"
    out = "2.20";
elseif name == "risk_v4_actual_cost_weight"
    out = "0.060";
elseif name == "risk_v6_emergency_floor"
    out = "priority>=3, rate>=2.1x";
elseif isfield(params, name)
    value = params.(name);
    if isnumeric(value)
        out = string(mat2str(value, 5));
    else
        out = string(value);
    end
else
    out = "NA";
end
end

function note = source_note_local(name, calib)
switch char(name)
    case {'pathloss_los_exponent','pathloss_nlos_exponent','nlosv_extra_loss_dB'}
        note = sprintf('Forest calibration: road curvature %.4f, veg density %.3f', ...
            calib.road_stats.curvature_mean, calib.vegetation_stats.cover_density_norm);
    case {'position_gnss_independent_noise_std','position_gnss_multipath_noise_std'}
        note = sprintf('Canopy proxy: point-cloud density %.3f, veg attenuation %.3f', ...
            calib.pointcloud_stats.canopy_density_norm, calib.vegetation_stats.attenuation_norm);
    case "final_physical_pdr_mode"
        note = 'Final Step49, Step50, and Step54 scripts explicitly force params.physical_pdr_mode to per_lookup';
    case "objective_timely_lambda"
        note = 'Objective default: risk_constrained_timely_lambda = 3.20 in compute_action_risk_constrained_objective_v4';
    case "objective_success_lambda"
        note = 'Objective default: risk_constrained_success_lambda = 2.20 in compute_action_risk_constrained_objective_v4';
    case "risk_v4_actual_cost_weight"
        note = 'V6 default actual-cost weight: 0.060 if not provided';
    case "risk_v6_emergency_floor"
        note = 'V6 emergency floor: priority >= 3 and rate multiplier >= 2.1 when urgency is emergency-level';
    case {'dcc_cbr_low_threshold','dcc_cbr_high_threshold'}
        note = 'DCC-style congestion threshold used as literature-inspired baseline parameter';
    case {'aoi_age_norm_cap','aoi_critical_threshold'}
        note = 'AoI-aware freshness baseline parameter';
    case {'deadline_normal','deadline_coop','deadline_emergency'}
        note = 'Physical safety-message deadline setting used consistently across final PER lookup evidence';
    otherwise
        note = 'Default project parameter';
end
note = string(note);
end
