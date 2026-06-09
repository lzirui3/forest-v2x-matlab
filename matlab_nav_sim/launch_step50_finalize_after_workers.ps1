$ErrorActionPreference = 'Stop'

$Base = 'D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim'
$Prefix = 'step50_per_lookup_heldout_validation_50seed'
$LauncherLog = Join-Path $Base 'step50_finalize_after_workers_launcher.log'
$StdoutLog = Join-Path $Base 'step50_finalize_after_workers_stdout.log'
$StderrLog = Join-Path $Base 'step50_finalize_after_workers_stderr.log'
$Cases = @(
    '10013_Default',
    '10013_ForestGeometry',
    '10007_Default',
    '10007_ForestGeometry',
    '10015_Default',
    '10015_ForestGeometry'
)

function Write-LaunchLog {
    param([string]$Message)
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -LiteralPath $LauncherLog -Value "[$stamp] $Message"
}

function Get-CaseSeedCount {
    param([string]$CaseName)
    $rawPath = Join-Path $Base "${Prefix}_${CaseName}_raw.csv"
    $stagePath = Join-Path $Base "${Prefix}_${CaseName}_stage_raw.csv"
    if (-not (Test-Path -LiteralPath $rawPath) -or -not (Test-Path -LiteralPath $stagePath)) {
        return [pscustomobject]@{ RawSeeds = 0; StageSeeds = 0 }
    }

    $raw = Import-Csv -LiteralPath $rawPath
    $stage = Import-Csv -LiteralPath $stagePath
    return [pscustomobject]@{
        RawSeeds = ($raw | Select-Object -ExpandProperty Seed -Unique).Count
        StageSeeds = ($stage | Select-Object -ExpandProperty Seed -Unique).Count
    }
}

function Test-AllCasesComplete {
    foreach ($case in $Cases) {
        $counts = Get-CaseSeedCount -CaseName $case
        if ($counts.RawSeeds -lt 50 -or $counts.StageSeeds -lt 50) {
            return $false
        }
    }
    return $true
}

Write-LaunchLog 'Watcher started. Waiting for all Step50 case workers to reach 50 raw/stage seeds.'

while (-not (Test-AllCasesComplete)) {
    $parts = foreach ($case in $Cases) {
        $counts = Get-CaseSeedCount -CaseName $case
        "${case}:raw=$($counts.RawSeeds),stage=$($counts.StageSeeds)"
    }
    Write-LaunchLog ('Progress ' + ($parts -join '; '))
    Start-Sleep -Seconds 120
}

Write-LaunchLog 'All Step50 case files complete. Running final MATLAB post-processing.'
Remove-Item -LiteralPath $StdoutLog, $StderrLog -ErrorAction SilentlyContinue

$matlabCmd = "main_step50_per_lookup_heldout_finalize; main_step51_per_lookup_applicability_evidence; main_step53_vtc_final_review_ready_report"
$process = Start-Process -FilePath 'D:\MATLAB\bin\matlab.exe' `
    -ArgumentList @('-batch', $matlabCmd) `
    -WorkingDirectory $Base `
    -RedirectStandardOutput $StdoutLog `
    -RedirectStandardError $StderrLog `
    -PassThru `
    -WindowStyle Hidden

Write-LaunchLog "Finalizer MATLAB started. PID=$($process.Id)"
$process.WaitForExit()
Write-LaunchLog "Finalizer MATLAB exited with code $($process.ExitCode)"

if ($process.ExitCode -ne 0) {
    throw "Step50 finalizer failed with exit code $($process.ExitCode)"
}

Write-LaunchLog 'Step50/51/53 final evidence chain completed.'
