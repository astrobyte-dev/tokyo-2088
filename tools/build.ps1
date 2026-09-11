param(
    [ValidateSet('debug','test','release','capture','capture-seconds')][string]$Mode = 'release',
    [string]$OutputDir = 'build/windows/candidate',
    [string]$DeveloperKey = $env:CIQ_DEVELOPER_KEY,
    [switch]$Beta
)
. "$PSScriptRoot/toolchain.ps1"
if (-not $DeveloperKey -or -not (Test-Path -LiteralPath $DeveloperKey -PathType Leaf)) {
    throw 'Set CIQ_DEVELOPER_KEY or -DeveloperKey to an explicitly chosen private DER key outside this repository.'
}
$DeveloperKey = (Resolve-Path -LiteralPath $DeveloperKey).Path
if ($Beta) {
    if ($Mode -notin @('test','release')) { throw 'Beta builds support only native tests and production release.' }
    if (-not $PSBoundParameters.ContainsKey('OutputDir')) { $OutputDir='build/windows/beta/validation' }
    $betaRoot=[IO.Path]::GetFullPath((Join-Path "$PSScriptRoot/.." 'build/windows/beta'))
    $betaOutput=[IO.Path]::GetFullPath((Join-Path "$PSScriptRoot/.." $OutputDir))
    if (-not $betaOutput.StartsWith($betaRoot+'\',[StringComparison]::OrdinalIgnoreCase)) { throw 'Beta builds must stay in a separate build/windows/beta subfolder.' }
}
Push-Location "$PSScriptRoot/.."
try {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    $output = Join-Path $OutputDir "TOKYO2088-fenix8solar51mm-$Mode.prg"
    $jungle = 'monkey.jungle'
    if ($Mode -eq 'test') { $jungle = 'tests.jungle' }
    if ($Mode -eq 'capture') { $jungle = 'capture.jungle' }
    if ($Mode -eq 'capture-seconds') { $jungle = 'capture-seconds.jungle' }
    if ($Beta) {
        $jungle = if ($Mode -eq 'test') { 'beta-tests.jungle' } else { 'beta.jungle' }
        $output = Join-Path $OutputDir "TOKYO2088-BETA-fenix8solar51mm-$Mode.prg"
    }
    $compilerArgs = @('-f',$jungle,'-d','fenix8solar51mm','-y',$DeveloperKey,'-w','-o',$output)
    if ($Mode -eq 'test') { $compilerArgs += '-t' }
    if ($Mode -eq 'release') { $compilerArgs += '-r' }
    $status = Invoke-CiqLogged (Join-Path $sdkRoot 'bin\monkeyc.bat') $compilerArgs (Join-Path $OutputDir "$Mode-build.log")
} finally { Pop-Location }
exit $status
