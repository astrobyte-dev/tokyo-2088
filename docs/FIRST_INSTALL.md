# First physical-device transfer — 11 September 2026

**Transfer complete and verified. Subsequent owner report: installed and initially working, with an intermittent complete black screen and no visible IQ icon. The defect remains OPEN.** See [investigation](BLACK_SCREEN_INVESTIGATION.md). This report preserves the earlier transfer observations separately from that later hardware report.

## Release and connected device

Used the existing, unchanged release at:

`dist/TOKYO2088-fenix8solar51mm.prg`

It is version 0.1.0, 24,188 bytes, target `fenix8solar51mm`. Its bytes match both `dist/BUILD_INFO.json` and `bin/TOKYO2088-fenix8solar51mm.prg`; the prior release compiler log reports BUILD SUCCESSFUL. No rebuild or source/resource/settings change was made.

Connected device was detected by USB as Garmin `091e:51b5`, then confirmed by reading only the Model section of its GarminDevice.xml through MTP:

- Description: `fenix 8 - 51mm, Solar`
- PartNumber: `006-B4533-00` (matches the installed primary device profile)
- SoftwareVersion: `2331` (raw value reported by the connected device)

The MTP root was discovered from GIO's volume inventory, not guessed from a disk mount. Its storage exposed `Internal Storage/GARMIN/Apps` with that exact directory spelling. Existing GVFS/GIO/libmtp tools were sufficient. A process-local `GIO_MODULE_DIR`/GTK override hid the volume from the initial command; the checks used a clean per-command environment. No software was installed and no global/system configuration was changed.

## Write and verification

Only `TOKYO2088-fenix8solar51mm.prg` was copied to **Internal Storage/GARMIN/Apps** through GIO's MTP backend. The pre-copy directory listing contained no existing TOKYO PRG, so no replacement or backup was needed. `Gio.File.copy` used `Gio.FileCopyFlags.NONE`, which refuses overwrite if a destination appears unexpectedly.

Read the copied file back with GIO MTP `load_contents`, saved the readback locally, and compared SHA-256:

```text
Source:   8a3469f4ab629d809d22b4ba61fd060f329919b1d7013f0b679ef0ea2f29ac64
Readback: 8a3469f4ab629d809d22b4ba61fd060f329919b1d7013f0b679ef0ea2f29ac64
Bytes:    24188
MATCH
```

The app-directory listing afterwards had exactly one added entry: this PRG. No prior directory entries were removed/changed. No firmware, activity, map, other app, settings file or other watch data was written. This directory comparison is not an audit of the whole watch; the operation itself targeted only the PRG.

GIO MTP unmount completed with exit 0, and a subsequent inventory confirmed no MTP mount remained. The USB cable can now be disconnected. Verification establishes that the MTP server returned the exact release bytes; it does not prove post-disconnection import/signature acceptance, successful startup, persistence through reboot, readability or battery performance.

Evidence: [sanitized transfer record](evidence/first-install-sanitized.json). Original MTP inventory/URI, device records and readback PRG remain local and are intentionally excluded from Git. The original report is also preserved in the local pre-handoff archive.

## Select and revert

After unplugging, from the current watch face hold the **middle-left button**, choose **Watch Face**, find TOKYO 2088 (look under **Add New** if necessary), and choose **Apply** using the upper-right button. Garmin documents this selection flow in the [fēnix 8 manual](https://www8.garmin.com/manuals/webhelp/GUID-EECCAC99-90D6-4AB1-9A3A-EC433D3365E2/EN-US/GUID-2EA4B09F-BC09-4EA6-BA87-5911680F66BE.html). The owner subsequently reported successful initial operation; no agent-observed physical screen capture is available.

To revert, select the previous or a built-in face. For removal, use the watch's Delete option if it clearly identifies TOKYO 2088, or reconnect and discover the actual MTP storage again before removing only this app's identifiable PRG. Do not assume the current URI or filename normalization will persist across reconnection/import.

## Custom-header limitation on this sideload

The current release has no implemented on-watch header editor. Its app-property settings work in the simulator, but **phone/Express configuration is not a supported route for this sideload**: Garmin's [New Developer FAQ](https://forums.garmin.com/developer/connect-iq/w/wiki/4/new-developer-faq#app-settings) explains that sideloaded apps lack the store connection required by those settings interfaces. A store beta/pending-approval distribution is Garmin's documented testing route for companion settings; nothing was uploaded or published here.

The existing project can generate a later personalized release by changing resource defaults using `tools/configure_defaults.py`, for example `--mode city --city HOBART --subtitle 'LOCAL EDITION'`, then rebuilding for `fenix8solar51mm`. This is a development-time option, not an editor for the installed PRG. Previously saved watch properties can override changed defaults, so it is not yet a verified in-place personalization workflow for this installation.

Transferring simulator-generated `.SET` properties is a developer workaround discussed on Garmin's forums, but it has not been validated for this watch/build. No `.SET` file was copied, no existing properties were deleted, and no future personalization route is being claimed as physically tested. **Convenient header editing for the unchanged sideload remains an outstanding limitation.** The installed release keeps its existing Classic Red / ASTROBYTE / INDUSTRIES defaults, with seconds off unless pre-existing app properties override them.

## Test status retained

The owner reports initial physical execution and an unresolved intermittent black screen. Sensors, normal-glance/daylight readability, settings behaviour and battery remain unvalidated. The earlier native framework result remains four passing test groups with zero failures/errors, while the unexplained `monkeydo` launcher exit code remains **1**. That discrepancy has not been suppressed or reclassified by a successful file transfer.
