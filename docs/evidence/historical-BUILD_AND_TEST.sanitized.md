> Historical record, superseded by current TEST_RESULTS.md and BLACK_SCREEN_INVESTIGATION.md. Sanitized for review.

# Build, simulator, settings and installation

## Continuation verification — 11 September 2026, 11:17 AEST

The explicit target build was retried after the owner reported installation. In the local Linux account, `current-sdk.cfg` and `Devices/fenix8solar51mm` are still absent. A filesystem search found only the two SDK documentation directories named `fenix8solar51mm`. The Manager itself still presents its first-time Login screen. [Fresh compiler error](primary-build-recheck.log).

A second launcher issue was discovered: VS Code Snap exports GTK/GIO plug-in paths that made the Manager's WebKit network helper fail with `libpthread.so.0: undefined symbol: __libc_pthread_init, version GLIBC_PRIVATE`. `tools/sdk-manager.sh` now clears those process-local plug-in overrides; the sign-in form was then verified to load successfully. `tools/simulator.sh` uses the same clean environment, and both build/run scripts now share `tools/toolchain.sh` so an active SDK selected by the Manager is respected consistently.

Open the repaired Manager with `./tools/sdk-manager.sh`. If installation was completed elsewhere, supply that machine/path instead of reinstalling blindly. The application source and design have not been replaced.

## Previous blocker

Garmin's SDK Manager requires a developer-account login to download device packages. The Manager was opened on the user's desktop, but login/package installation has not completed. The official SDK compiler and simulator executable are installed. `monkeyc -d fenix8solar51mm` currently fails with:

```
ERROR: Invalid device id specified: 'fenix8solar51mm'.
```

This means the device package is missing; it does **not** mean the supplied product ID is wrong. Do not select the 454px AMOLED package as a workaround. No primary release `.prg` exists in this handoff. Generic syntax-check binaries under `build/` are not for sideloading.

## Toolchain actually installed

- Ubuntu 24.04 environment; Linux `6.17.0-35-generic`, x86_64.
- OpenJDK runtime 17.0.20, installed through Ubuntu apt.
- Garmin Monkey C VS Code extension 1.1.3, already present.
- Garmin SDK **9.2.0**, official archive `connectiq-sdk-lin-9.2.0-2026-06-09-92a1605b2.zip`.
- SDK location on this machine: `~/.local/share/garmin-toolchain/sdk-9.2.0`.
- Official SDK Manager: `~/.local/share/garmin-toolchain/manager/bin/sdkmanager`.
- Pillow 10.2.0 and fontTools 4.46.0 for asset generation/subsetting.
- Xvfb for isolated simulator UI checks. Simulator process launched on display `:99`; this is only a launch check, not face execution.

Garmin's website displayed SDK 9.2.0 and an August 25 page update. Its downloadable SDK JSON/archive identified the release as June 9, 2026. The archive's `bin/version.txt` and compiler report 9.2.0. This discrepancy is recorded rather than substituting a guessed newer binary.

### Linux compatibility repair

Garmin's Manager and simulator require WebKitGTK **4.0**; Ubuntu 24.04 provides 4.1. A direct alias to 4.1 failed due to incompatible libsoup2/libsoup3 use and is not used by the launch scripts. Actual Ubuntu 22.04 libraries were extracted locally:

- `libwebkit2gtk-4.0-37` / `libjavascriptcoregtk-4.0-18` 2.50.4
- `libicu70` 70.1 and `libwoff1` 1.0.2
- Directory: `~/.local/share/garmin-toolchain/compat-jammy/usr/lib/x86_64-linux-gnu`.

The missing WebKit helper directory was linked at `/usr/lib/x86_64-linux-gnu/webkit2gtk-4.0` to that extracted directory's `webkit2gtk-4.0`. No existing directory was replaced. Scripts scope `LD_LIBRARY_PATH` to launched Garmin processes. Ubuntu Java/Xvfb/wxGTK and related dependencies were installed via apt. No SDK libraries are redistributed in this repository.

To reopen the Manager:

```bash
LD_LIBRARY_PATH="$HOME/.local/share/garmin-toolchain/compat-jammy/usr/lib/x86_64-linux-gnu" \
  "$HOME/.local/share/garmin-toolchain/manager/bin/sdkmanager"
```

Sign in there, install the `fenix8solar51mm` device package and select SDK 9.2.0 as active. Do not share credentials with the project or in chat. On another OS, use Garmin's normal SDK Manager installation instead of this Linux workaround.

## Signing key

A new project-specific RSA-4096 DER key was generated outside the project (original private path omitted) with permissions 0600; its parent directory is 0700. No existing key was overwritten. Back up this key privately; retain the same app UUID and key for subsequent builds. It is outside the workspace, excluded by `.gitignore`, and is not part of the handoff.

Build scripts accept `CIQ_DEVELOPER_KEY` and `CIQ_SDK_HOME`; no absolute SDK/key path is in tracked VS Code configuration. To use another existing key:

```bash
export CIQ_DEVELOPER_KEY="/absolute/private/path/developer_key.der"
export CIQ_SDK_HOME="/absolute/path/to/sdk"
```

## Primary compile and run

After package installation, inspect its `compiler.json` and `simulator.json`, recording the package version/API range, 280 × 280 MIP, 64 colours and 131,072-byte watch-face memory. The exact files are expected below `~/.Garmin/ConnectIQ/Devices/fenix8solar51mm`; use the Manager's actual installed path if different.

From the project root:

```bash
python3 tools/check_assets.py
./tools/build.sh debug
./tools/simulator.sh start
```

In a second terminal:

```bash
./tools/simulator.sh run
./tools/build.sh test
./tools/simulator.sh test
```

The scripts run `monkeyc -f monkey.jungle -d fenix8solar51mm -y <private-key> ...` and Garmin `monkeydo`. Build logs go to `build/logs/`. VS Code tasks provide equivalent commands; Garmin's **Monkey C: Verify Installation** checks extension configuration. Command-line builds do not require changing global VS Code settings.

For a deterministic screenshot of the **real renderer**, using an explicitly labelled fixture app:

```bash
./tools/build.sh preview
./tools/simulator.sh preview
```

This alternate entry point displays fixed `08:27 / FRI 11 SEP / 74% / 68 / 6.4K / 11°`. Its separate app UUID prevents confusing preview state with the production app. `tests/Preview.mc` is excluded from production builds. Capture only after the app runs; label the resulting image **simulator capture, fixture values**. Current `design/previews/design-*` files are design renders, not those captures.

For the installable binary:

```bash
./tools/build.sh release
```

Expected output after a successful target build: `bin/TOKYO2088-fenix8solar51mm.prg`. Do not infer memory use from its file size. Check runtime high-water memory in the primary simulator with long plate text, readable telemetry, unavailable/weather extremes, repeated settings changes and at least 100 wake/sleep cycles. Record the measured value and state alongside the release log.

## Personalization and settings

Garmin settings resources provide palette, plate mode and four text fields, readable telemetry, clock format, leading zero, active seconds, units and footer visibility. In the simulator use **File > Edit Persistent Storage > Edit Application.Properties data** and send the edited settings to the running app. Confirm `onSettingsChanged` redraws without reinstalling and that a restart retains the full input.

Garmin's normal app-settings flow uses the companion/Express interfaces for recognized apps. Availability for a locally sideloaded, unpublished face is not verified here. Do not assume a store listing exists. For an initial personalized sideload, set the shipped defaults before compiling:

```bash
python3 tools/configure_defaults.py --mode city --city HOBART --subtitle 'LOCAL EDITION'
# or
python3 tools/configure_defaults.py --mode custom --line1 COREY --line2 'PERSONAL TERMINAL'
./tools/build.sh release
```

This edits the resource defaults, preserving full input up to 64 characters. Existing stored watch properties remain authoritative across updates, so changing defaults is not a substitute for editing already-saved settings. Restore Classic Red/Original with `--mode original --palette red`. On-watch text editing is not implemented. The normal Garmin settings flow on actual hardware remains an acceptance item.

## Linux transfer verification and safe revert

On this continuation, `lsusb` showed no Garmin device, and `gio mount -li` listed no mounted volumes. Therefore there is no verified watch path and no copy/removal was attempted. Ubuntu's `gvfs-backends` 1.54.4 and libmtp 1.1.21 are installed, providing the desktop MTP transport.

Garmin's [fēnix 8 manual](https://www8.garmin.com/manuals/webhelp/GUID-EECCAC99-90D6-4AB1-9A3A-EC433D3365E2/EN-GB/GUID-B6EEC065-0BAB-4A19-8350-A3A9DA44AD1D.html) confirms **Watch Settings > System > Advanced > USB Mode**, with MTP and Garmin modes. For this Linux setup, choose **MTP**, connect a data-capable USB cable, and open the device in Files. Do not assume `/media`, `/mnt`, a disk device name, or a fixed `/run/user/.../gvfs` path.

After connecting, verify the actual device and storage:

```bash
lsusb
gio mount -li
```

Open the detected watch's internal storage and confirm **GARMIN/APPS** exists. Once a device-specific release build succeeds, copy only `bin/TOKYO2088-fenix8solar51mm.prg` there. If that exact filename already exists, preserve a backup before replacing it. Do not copy generic/test/preview binaries or alter unrelated files. Garmin's [official sideload guide](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/) specifies GARMIN/APPS.

Finish the transfer, safely eject/disconnect and select TOKYO 2088 in the watch's Watch Face menu. To revert, select your previous/built-in face first. Reconnect through the same verified MTP storage and remove only the TOKYO `.prg` you copied if removal is needed. Never remove the APPS directory or unrelated `.SET`, `.DAT`, health or application files.

No physical transfer or hardware execution has occurred. A primary `.prg` is still unavailable because the device package cannot currently be found.

## Physical checklist for the owner

- Indoor light, daylight and backlight: read the time at normal glance distance; inspect the red Tokyo mark and telemetry separately.
- Confirm manual plate choice/text, local timezone, 12/24 format, leading zero, temperature units and changing settings without reinstalling.
- Compare battery/steps with built-in widgets; check recent HR while worn and its removal after taking the watch off. Disconnect the phone: clock remains correct, optional stale/missing data degrades gracefully.
- Check sleep/wake and active-seconds disappearance; keep seconds off for the first overnight test.
- Overnight: record start/end time, battery percentage, firmware, backlight, gesture, sensor settings, activities, phone connection and settings version.
- Compare an equivalent duration with the usual face under the same conditions. Repeat runs rather than promising days of battery life from one percentage change.

Only the user can mark the primary physical checks passed. No other watch is available for physical testing.
