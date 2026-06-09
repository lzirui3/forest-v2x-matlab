function summary = prepare_step9_forest_geometry_plus_inputs(profile_name, vegetation_level, overrides)
%PREPARE_STEP9_FOREST_GEOMETRY_PLUS_INPUTS Generate realism-augmented forest templates.

if nargin < 1 || strlength(string(profile_name)) == 0
    profile_name = "Blind";
end
if nargin < 2 || strlength(string(vegetation_level)) == 0
    vegetation_level = "Medium";
end
if nargin < 3 || isempty(overrides)
    overrides = struct();
end

opts = local_get_default_plus_options();
fn = fieldnames(overrides);
for i = 1:numel(fn)
    opts.(fn{i}) = overrides.(fn{i});
end

summary = prepare_step9_forest_geometry_inputs(profile_name, vegetation_level, opts, "plus");
end

function opts = local_get_default_plus_options()
base = get_default_step9_params();
opts = struct( ...
    'use_veg_attenuation', true, ...
    'veg_attenuation_scale', base.veg_attenuation_scale, ...
    'veg_attenuation_base_coeff', base.veg_attenuation_base_coeff, ...
    'veg_attenuation_score_coeff', base.veg_attenuation_score_coeff, ...
    'veg_attenuation_length_coeff', base.veg_attenuation_length_coeff, ...
    'veg_attenuation_shadowing_coeff', base.veg_attenuation_shadowing_coeff, ...
    'veg_attenuation_interference_coeff', base.veg_attenuation_interference_coeff);
end
