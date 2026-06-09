function pdr = sinr_to_pdr_physical(sinr_dB, is_nlos, params)
%SINR_TO_PDR_PHYSICAL Unified SINR->PDR entry for physical-layer evaluation.

if nargin < 3 || isempty(params)
    params = struct();
end

mode = "sigmoid";
if isfield(params, 'physical_pdr_mode') && strlength(string(params.physical_pdr_mode)) > 0
    mode = string(params.physical_pdr_mode);
end

switch lower(char(mode))
    case 'per_lookup'
        if is_nlos
            scenario_tag = paramsafe(params, 'per_curve_nlos_tag', "urban_nlos");
        else
            scenario_tag = paramsafe(params, 'per_curve_los_tag', "highway_los");
        end
        pdr = step9_wilab_like_sinr_to_pdr(sinr_dB, scenario_tag, params);
    otherwise
        pdr = sinr_to_pdr_fast(sinr_dB, is_nlos, params);
end

pdr = min(max(pdr, 0.01), 0.999);
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
