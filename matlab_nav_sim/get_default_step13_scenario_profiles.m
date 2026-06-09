function profiles = get_default_step13_scenario_profiles()
%GET_DEFAULT_STEP13_SCENARIO_PROFILES Default scenario expansion dimensions.

profiles.gnss_levels = ["Weak", "Medium", "Strong"];
profiles.rsu_levels = ["Sparse", "Medium", "Dense"];
profiles.load_levels = ["Low", "Medium", "High"];
profiles.num_seeds = 20;
end
