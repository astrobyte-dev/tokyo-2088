# Test results — 11 September 2026

The primary-device milestone now runs. The earlier login/device-package blocker is resolved. **Owner hardware report: installed and initially working, but intermittent complete black screen with no visible IQ icon. Defect OPEN; trigger, duration and recovery unknown.** See [investigation](BLACK_SCREEN_INVESTIGATION.md).

| Required category | Actual status | Evidence |
|---|---|---|
| Asset checks | **40 passed**, re-executed; host geometry/palette/glyph checks only | [asset-checks.json](asset-checks.json) |
| Device-specific compilation | **PASS**: debug, native-test and optimized release, explicitly `-d fenix8solar51mm`; no compiler warnings | [debug](evidence/primary-debug-compile.log), [test](evidence/primary-test-compile.log), [release](evidence/primary-release-compile.log) |
| Executed native tests | **4 groups passed, 0 failed, 0 errors**, in the actual target simulator | [raw framework results](evidence/native-tests-passed.log), [launcher exit code](evidence/native-tests-exit-code.txt) |
| Simulator visual/runtime checks | **Executed**: production debug and release programs; native 280px captures, settings, data fallbacks, power transitions and memory | [capture index](../design/simulator/README.md), measurements below |
| Physical-device PRG transfer | **PASS**: existing release copied through MTP, readback SHA-256 matched, MTP unmounted successfully | [First-install report](FIRST_INSTALL.md), [transfer evidence](evidence/first-install-sanitized.json) |
| Physical-watch testing | **OWNER-REPORTED initial operation; BLACK-SCREEN DEFECT OPEN**. Sensors, readability, settings behaviour, battery and reproducible failure conditions remain unvalidated | [First-install report and limitations](FIRST_INSTALL.md) |

## Toolchain and target

SDK 9.2.0, Java 17.0.20, installed `fenix8solar51mm` package API 6.0.2. Verified round 280 × 280 MIP, 64 RGB colours and 131,072-byte watch-face application memory limit. Simulator title: **fēnix 8 Solar 51mm / tactix 8 Solar 51mm (6.0.2)**. Only `fenix8solar51mm` is enabled/compiled; the shared simulator title is not a claim that another product was tested. [Package metadata, part numbers and hashes](evidence/primary-device-package.sanitized.json).

Production API minimum is 3.2.0. Package firmware metadata is not the owner's observed firmware. Generic compilation logs from the earlier handoff are historical and are not counted as primary builds or executed tests.

## Native suite actually executed

Command: `DISPLAY=:99 ./tools/simulator.sh test`, after `./tools/build.sh test`. `tests/Preview.mc` was excluded and was not used to produce milestone images.

- `formatting`: 12/24-hour/noon/midnight and leading-zero formatting; null, invalid, stale and future HR; zero/missing/large step counts; missing/stale/negative/zero temperature and Fahrenheit conversion; battery 0/1/9/10/99/100 and invalid values.
- `headerSettings`: Original, Custom, Manual city, empty city fallback, Hidden; whitespace normalization, unsupported/mixed Japanese user input fallback; invalid stored palette fallback and restoration.
- `rendererMatrix`: **140 actual Garmin buffered-DC draws** (four palettes × five digit pairs × seven battery cases) using production `TokyoView` and loaded Garmin resources; long header width assertion, readable telemetry, hidden plate, power callbacks and clipped seconds followed by a full draw. These are render executions, not 140 visually inspected screenshots.
- `repeatedPowerCycles`: **100 explicit fixture cycles** calling production settings reload, wake, draw, sleep, draw and same-minute update. Asserts awake/dirty state, completion of redraw and same-minute data-cache reuse. No app timer or alternate renderer is involved. This is a callback fixture, separate from the UI-controlled transitions below.

The initial native run exposed real string handling problems: ASCII-space comparisons using `==` failed to trim, and UTF-8 substring handling was inappropriate for character iteration. Corrected `safeText` to use each character's string and `.equals`. Fixed sentinel comparisons in data handling to use string-value equality. Also fixed test assertions attempting `assertEqual(null,null)`, which that assertion rejects. The initial failing run is retained in [native-tests-initial.sanitized.log](evidence/native-tests-initial.sanitized.log).

Final framework result:

```text
Ran 4 tests
PASSED (passed=4, failed=0, errors=0)
```

**Launcher discrepancy:** Garmin `monkeydo` exited **1** on both the earlier three-group successful run and final four-group successful run. There is no failing test/error in the final framework output. The SDK shell delegates the exit status to `MonkeyDoDeux`; no wrapper was added to force success and SDK internals were not modified. Treat the framework's four passing results and the nonzero launcher status as separate observations. CI automation should retain the log; the unexplained launcher status remains a tool limitation.

## Production simulator checks

The screenshots were exported with Garmin **File → Save Screen Capture** while running compiled production programs. Each raw file is 280 × 280. Enlargements use Pillow nearest-neighbour scaling of those files only; their original bytes were hash-checked unchanged. No concept-board crop, generated artwork or separate preview renderer was substituted.

| Scenario | Method and observed result |
|---|---|
| Classic Red / ASTROBYTE / 08:27 | Production program, Garmin Time Simulation control. Native screenshot inspected: huge fixed-width stacked time, correct dedicated 東京 glyphs, 2088, red rule/stripe and industrial plate. |
| HOBART / LOCAL EDITION | Actual App Settings Editor → Manual city. Saved settings rendered immediately and HOBART survived simulator/app restart. [280px](../design/simulator/hobart-0827-280.png). |
| Minute change / sustained low power | Simulator clock stepped from 08:27 to 08:28. The optimized release subsequently ran in Always-Active mode with Time Simulation resumed at factor 1 and advanced from 08:27 to 08:35, preserving the full face. [HOBART 08:28](../design/simulator/hobart-0828-280.png), [release 08:35](../design/simulator/release-low-power-after-running-280.png). |
| Midnight / date / month / year | **Live midnight transition passed in the optimized release in Always-Active mode:** Time Simulation started at 23:59:55, then the actual face changed from FRI 11 SEP 23:59 to SAT 12 SEP 00:00 without stepping its clock again. [Live before](../design/simulator/live-midnight-start-confirmed-280.png), [live after](../design/simulator/live-midnight-completed-280.png). Month/year were additionally stepped between THU 31 DEC 23:59 and FRI 1 JAN 00:00: [before](../design/simulator/before-year-rollover-280.png), [after](../design/simulator/after-year-rollover-280.png). |
| 12-hour device setting | Settings → Time Display → 12 Hour, simulated 13:00; rendered **01 / 00 PM**. Returned to 24 Hour. [Capture](../design/simulator/12-hour-pm-280.png). Forced 12/24 helpers and leading zero also passed native tests. |
| Missing HR/weather | Moving simulated time outside sample freshness windows gave `--` for both, with the clock intact. This verifies expiry/fallback in the running app, not real sensor loss. Null/invalid/future cases also exercised by the native fixtures. |
| Disconnected phone | Simulator BLE **Not Connected** selected; clock/plate remained available, optional expired data stayed `--`. No artificial connection indicator or network request. [Control states](evidence/simulator-edge-controls.json). |
| Low battery | Native Set Battery Status control set **1%**; numeric 1%, white stripe outline/exclamation and LOW label displayed. Native renderer fixture additionally exercised 0/9/10/99/100/null. No actual battery was measured. |
| Long custom identity | Two long fixture strings entered and saved. Width-based smaller font plus ellipsis stayed inside the plate. Full original strings survived restarting into the release program under the same app UUID. [Screenshot](../design/simulator/long-custom-header-280.png), [stored strings](evidence/settings-after-release-restart.json). |
| Hidden / readable telemetry | Hidden header removed both text lines while preserving the structure/time; larger telemetry option applied through settings. [Capture](../design/simulator/hidden-low-power-280.png). |
| Active ↔ low power | Simulator **Display Mode → High Power / Always-Active** exercised both callbacks. Memory object inspection confirmed `awake=false` in Always-Active. Active seconds appeared, then disappeared on entry to low power; full MIP clock/date/Tokyo/telemetry stayed visible. [Active](../design/simulator/seconds-on-active-280.png), [low power](../design/simulator/seconds-off-low-power-280.png). |
| Settings persistence | Manual city survived host/app restart. Long custom strings, Hidden/readable/seconds settings survived switching from debug to optimized release with the same UUID. The release initially retained those preferences, demonstrating why resource defaults do not overwrite stored values. Original branding/seconds-off were subsequently restored through the editor. |

The simulator's **Sleep Mode** checkbox is a device sleep preference, not the watch-face power transition control. Actual low-power checks used **Always-Active**. The 100-cycle count belongs to native callback fixtures, not 100 manually observed UI cycles.

Date-control caveat: on this Australia/Hobart host, setting January 1 to 00:00 in Garmin's Time Simulation produced the previous local hour; input 01:00 produced the captured local 00:00 / 1 JAN. The implementation uses `System.getClockTime()` and `Gregorian.info(Time.now())` with no added timezone offset. This records the observed control behaviour; it does not establish real-device DST/timezone correctness. Physical timezone/DST validation remains pending.

## Runtime memory measurements

Method: run the production `.prg`, open **File → View Memory**, inspect the reported current and peak usage; close/reopen that window for a fresh object snapshot (Refresh alone appeared stale here). Enabled peak-memory detection for part of the debug run. These are Garmin simulator readings, not estimates from PRG size.

| Running context | Current | Reported peak | Notes |
|---|---|---|---|
| Production debug, HOBART | 18.0 / 123.8 kB | 19.5 kB | [Viewer screenshot](evidence/production-memory-hobart.png) |
| Production debug, long strings, low power | 18.2 / 123.8 kB | 20.0 kB | [Snapshot](evidence/production-memory-long-low-power.txt), awake=false |
| Production debug after edge/settings/power checks | 18.2 / 123.8 kB | **20.1 kB** | [Snapshot](evidence/production-memory-final.txt), peak objects 115, zero new resource allocations in last onUpdate |
| Optimized release, retained stored preferences | 18.0 / 123.8 kB | 19.6 kB | [Snapshot](evidence/release-memory.txt) |
| Optimized release after settings restoration and sustained low-power run | 18.1 / 123.8 kB | 19.9 kB | [Snapshot](evidence/release-memory-final.txt), zero new resource allocations in last onUpdate |

The viewer's displayed denominator is 123.8 kB; installed package memory limit is 131,072 bytes. Values are transcribed with the viewer's units/rounding, not converted to an invented exact heap ceiling. Highest observed production peak was 20.1 kB; this is not a proof of every possible future peak.

Final native test context separately reported 26,744 bytes after the render matrix and 26,072 bytes maximum among the 100-cycle samples. Those include a buffered test context and are **not production peak measurements**. The repeated-cycle fixture's 65,536-byte guard passed. No Monkey C crash, missing resource error or application memory-budget error occurred in final tests/production runs. No battery-life prediction is derived from any of these numbers.

## Visual comparison and remaining limits

Compared the real 280px output with the **right-hand TOKYO 2088** concept. Preserved composition, stacked hero numerals, left Tokyo/2088, right date, red stripe/rule and configurable industrial plate. Deliberate MIP differences: solid crisp numerals instead of texture/glow, compact abbreviated telemetry with labels, coarser truthful battery segments, and an optional short English footer. Tiny concept text/icons were not reproduced at the expense of legibility. The design was not replaced.

Only Classic Red received the full running-face screenshot review; all four palettes ran through the native renderer matrix and host checks. Other palettes still need equivalent running-face visual review before a broader palette-polish claim. No alternate device profile, AMOLED AOD or automatic city service is implemented. Physical status is the owner report above, separate from simulator checks.

Linux host-tool issues were investigated separately: missing settings JSON fixed by the `monkeydo -a` launch; initial GTK dialog handling produced two simulator-host crashes without a Monkey C exception. Openbox was subsequently used on Xvfb and ordinary dialog controls used. [First host crash log](evidence/simulator-host-settings-close.sanitized.log). These crashes and the test-launcher exit discrepancy remain disclosed; no hardware crash is inferred.

The first physical-device transfer is now complete: release PRG copied through MTP with matching readback checksum and successful unmount. Initial physical operation is now owner-confirmed, with the intermittent black-screen defect open. Removal, sensors, MIP readability, timezone/DST and battery validation remain pending. Companion settings are unavailable for this sideload according to Garmin's developer FAQ; no on-watch header editor is implemented. No unrelated watch files were altered. [First-install report](FIRST_INSTALL.md), [installation checklist](BUILD_AND_TEST.md).

Historical blocked/generic results are retained in `evidence/historical-TEST_RESULTS.sanitized.md`; they are superseded by the target results above.

## First physical-device transfer

The unchanged release was copied on 11 September 2026 to the connected `fenix 8 - 51mm, Solar`, part `006-B4533-00`, reported software value `2331`. MTP readback matched the release SHA-256. This is transfer verification only; the subsequent owner report confirms initial operation and an unresolved intermittent black screen. [Full record](FIRST_INSTALL.md). The native launcher exit-code discrepancy above remains unresolved.
