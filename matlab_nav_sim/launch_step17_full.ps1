[Console]::OutputEncoding=[System.Text.Encoding]::UTF8
 = 'full'
 = 'D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim\run_step17_full.log'
if (Test-Path ) { Remove-Item -LiteralPath  -Force }
& 'D:\MATLAB\bin\matlab.exe' -batch "restoredefaultpath; rehash toolboxcache; cd('D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim'); main_step17_paper_statistics;" *> 
