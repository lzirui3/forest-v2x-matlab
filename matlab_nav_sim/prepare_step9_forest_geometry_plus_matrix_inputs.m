function summaries = prepare_step9_forest_geometry_plus_matrix_inputs()
%PREPARE_STEP9_FOREST_GEOMETRY_PLUS_MATRIX_INPUTS Generate 3x3 realism-augmented templates.

profiles = ["Straight", "Curved", "Blind"];
vegetation_levels = ["Sparse", "Medium", "Dense"];
summaries = [];

for i = 1:numel(profiles)
    for j = 1:numel(vegetation_levels)
        one_summary = prepare_step9_forest_geometry_plus_inputs(profiles(i), vegetation_levels(j));
        if isempty(summaries)
            summaries = one_summary;
        else
            summaries(end + 1, 1) = one_summary; %#ok<AGROW>
        end
    end
end

disp(struct2table(summaries));
end
