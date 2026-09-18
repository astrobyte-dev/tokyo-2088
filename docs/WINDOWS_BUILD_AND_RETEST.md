# Windows candidate build and hardware retest

The redraw candidate addresses a reproducible source flaw. Physical issue #1 remains open. Nothing was installed on the watch during this investigation. See [executed results](WINDOWS_REDRAW_RESULTS.md).

## Build with the native Windows SDK

Install/select the Windows SDK in Garmin SDK Manager, with the `fenix8solar51mm` device package and Java 11 or later. The wrappers read `%APPDATA%/Garmin/ConnectIQ/current-sdk.cfg`; `CIQ_SDK_HOME` can explicitly override that selection. No SDK or absolute machine paths are committed. This investigation used the already installed SDK 9.1.0 and device API 6.0.0, versus the historical Linux SDK 9.2.0 / device API 6.0.2.

From the checkout in PowerShell:

```powershell
# Explicitly select your private key, outside the checkout and cloud sync.
$env:CIQ_DEVELOPER_KEY = 'C:\your-private-local-directory\developer_key.der'
powershell -NoProfile -File tools/build.ps1 debug
powershell -NoProfile -File tools/build.ps1 test
powershell -NoProfile -File tools/build.ps1 release
powershell -NoProfile -File tools/simulator.ps1 start
powershell -NoProfile -File tools/simulator.ps1 test
powershell -NoProfile -File tools/simulator.ps1 release
```

Builds default to `build/windows/candidate`. Use `-OutputDir build/windows/your-label` for a distinct run. Every build explicitly selects `fenix8solar51mm`. Use File → Kill App before switching programs. Run commands remain attached until the simulator app stops. VS Code tasks have Windows overrides; Linux scripts remain available.

Each build/run records console output and the **native** exit code in adjacent `.log` and `.log.exit-code.txt` files. Native Windows `monkeydo` returned 0 even on assertion failures here. The test wrapper additionally records `test-framework-passed.txt` and returns failure when the framework did not pass, while retaining the original native status. A nonzero native status is never converted to success.

The checked-in resources compile directly. `tools/check-assets.ps1` runs the rewriting asset generator in a new disposable worktree of **committed HEAD**, retained under `build` for diff inspection. It requires Python/Pillow. Do not run `tools/check_assets.py` directly in a checkout whose generated resources must be preserved.

## Reproduce the injected screen-loss fixture

`tests/ResetSurface.mc` overrides two clock accessors to keep time deterministic, draws onto Garmin buffered DCs, then clears the surface outside production code. Each subsequent full update must repeat all the main text paths. The capture apps perform two production updates at identical injected time with an external clear between them. They are simulator fixtures, never installation artifacts.

```powershell
powershell -NoProfile -File tools/build.ps1 capture
powershell -NoProfile -File tools/build.ps1 capture-seconds
powershell -NoProfile -File tools/simulator.ps1 capture
# Kill App, then run capture-seconds for the active-seconds case.
```

Use File → Save Screen Capture to export actual 280 × 280 PNGs. Use Settings → Display Mode → High Power / Always-Active for real simulator power callbacks. The Sleep Mode checkbox is a different setting. Capture-seconds forces seconds on only in its test view; production defaults remain off. Capture apps keep the production UUID for comparison and must stay in the simulator.

To reproduce the baseline, create an isolated checkout of `7244158815f65233be23fc3cd213c609dabceb8d`, copy the test/capture files and Windows scripts/Jungles from this branch, and add only the `currentClock()` / `currentMoment()` accessor seam from `TokyoView`. Retain the original same-minute early return. Baseline and candidate must use the same SDK, key and committed resources. The two new reset tests must fail before removing that branch. Compare exported images with `python tools/compare-redraw-captures.py`; its default input is the checked-in evidence directory.

## Signing options before any physical installation

The original Linux signing key was not available or assumed present on Windows. Investigation binaries use a separate **temporary Windows development key**, stored under Local AppData outside the repository and OneDrive. This is not the project's permanent key. The application UUID and version remain unchanged; identify these builds by path and SHA-256, not version alone.

Preferred owner update: privately transfer the original DER key from the prior machine to a nonsynced local directory, set `CIQ_DEVELOPER_KEY`, rebuild release into a new output directory, and record its new hash. Do not send the key through Git, issues, PRs, chat, or build artifacts. Garmin requires the original key for updates to an existing Store app; its documentation does not establish that a differently signed sideload is a seamless replacement preserving settings.

Alternative: explicitly approve a hardware trial of the temporary-key release after backup. Same-UUID replacement acceptance and settings retention are unverified on this watch. If the watch rejects it, stop and preserve the evidence; do not delete settings, uninstall the existing face, or change the UUID to work around it without a separate decision. A separately identified test app would require an intentional UUID change and separate settings, which this candidate does not implement.

Official references: [Windows command-line setup and key generation](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/), [Garmin signing security](https://developer.garmin.com/connect-iq/core-topics/security/).

## Installation and rollback — only after explicit approval

1. Select a built-in face first. Connect the watch with a data cable in MTP mode. Discover it in Windows File Explorer → This PC and inspect its actual Internal Storage → GARMIN → Apps folder. MTP is not assumed to have a drive letter. Confirm the model; do not infer firmware from SDK metadata.
2. Before replacement, copy relevant `GARMIN/Apps/LOGS` error evidence to a local ignored folder. MTP may report zero-byte sizes while a copied file contains data. Read the copy to verify it. Preserve the installed TOKYO PRG and relevant settings locally, without deleting or modifying watch settings/logs. Identify the app carefully if Garmin renamed its file.
3. The historical installed release is **24,188 bytes**, SHA-256 `8a3469f4ab629d809d22b4ba61fd060f329919b1d7013f0b679ef0ea2f29ac64`. It is absent from Git and was not available in this fresh Windows checkout. Obtain/verify the preserved original from the previous machine or a verified watch readback before promising binary rollback. A newly compiled baseline is not that artifact.
4. After approving the exact signed release and hash, copy only that release PRG to the verified Apps directory. Do not copy debug, native-test or capture programs, or simulator settings JSON. Do not delete anything else. Read the transferred PRG back locally and verify `Get-FileHash -Algorithm SHA256` matches. Disconnect normally and select TOKYO 2088.
5. Immediate fallback: select the built-in/previous face. Binary rollback requires the verified original release and a separate approved replacement operation. Do not reset the watch, remove settings/logs, change firmware or delete the Apps folder.

## Physical observations to collect

Start with seconds off and record firmware, installed PRG hash, settings, time of installation and phone connection. Raise/lower the wrist repeatedly, return from glances and notifications, switch away/back to the face, and leave it idle through multiple minute boundaries and overnight. Repeat with active seconds on if settings are available. The sideload settings-editor limitation remains; this change adds no on-watch editor.

For any blank event, record the exact time, preceding action, whether an IQ icon appears, duration, whether time is still advancing after recovery, and **how it recovers**: by itself, next minute, wrist gesture, button, returning to the face, or another action. Note whether it followed raising the wrist, returning from glances/notifications, or idle use. Photograph the event if practical and collect fresh relevant error logs read-only afterward. These are unknown observations to gather, not established triggers. Keep source correction, simulator regression success and physical resolution separate. Battery comparisons need comparable physical runs with matching settings.
