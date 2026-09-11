param(
    [Parameter(Mandatory=$true)][string]$DeveloperKey,
    [Parameter(Mandatory=$true)][ValidateSet('TemporaryDevelopment','OwnerApprovedPermanent')][string]$SigningProvenance,
    [string]$OutputDir = ('build/windows/store-prep/export-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
)
. "$PSScriptRoot/toolchain.ps1"
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$keyPath = (Resolve-Path -LiteralPath $DeveloperKey -ErrorAction Stop).Path
if (-not (Test-Path -LiteralPath $keyPath -PathType Leaf)) { throw 'An existing private DER key is required.' }
if ($keyPath.StartsWith($projectRoot + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'Keep signing keys outside the repository.' }
Push-Location $projectRoot
try {
    $outputRoot = [IO.Path]::GetFullPath((Join-Path $projectRoot $OutputDir))
    $allowedRoot = Join-Path $projectRoot 'build\windows\store-prep'
    if (-not $outputRoot.StartsWith($allowedRoot + '\',[StringComparison]::OrdinalIgnoreCase)) {
        throw 'Export into a new subfolder of build/windows/store-prep; never overwrite the hardware candidate.'
    }
    if (Test-Path -LiteralPath $outputRoot) { throw 'Output folder already exists. Choose a fresh export folder.' }
    [xml]$manifest = Get-Content -LiteralPath 'manifest.xml'
    $products = @($manifest.manifest.application.products.product | ForEach-Object id)
    if ($products.Count -ne 1 -or $products[0] -ne 'fenix8solar51mm') { throw 'Only the qualified launch target may be exported by this workflow.' }
    $jungle = Get-Content -LiteralPath 'monkey.jungle' -Raw
    foreach ($line in @('base.sourcePath = source','base.resourcePath = resources','base.excludeAnnotations = test;preview;fixture;capture')) {
        if (-not ($jungle -split '\r?\n' | Where-Object { $_.Trim() -eq $line })) { throw "Production jungle guard failed: $line" }
    }
    New-Item -ItemType Directory -Path $outputRoot | Out-Null
    $iq = Join-Path $outputRoot 'TOKYO2088-store-prep.iq'
    # Native package export builds only manifest products. No -t, capture jungle,
    # or device override: production jungle + release mode + package mode.
    $status = Invoke-CiqLogged (Join-Path $sdkRoot 'bin\monkeyc.bat') @('-f','monkey.jungle','-e','-r','-w','-y',$keyPath,'-o',$iq) (Join-Path $outputRoot 'export.log')
    if ($status -ne 0) { exit $status }
    if (-not (Test-Path -LiteralPath $iq -PathType Leaf)) { throw 'Compiler returned success without the IQ package.' }
    $notices = Join-Path $outputRoot 'notices'
    New-Item -ItemType Directory -Path $notices | Out-Null
    Copy-Item -LiteralPath 'THIRD_PARTY_NOTICES.md','assets-src/DEJAVU-LICENSE.txt','assets-src/DEJAVU-EMBEDDED-LICENSE.txt','assets-src/NOTO-LICENSE.txt' -Destination $notices
    $checkStatus = Invoke-CiqLogged 'python' @('tools/check-store-prep.py','--iq',$iq,'--output',(Join-Path $outputRoot 'package-check.json')) (Join-Path $outputRoot 'package-check.log')
    if ($checkStatus -ne 0) { exit $checkStatus }
    $metadata = [ordered]@{
        createdAt = (Get-Date).ToString('o')
        status = 'LOCAL_REVIEW_PACKAGE_NOT_UPLOADED'
        sourceCommit = ((git rev-parse HEAD) -join '').Trim()
        workingTreeDirty = [bool](git status --porcelain --untracked-files=normal)
        program = [IO.Path]::GetFileName($iq)
        bytes = (Get-Item -LiteralPath $iq).Length
        sha256 = (Get-FileHash -LiteralPath $iq -Algorithm SHA256).Hash.ToLowerInvariant()
        signingProvenance = $SigningProvenance
        sdkPath = $sdkRoot
        products = $products
        appUuid = $manifest.manifest.application.id
        version = $manifest.manifest.application.version
        uploadAuthorized = $false
        noticeDelivery = 'Sidecars retained. Final Store notice delivery and owner licensing decisions remain a submission gate.'
    }
    $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $outputRoot 'EXPORT_INFO.private.json') -Encoding UTF8
    Write-Host "Local review package: $iq"
    Write-Host "SHA-256: $($metadata.sha256)"
    Write-Host "Signing provenance: $SigningProvenance. No upload or watch installation performed."
} finally { Pop-Location }
