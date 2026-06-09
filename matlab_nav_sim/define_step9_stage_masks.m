function stages = define_step9_stage_masks(t)
%DEFINE_STEP9_STAGE_MASKS Define stage masks for Step 9 scheduling scenario.

stages(1).name = 'Normal';
stages(1).mask = (t < 25);

stages(2).name = 'Coop_1';
stages(2).mask = (t >= 25) & (t < 55);

stages(3).name = 'LinkDeg_Emerg';
stages(3).mask = (t >= 55) & (t < 68);

stages(4).name = 'PosDeg_Emerg';
stages(4).mask = (t >= 68) & (t < 90);

stages(5).name = 'Recovery';
stages(5).mask = (t >= 90);

stages(6).name = 'Full';
stages(6).mask = true(size(t));
end

