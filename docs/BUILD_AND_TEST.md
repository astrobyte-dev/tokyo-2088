> For native Windows commands, temporary signing provenance and safe retesting, see [Windows build and retest](WINDOWS_BUILD_AND_RETEST.md). The Linux environment and results below are historical.

> Current hardware status: initially working, intermittent black-screen defect OPEN; see [investigation](BLACK_SCREEN_INVESTIGATION.md). Build instructions below reproduce a new artifact; do not overwrite the preserved release during review.

# Build, simulator and Linux installation — 11 September 2026

The installed SDK now recognizes `fenix8solar51mm`. Debug, native-test and optimized release builds explicitly targeting it succeed without compiler warnings. The hardware-test binary is:

`dist/TOKYO2088-fenix8solar51mm.prg`

The compiler output also remains at `bin/TOKYO2088-fenix8solar51mm.prg`. These are the same signed release program. Do not install test, debug, old generic syntax-check or preview binaries.

## Verified toolchain

- Active Garmin SDK **9.2.0**, installed at `~/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-9.2.0-2026-06-09-92a1605b2/` and selected by `current-sdk.cfg`.
- OpenJDK 17.0.20; Garmin Monkey C VS Code extension 1.1.3; Ubuntu 24.04, x86_64.
- Installed `~/.Garmin/ConnectIQ/Devices/fenix8solar51mm`: 280 × 280 round MIP, ARGB2222 (64 RGB colours), 131,072-byte watch-face application limit. Package API 6.0.2, device version `3d0fb192a2cf01699aefd0f384af3f527e5885bd`. [Exact package metadata and hashes](evidence/primary-device-package.sanitized.json).
- The application's API minimum remains 3.2.0; the compiler version, app minimum and device runtime API are separate values. Metadata firmware 2235 is the package's value, not an observation of the owner's watch firmware.

`tools/toolchain.sh` shares SDK selection between compiler and simulator. `CIQ_SDK_HOME` can explicitly override it. Signing keys are not distributed. Reviewers must set `CIQ_DEVELOPER_KEY` to their own private DER signing-key file outside the checkout; see GITHUB_HANDOFF.md. The existing script has a home-relative fallback, which reviewers should override. A reviewer-signed build is a new artifact, not the installed release. Retain the original UUID/key for owner updates.

## Build and run

From your project checkout:

```bash
./tools/doctor.sh
python3 tools/check_assets.py
./tools/build.sh debug
./tools/build.sh test
./tools/build.sh release
```

Every non-generic build passes `-d fenix8solar51mm`; the script rejects other targets. Logs are in `build/logs/`.

In one terminal run `./tools/simulator.sh start`. In another:

```bash
./tools/simulator.sh test
./tools/simulator.sh run           # production source, debug information available
# Kill App in the simulator before switching programs
./tools/simulator.sh run-release   # exact optimized hardware program
```

Native suite result: four groups pass, zero failures/errors. The SDK launcher nevertheless exits 1; the raw output and exit code are preserved separately. Do not infer passing tests from compilation or silently treat every nonzero exit as harmless. [Results](TEST_RESULTS.md).

For this session the simulator ran under Xvfb display `:99`; commands used `DISPLAY=:99`. Openbox was added to that isolated display to manage dialogs. Normal desktop operation does not require Xvfb. `tools/sim_ui.py` is an operator-assisted AT-SPI/xdotool helper used for these captures, not a portable unattended test harness.

## Linux SDK compatibility

Garmin's native Linux tools require WebKitGTK 4.0. This machine has actual compatible Ubuntu 22.04 libraries extracted beneath `~/.local/share/garmin-toolchain/compat-jammy/usr/lib/x86_64-linux-gnu`: WebKit/JSC 2.50.4, ICU70 70.1, libwoff1 1.0.2. The corresponding WebKit helper directory is linked at `/usr/lib/x86_64-linux-gnu/webkit2gtk-4.0`. These libraries are not redistributed in the project.

The launch scripts scope the compatibility `LD_LIBRARY_PATH` and clear incompatible Snap GTK/GIO module overrides. Use `./tools/sdk-manager.sh` to reopen the repaired Manager. Login/device installation is now complete; historical missing-package errors no longer describe the active toolchain.

The simulator launch also sends the compiler-generated settings JSON via Garmin's documented `monkeydo -a source:destination` option, using `GARMIN/Settings/TOKYO2088-FENIX8SOLAR51MM[-DEBUG]-settings.json`. Without it the Linux App Settings Editor reported “No settings file found for this app.” The editor works with the corrected launch.

Two host simulator crashes occurred during dialog handling before Openbox was running (settings modal dismissal; then externally closing a memory window). The watch-face console did not report a Monkey C exception. Avoid externally destroying GTK windows; dismiss dialogs through their normal buttons/window manager. Memory's Refresh control did not reliably refresh the observed object tree here; closing and reopening **View Memory** gave current snapshots. These are host-tool limitations, not passed hardware checks.

## Settings and captures

Use **File → Edit Persistent Storage → Edit Application.Properties data**. Wait for the settings form to load, edit, Save, acknowledge “Settings Saved”, then Close. Scroll to reach clock/seconds/unit options. Changes reach `onSettingsChanged` without reinstalling. Original/custom/manual city/hidden modes are implemented. Full custom strings survived a restart and switching from debug to release under the same app UUID.

The shipped defaults are Classic Red, Original ASTROBYTE/INDUSTRIES, follow-device clock/temperature, leading zero on, seconds off, compact telemetry and footer on. Previously stored properties take precedence over defaults, as intended.

Garmin's [developer FAQ](https://forums.garmin.com/developer/connect-iq/w/wiki/4/new-developer-faq#app-settings) confirms that sideloaded apps lack the store connection required for companion/Express settings. This build has no on-watch header editor. Header editing for the unchanged sideload is therefore an outstanding limitation; see [FIRST_INSTALL](FIRST_INSTALL.md). A later personalized binary can be prepared at development time with:

```bash
python3 tools/configure_defaults.py --mode city --city HOBART --subtitle 'LOCAL EDITION'
./tools/build.sh release
# Restore the source defaults when done:
python3 tools/configure_defaults.py --mode original --palette red
```

Changing resource defaults does not override existing saved properties. There is no on-watch keyboard/editor in this version. Printable ASCII is supported; display text is uppercased/trimmed, unsupported characters become `?`, and long text is measured, reduced to the supported small font, then ellipsized. The fixed Japanese glyphs use their own licensed subset.

For actual captures use **File → Save Screen Capture** (the Ctrl+S shortcut conflicts with another simulator command on this installation). Files are 280 × 280 PNGs exported by Garmin. Enlarge a saved capture with:

```bash
python3 tools/enlarge_capture.py design/simulator/classic-red-0827-280.png
```

This writes a separately labelled 1120 × 1120 nearest-neighbour copy and verifies the original file hash did not change. `design/previews/` contains older design renders; `tests/Preview.mc` is an unused alternate fixture. Neither produced the milestone captures.

## Install on this Linux setup

The first transfer has now completed through the discovered MTP volume, with matching readback SHA-256 and successful unmount. The connected model was confirmed from GarminDevice.xml. See [FIRST_INSTALL](FIRST_INSTALL.md) for the exact record and current header-editing limitation. Earlier no-device inventories predate this transfer. Rediscover the device on every connection; do not reuse a guessed mount path. `gvfs-backends` 1.54.4 and libmtp 1.1.21 are installed on this machine.

1. On the watch, select **Watch Settings → System → Advanced → USB Mode → MTP**, then connect a data-capable USB cable. Garmin's [fēnix 8 manual](https://www8.garmin.com/manuals/webhelp/GUID-EECCAC99-90D6-4AB1-9A3A-EC433D3365E2/EN-GB/GUID-B6EEC065-0BAB-4A19-8350-A3A9DA44AD1D.html) confirms that menu and MTP option.
2. Open the detected watch in Linux **Files**. Check `lsusb` and `gio mount -li` if it does not appear. Confirm the watch identity and find its actual internal-storage **GARMIN/APPS** directory. MTP is not necessarily a normal `/media` disk mount. Garmin's [sideload instructions](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/) specify GARMIN/APPS.
3. Optionally verify the package first: from `dist/`, run `sha256sum -c SHA256SUMS.txt`.
4. Copy **only** `TOKYO2088-fenix8solar51mm.prg` from `dist/` into that verified GARMIN/APPS directory. If that exact filename already exists, back up that file before replacing it. Do not overwrite unrelated files or copy the settings JSON/test programs.
5. Wait for the transfer to finish, eject through Files if offered, disconnect, then select **TOKYO 2088** in the watch's Watch Face menu.

If the device is absent, the smallest next action is to connect it in MTP mode with a data cable. If a transfer error appears, retain the exact error and the discovered device URI; do not guess a mount path or format storage.

To remove/revert: first select a built-in/previous watch face. Reconnect using the same verified MTP storage and remove only the TOKYO `.prg` you copied, or use the watch's app removal interface if it identifies TOKYO 2088. Do not delete APPS, other applications, health records or unrelated `.SET`/`.DAT` files. Garmin may normalize imported filenames; if the file is no longer identifiable, stop file deletion and use the watch's removal interface.

## First physical test

Check normal-glance readability indoors, outdoors and with backlight; local time/date and format; plate/settings retention; sleep/wake and active seconds; battery/steps against built-in widgets; HR freshness when worn/removed; weather/phone disconnection. Keep seconds off for the first overnight run.

For battery comparison record firmware, time span, start/end percentage, phone connection, backlight/gesture/sensor settings and activities, then compare equivalent runs against the usual face. Simulator heap measurements cannot establish battery life. The owner now reports initial operation and an intermittent black screen; see BLACK_SCREEN_INVESTIGATION.md. Further physical validation remains pending.
