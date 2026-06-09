function write_forest_calibration_report(calib, out_path)
%WRITE_FOREST_CALIBRATION_REPORT Write a traceable calibration report.

if nargin < 2 || strlength(string(out_path)) == 0
    out_path = 'forest_calibration_report.md';
end

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open forest calibration report: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Forest Calibration Report\n\n');
fprintf(fid, 'This report documents how forest-scene parameters are derived from packaged datasets and literature-guided mappings.\n\n');

fprintf(fid, '## Data Statistics\n\n');
fprintf(fid, '- Road length p75: %.2f m\n', calib.road_stats.segment_length_p75_m);
fprintf(fid, '- Road curvature mean: %.4f rad\n', calib.road_stats.curvature_mean);
fprintf(fid, '- Vegetation cover p75: %.4f\n', calib.vegetation_stats.cover_p75);
fprintf(fid, '- Vegetation cover p90: %.4f\n', calib.vegetation_stats.cover_p90);
fprintf(fid, '- Point-cloud z p75: %.4f m\n', calib.pointcloud_stats.z_p75);
fprintf(fid, '- Point-cloud z p90: %.4f m\n', calib.pointcloud_stats.z_p90);

fprintf(fid, '\n## Derived Parameters\n\n');
fprintf(fid, '| Parameter | Value | Derivation |\n');
fprintf(fid, '|---|---:|---|\n');
fprintf(fid, '| link\\_distance\\_scale | %.4f | road length p75 / 60m |\n', calib.link_distance_scale);
fprintf(fid, '| pathloss\\_los\\_exponent | %.4f | 10 × alpha\\_los, alpha\\_los derived from curvature and vegetation density |\n', calib.pathloss_los_exponent);
fprintf(fid, '| pathloss\\_nlos\\_exponent | %.4f | 10 × alpha\\_nlos, alpha\\_nlos > alpha\\_los |\n', calib.pathloss_nlos_exponent);
fprintf(fid, '| nlosv\\_extra\\_loss\\_dB | %.4f | vegetation attenuation severity |\n', calib.nlosv_extra_loss_dB);
fprintf(fid, '| blind\\_link\\_loss\\_scale\\_dB | %.4f | vegetation density norm |\n', calib.blind_link_loss_scale_dB);
fprintf(fid, '| position\\_gnss\\_independent\\_noise\\_std | %.4f | canopy severity from raster + pointcloud |\n', calib.position_gnss_independent_noise_std);
fprintf(fid, '| position\\_gnss\\_multipath\\_noise\\_std | %.4f | canopy severity from raster + pointcloud |\n', calib.position_gnss_multipath_noise_std);
fprintf(fid, '| confidence\\_regime\\_qpos\\_threshold | %.4f | harder canopy => earlier regime activation |\n', calib.confidence_regime_qpos_threshold);
fprintf(fid, '| utility\\_blind\\_relay\\_threshold | %.4f | dense canopy => stronger relay trigger |\n', calib.utility_blind_relay_threshold);

fprintf(fid, '\n## Notes\n\n');
fprintf(fid, '- The pathloss exponents in the simulator use the `10*alpha` convention in dB/decade form, not the raw linear-domain exponent itself.\n');
fprintf(fid, '- Vegetation-induced attenuation is not claimed as a direct electromagnetic fit; it is a traceable data-guided calibration built on raster/pointcloud severity indicators and literature-inspired monotonic mappings.\n');
end
