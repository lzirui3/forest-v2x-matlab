function pdr = sinr_to_pdr_fast(sinr_dB, is_nlos, params)
%SINR_TO_PDR_FAST Sigmoid approximation of WiLabV2Xsim PER curves.
%   pdr = sinr_to_pdr_fast(sinr_dB, is_nlos)
%
%   Maps instantaneous SINR (dB) to Packet Delivery Rate using a sigmoid
%   approximation fitted to WiLabV2Xsim PER curves:
%     LOS:  PER_LTE_MCS7_350B  -> midpoint ~4.0 dB, slope 0.9
%     NLOS: PER_NR_MCS7_100B   -> midpoint ~6.0 dB, slope 0.7
%
%   Supports scalar or vector inputs. is_nlos must be logical.

if nargin < 3 || isempty(params)
    params = struct();
end

if is_nlos
    midpoint = paramsafe(params, 'pdr_midpoint_nlos', 6.0);
    slope = paramsafe(params, 'pdr_slope_nlos', 0.7);
else
    midpoint = paramsafe(params, 'pdr_midpoint_los', 4.0);
    slope = paramsafe(params, 'pdr_slope_los', 0.9);
end

pdr = 1.0 ./ (1.0 + exp(-slope .* (sinr_dB - midpoint)));
pdr = min(max(pdr, 0.01), 0.999);
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
