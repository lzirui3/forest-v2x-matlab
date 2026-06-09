function config = get_default_step9_v2xseq_config()
%GET_DEFAULT_STEP9_V2XSEQ_CONFIG
% Hybrid mainline config: real V2X-Seq trajectory/message + existing
% RSU/blockage/GNSS templates.

config = get_step9_v2xseq_config_by_scene("10014");
end
