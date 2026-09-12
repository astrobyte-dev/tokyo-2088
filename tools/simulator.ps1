param(
    [ValidateSet('start','debug','test','release','capture','capture-seconds')][string]$Mode = 'start',
    [string]$OutputDir = 'build/windows/candidate'
)
. "$PSScriptRoot/toolchain.ps1"
if ($Mode -eq 'start') {
    # Interactive simulator is needed for captures and runtime inspection.
    Start-Process -FilePath (Join-Path $sdkRoot 'bin\simulator.exe') -WorkingDirectory (Join-Path $sdkRoot 'bin')
    exit 0
}
Push-Location "$PSScriptRoot/.."
try {
    $program = Join-Path $OutputDir "TOKYO2088-fenix8solar51mm-$Mode.prg"
    if (-not (Test-Path -LiteralPath $program)) { throw "Build $Mode first: $program" }
    $runArgs = @($program,'fenix8solar51mm')
    if ($Mode -eq 'test') { $runArgs += '/t' }
    else {
        $settingsFile = [IO.Path]::ChangeExtension($program,$null).TrimEnd('.') + '-settings.json'
        if (Test-Path -LiteralPath $settingsFile) {
            $runArgs += @('/a',$settingsFile,('GARMIN/Settings/' + [IO.Path]::GetFileName($settingsFile)))
        }
    }
    $status = Invoke-CiqLogged (Join-Path $sdkRoot 'bin\monkeydo.bat') $runArgs (Join-Path $OutputDir "$Mode-run.log")
    if ($Mode -eq 'test') {
        $testOutput = Get-Content -LiteralPath (Join-Path $OutputDir "$Mode-run.log") -Raw
        $frameworkPassed = $testOutput -match 'PASSED \(passed=\d+, failed=0, errors=0\)' -and $testOutput -notmatch 'FAILED \('
        Set-Content -LiteralPath (Join-Path $OutputDir 'test-framework-passed.txt') -Value $frameworkPassed
        if ($status -eq 0 -and -not $frameworkPassed) { $status = 1 }
    }
} finally { Pop-Location }
exit $status
