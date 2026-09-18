$ErrorActionPreference = 'Stop'
$sdkRoot = $env:CIQ_SDK_HOME
if (-not $sdkRoot) {
    $sdkConfig = Join-Path $env:APPDATA 'Garmin\ConnectIQ\current-sdk.cfg'
    if (-not (Test-Path -LiteralPath $sdkConfig)) { throw 'Set CIQ_SDK_HOME to your Windows Connect IQ SDK.' }
    $sdkRoot = (Get-Content -LiteralPath $sdkConfig -Raw).Trim()
}
if (-not (Test-Path -LiteralPath (Join-Path $sdkRoot 'bin\monkeyc.bat'))) { throw 'Windows Monkey C compiler not found in selected SDK.' }
function Invoke-CiqLogged {
    param([string]$Executable, [string[]]$Arguments, [string]$Log)
    # Windows PowerShell treats native stderr as ErrorRecords. Preserve it and
    # the native status separately; compiler/test failures must never be hidden.
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & $Executable @Arguments 2>&1 | Tee-Object -FilePath $Log | ForEach-Object { Write-Host "$_" }
    $nativeStatus = $LASTEXITCODE
    $ErrorActionPreference = $previousPreference
    Set-Content -LiteralPath ($Log + '.exit-code.txt') -Value $nativeStatus
    return $nativeStatus
}
