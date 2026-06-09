function profiles = get_default_step9_weight_calibration_profiles()
%GET_DEFAULT_STEP9_WEIGHT_CALIBRATION_PROFILES Representative scenario subset for calibration.

profiles.entries = {
    struct('gnss', "Medium", 'rsu', "Medium", 'load', "Medium"), ...
    struct('gnss', "Strong", 'rsu', "Sparse", 'load', "High"), ...
    struct('gnss', "Strong", 'rsu', "Medium", 'load', "Medium"), ...
    struct('gnss', "Weak", 'rsu', "Sparse", 'load', "Low")
    };

profiles.seed_list = 1:4;
end
