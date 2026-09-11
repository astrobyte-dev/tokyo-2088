$ErrorActionPreference = 'Stop'
Push-Location "$PSScriptRoot/.."
try {
    $checkRoot = Join-Path (Get-Location) ('build/assets-check-' + [Guid]::NewGuid().ToString('N'))
    # The generator rewrites fonts/previews. Keep all changes in a disposable
    # checkout of committed HEAD, and retain it so the resulting diff is reviewable.
    & git worktree add --detach $checkRoot HEAD
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Push-Location $checkRoot
    try {
        & python tools/check_assets.py
        $status = $LASTEXITCODE
        & git diff --stat
        Write-Host "Asset-check checkout retained for inspection: $checkRoot"
    } finally { Pop-Location }
} finally { Pop-Location }
exit $status
