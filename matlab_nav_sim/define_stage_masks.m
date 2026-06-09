function stages = define_stage_masks(t)
%DEFINE_STAGE_MASKS Define stage masks for GNSS normal/degraded/outage/recovery periods.

stages(1).name = 'Normal_1';
stages(1).mask = (t < 20);

stages(2).name = 'Degraded';
stages(2).mask = (t >= 20) & (t < 35);

stages(3).name = 'Outage';
stages(3).mask = (t >= 35) & (t < 45);

stages(4).name = 'Recovery';
stages(4).mask = (t >= 45);

stages(5).name = 'Full';
stages(5).mask = true(size(t));
