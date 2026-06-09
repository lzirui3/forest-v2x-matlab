$ErrorActionPreference = 'Stop'

$Base = 'D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim'
$LauncherLog = Join-Path $Base 'step45_heldout_frozen_validation_50seed_launcher.log'
$StdoutLog = Join-Path $Base 'step45_heldout_frozen_validation_50seed_run_stdout.log'
$StderrLog = Join-Path $Base 'step45_heldout_frozen_validation_50seed_run_stderr.log'

function Write-LaunchLog {
    param([string]$Message)
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -LiteralPath $LauncherLog -Value "[$stamp] $Message"
}

Write-LaunchLog 'Step45 launcher started. Waiting for existing Step42 MATLAB process to finish.'

while ($true) {
    $step42 = Get-CimInstance Win32_Process -Filter "name like '%MATLAB%'" |
        Where-Object { $_.CommandLine -match 'main_step42_core_parameter_sensitivity' }

    if (-not $step42) {
        break
    }

    $ids = ($step42 | ForEach-Object { $_.ProcessId }) -join ','
    Write-LaunchLog "Step42 still running. MATLAB PID(s): $ids"
    Start-Sleep -Seconds 60
}

Write-LaunchLog 'No Step42 MATLAB process detected. Starting Step45 50-seed held-out validation.'

$env:STEP45_NUM_SEEDS = '50'
Remove-Item -LiteralPath $StdoutLog, $StderrLog -ErrorAction SilentlyContinue

$process = Start-Process -FilePath 'matlab' `
    -ArgumentList @('-batch', 'main_step45_heldout_frozen_validation') `
    -WorkingDirectory $Base `
    -RedirectStandardOutput $StdoutLog `
    -RedirectStandardError $StderrLog `
    -PassThru `
    -WindowStyle Hidden

Write-LaunchLog "Step45 MATLAB started. PID=$($process.Id)"
