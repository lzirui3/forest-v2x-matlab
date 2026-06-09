function scenes = get_heldout_scene_matrix()
%GET_HELDOUT_SCENE_MATRIX Frozen-parameter held-out validation scenes.
% These scenes are intentionally excluded from the Step40 tuning/evidence
% matrix to test whether the frozen Risk-constrained-v6 setting generalizes.

scenes = struct('scene_id', {}, 'scene_role', {}, 'geometry_type', {}, ...
    'density_class', {}, 'vegetation_class', {}, 'is_primary_set', {}, ...
    'description', {});

scenes(1).scene_id = "10013";
scenes(1).scene_role = "HeldOutHighNLOS";
scenes(1).geometry_type = "ShortHighNLOS";
scenes(1).density_class = "High";
scenes(1).vegetation_class = "Dense";
scenes(1).is_primary_set = false;
scenes(1).description = "Held-out high-NLOS short-range V2X-Seq scene.";

scenes(2).scene_id = "10007";
scenes(2).scene_role = "HeldOutLongMixed";
scenes(2).geometry_type = "LongMixed";
scenes(2).density_class = "Medium";
scenes(2).vegetation_class = "Mixed";
scenes(2).is_primary_set = false;
scenes(2).description = "Held-out long-range mixed V2X-Seq scene.";

scenes(3).scene_id = "10015";
scenes(3).scene_role = "HeldOutBoundary";
scenes(3).geometry_type = "LongLowNLOS";
scenes(3).density_class = "Low";
scenes(3).vegetation_class = "Sparse";
scenes(3).is_primary_set = false;
scenes(3).description = "Held-out low-NLOS long-range boundary scene.";
end
