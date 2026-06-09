function scenes = get_paper_scene_matrix()
%GET_PAPER_SCENE_MATRIX Formal paper scene matrix for generalization study.

scenes = struct('scene_id', {}, 'scene_role', {}, 'geometry_type', {}, ...
    'density_class', {}, 'vegetation_class', {}, 'is_primary_set', {}, 'description', {});

scenes(1).scene_id = "10014";
scenes(1).scene_role = "Primary";
scenes(1).geometry_type = "CurvedBlind";
scenes(1).density_class = "Medium";
scenes(1).vegetation_class = "Dense";
scenes(1).is_primary_set = true;
scenes(1).description = "Primary blind-zone scene with strong occlusion sensitivity.";

scenes(2).scene_id = "10006";
scenes(2).scene_role = "Reference";
scenes(2).geometry_type = "Mixed";
scenes(2).density_class = "Medium";
scenes(2).vegetation_class = "Mixed";
scenes(2).is_primary_set = true;
scenes(2).description = "Reference mixed scene used to compare against the original mainline.";

scenes(3).scene_id = "10011";
scenes(3).scene_role = "Boundary";
scenes(3).geometry_type = "Open";
scenes(3).density_class = "Low";
scenes(3).vegetation_class = "Sparse";
scenes(3).is_primary_set = false;
scenes(3).description = "Relatively easy/open scene used to expose the method boundary.";

scenes(4).scene_id = "10019";
scenes(4).scene_role = "DenseBlind";
scenes(4).geometry_type = "ShortRangeOccluded";
scenes(4).density_class = "High";
scenes(4).vegetation_class = "Dense";
scenes(4).is_primary_set = false;
scenes(4).description = "Dense short-range scene with strong emergency dominance and occlusion.";

scenes(5).scene_id = "10017";
scenes(5).scene_role = "LongRange";
scenes(5).geometry_type = "LongMixed";
scenes(5).density_class = "Medium";
scenes(5).vegetation_class = "Mixed";
scenes(5).is_primary_set = true;
scenes(5).description = "Long-range mixed geometry scene for additional topology diversity.";
end
