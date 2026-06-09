function T = list_available_forest_geometry_configs()
%LIST_AVAILABLE_FOREST_GEOMETRY_CONFIGS Scan generated forest geometry templates.

base_dir = fileparts(mfilename('fullpath'));
data_dir = fullfile(base_dir, 'step9_data_templates');
files = dir(fullfile(data_dir, 'forest_geometry_*_trajectory.csv'));

Profile = strings(0, 1);
Vegetation = strings(0, 1);
TemplateTag = strings(0, 1);
TrajectoryFile = strings(0, 1);
Ready = false(0, 1);

for i = 1:numel(files)
    name = string(files(i).name);
    if name == "forest_geometry_demo_trajectory.csv"
        continue;
    end

    tag = extractAfter(name, "forest_geometry_");
    tag = extractBefore(tag, "_trajectory.csv");
    parts = split(tag, "_");
    if numel(parts) ~= 2
        continue;
    end

    profile = string(parts(1));
    vegetation = string(parts(2));

    block_file = fullfile(data_dir, sprintf('forest_geometry_%s_blockage_profile.csv', tag));
    rsu_file = fullfile(data_dir, sprintf('forest_geometry_%s_rsu_layout.csv', tag));
    gnss_file = fullfile(data_dir, sprintf('forest_geometry_%s_gnss_config.csv', tag));
    msg_file = fullfile(data_dir, sprintf('forest_geometry_%s_message_profile.csv', tag));

    Profile(end + 1, 1) = profile; %#ok<AGROW>
    Vegetation(end + 1, 1) = vegetation; %#ok<AGROW>
    TemplateTag(end + 1, 1) = tag; %#ok<AGROW>
    TrajectoryFile(end + 1, 1) = string(fullfile(data_dir, files(i).name)); %#ok<AGROW>
    Ready(end + 1, 1) = isfile(block_file) && isfile(rsu_file) && isfile(gnss_file) && isfile(msg_file); %#ok<AGROW>
end

T = table(Profile, Vegetation, TemplateTag, TrajectoryFile, Ready);
if ~isempty(T)
    T = sortrows(T, {'Profile', 'Vegetation'});
end
end
