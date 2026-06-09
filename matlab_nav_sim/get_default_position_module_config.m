function modules = get_default_position_module_config()
%GET_DEFAULT_POSITION_MODULE_CONFIG Default module switches for Step 9/10 positioning confidence.

modules.use_gnss = true;
modules.use_rsu = true;
modules.use_env = true;
modules.use_traj = true;
modules.name = "Full";
end
