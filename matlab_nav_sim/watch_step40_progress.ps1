param(
    [string]$BaseDir = 'D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim',
    [int]$IntervalSec = 120,
    [string]$Prefix = 'step40_proposed_method_vtc_50seed',
    [string]$LogPath = ''
)

if ([string]::IsNullOrWhiteSpace($LogPath)) {
    $LogPath = Join-Path $BaseDir 'step40_progress_watch.log'
}

$Scenes = @('10014', '10006', '10011', '10019', '10017')
$Configs = @('Default', 'ForestGeometry')
$ExpectedSeeds = 50
$MethodsPerSeed = 5

function Get-CheckpointStatus {
    param(
        [string]$BaseDir,
        [string]$Prefix,
        [string[]]$Scenes,
        [string[]]$Configs,
        [int]$ExpectedSeeds,
        [int]$MethodsPerSeed
    )

    $items = @()
    foreach ($scene in $Scenes) {
        foreach ($cfg in $Configs) {
            $path = Join-Path $BaseDir ($Prefix + '_' + $scene + '_' + $cfg + '_raw.csv')
            if (Test-Path -LiteralPath $path) {
                try {
                    $rows = (Import-Csv -LiteralPath $path).Count
                } catch {
                    $rows = 0
                }
                $seeds = [math]::Floor($rows / $MethodsPerSeed)
                $mtime = (Get-Item -LiteralPath $path).LastWriteTime
            } else {
                $rows = 0
                $seeds = 0
                $mtime = $null
            }

            $items += [pscustomobject]@{
                Scene = $scene
                Config = $cfg
                Seeds = [int]$seeds
                Expected = $ExpectedSeeds
                Rows = [int]$rows
                Updated = $mtime
                Done = ($seeds -ge $ExpectedSeeds)
            }
        }
    }
    return $items
}

function Write-ProgressSnapshot {
    param(
        [string]$BaseDir,
        [string]$Prefix,
        [string]$LogPath,
        [string[]]$Scenes,
        [string[]]$Configs,
        [int]$ExpectedSeeds,
        [int]$MethodsPerSeed
    )

    $now = Get-Date
    $status = Get-CheckpointStatus -BaseDir $BaseDir -Prefix $Prefix -Scenes $Scenes -Configs $Configs -ExpectedSeeds $ExpectedSeeds -MethodsPerSeed $MethodsPerSeed
    $totalSeeds = ($status | Measure-Object -Property Seeds -Sum).Sum
    $targetSeeds = $Scenes.Count * $Configs.Count * $ExpectedSeeds
    $pct = if ($targetSeeds -gt 0) { 100.0 * $totalSeeds / $targetSeeds } else { 0.0 }
    $matlab = Get-Process -Name MATLAB -ErrorAction SilentlyContinue

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add(('[' + $now.ToString('yyyy-MM-dd HH:mm:ss') + '] Step40 progress: ' + $totalSeeds + '/' + $targetSeeds + ' seeds (' + ('{0:N1}' -f $pct) + '%)'))
    if ($matlab) {
        $procText = ($matlab | ForEach-Object { 'PID=' + $_.Id + ',CPU=' + ('{0:N1}' -f $_.CPU) + ',Start=' + $_.StartTime }) -join '; '
        $lines.Add('MATLAB: running; ' + $procText)
    } else {
        $lines.Add('MATLAB: not running')
    }

    foreach ($row in $status) {
        $updated = if ($row.Updated) { $row.Updated.ToString('yyyy-MM-dd HH:mm:ss') } else { 'missing' }
        $mark = if ($row.Done) { 'DONE' } else { 'RUN ' }
        $lines.Add(('{0} {1} {2}: {3}/{4} seeds, rows={5}, updated={6}' -f $mark, $row.Scene, $row.Config, $row.Seeds, $row.Expected, $row.Rows, $updated))
    }
    $lines.Add('')

    $lines | Add-Content -LiteralPath $LogPath -Encoding UTF8
    $lines | ForEach-Object { Write-Host $_ }

    return ($totalSeeds -ge $targetSeeds)
}

while ($true) {
    $done = Write-ProgressSnapshot -BaseDir $BaseDir -Prefix $Prefix -LogPath $LogPath -Scenes $Scenes -Configs $Configs -ExpectedSeeds $ExpectedSeeds -MethodsPerSeed $MethodsPerSeed
    if ($done) {
        break
    }
    Start-Sleep -Seconds $IntervalSec
}
