function cases = get_default_step10_ablation_cases()
%GET_DEFAULT_STEP10_ABLATION_CASES Default ablation cases for positioning confidence modules.

base = get_default_position_module_config();

cases(1).name = "Full";
cases(1).modules = base;

cases(2).name = "No-GNSS";
cases(2).modules = base;
cases(2).modules.use_gnss = false;
cases(2).modules.name = "No-GNSS";

cases(3).name = "No-RSU";
cases(3).modules = base;
cases(3).modules.use_rsu = false;
cases(3).modules.name = "No-RSU";

cases(4).name = "No-Env";
cases(4).modules = base;
cases(4).modules.use_env = false;
cases(4).modules.name = "No-Env";

cases(5).name = "No-Traj";
cases(5).modules = base;
cases(5).modules.use_traj = false;
cases(5).modules.name = "No-Traj";
end
