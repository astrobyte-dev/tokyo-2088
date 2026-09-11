param(
    [ValidateSet('debug','test','release','capture','capture-seconds')][string]$Mode = 'release',
    [string]$OutputDir = 'build/windows/candidate',
    [string]$DeveloperKey = $env:CIQ_DEVELOPER_KEY
)
. "$PSScriptRoot/toolchain.ps1"
if (-not $DeveloperKey -or -not (Test-Path -LiteralPath $DeveloperKey -PathType Leaf)) {
    throw 'Set CIQ_DEVELOPER_KEY or -DeveloperKey to an explicitly chosen private DER key outside this repository.'
}
$DeveloperKey = (Resolve-Path -LiteralPath $DeveloperKey).Path
Push-Location "$PSScriptRoot/.."
try {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    $output = Join-Path $OutputDir "TOKYO2088-fenix8solar51mm-$Mode.prg"
    $jungle = 'monkey.jungle'
    if ($Mode -eq 'test') { $jungle = 'tests.jungle' }
    if ($Mode -eq 'capture') { $jungle = 'capture.jungle' }
    if ($Mode -eq 'capture-seconds') { $jungle = 'capture-seconds.jungle' }
    $compilerArgs = @('-f',$jungle,'-d','fenix8solar51mm','-y',$DeveloperKey,'-w','-o',$output)
    if ($Mode -eq 'test') { $compilerArgs += '-t' }
    if ($Mode -eq 'release') { $compilerArgs += '-r' }
    $status = Invoke-CiqLogged (Join-Path $sdkRoot 'bin\monkeyc.bat') $compilerArgs (Join-Path $OutputDir "$Mode-build.log")
} finally { Pop-Location }
exit $status
