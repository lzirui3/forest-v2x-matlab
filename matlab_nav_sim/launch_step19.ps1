[Console]::OutputEncoding=[System.Text.Encoding]::UTF8
 = 'D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim\run_step19_per_lookup_validation_final.log'
if (Test-Path ) { Remove-Item -LiteralPath  -Force }
& 'D:\MATLAB\bin\matlab.exe' -batch "restoredefaultpath; rehash toolboxcache; cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim'); main_step19_per_lookup_validation;" *> 
