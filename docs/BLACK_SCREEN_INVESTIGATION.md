# Intermittent black screen on fenix8solar51mm, no IQ icon

**Update:** a [Windows candidate and executed regression](WINDOWS_REDRAW_RESULTS.md) address the same-minute renderer flaw. The hardware issue remains open. The original handoff below records the pre-fix source and evidence; it is retained as history.

Status: **OPEN — owner-reported hardware defect; not diagnosed or fixed.** Recorded 11 September 2026.

The owner reports that TOKYO 2088 is installed and initially works on the actual Garmin fēnix 8 Solar 51mm, but the screen occasionally goes completely black. There is **no visible IQ error icon**. The trigger, duration and recovery method have not been established. Absence of an IQ icon does not rule out a runtime failure. Previously passing simulator checks do not establish that this hardware defect is resolved.

## Installed-release identity and provenance

- Primary target: `fenix8solar51mm`, round 280 × 280 MIP. No additional target is enabled.
- Existing non-test release: `dist/TOKYO2088-fenix8solar51mm.prg`, version 0.1.0, **24,188 bytes**.
- SHA-256: `8a3469f4ab629d809d22b4ba61fd060f329919b1d7013f0b679ef0ea2f29ac64`.
- The prior MTP transfer read back the identical byte count and SHA-256. Only this PRG was copied; no existing TOKYO file required replacement. See [sanitized transfer evidence](evidence/first-install-sanitized.json) and [first-install report](FIRST_INSTALL.md).
- The connected watch's Model section reported `SoftwareVersion` **`2331`**. This is the raw value actually read during installation; no different firmware value is inferred. The SDK package's `2235` is unrelated package metadata, not the observed watch value.
- The release, readback, debug artifacts and original logs remain local, including an independent pre-handoff archive. No build, patch or reinstall was performed for this handoff.
- The current four production `.mc` file hashes match the prior [release build record](evidence/installed-release-build-info.json). The [source snapshot](evidence/source-state.json) records all current source/resource/test/build-script inputs. There was no pre-existing Git repository. The old build record does not hash all original resources, manifest and build inputs, so **this new source commit is not asserted to have produced the installed binary**. The historical build record's physical-testing status predates the owner report.

## Known checks and missing evidence

These are **previous simulator/host results**, not new tests performed for this handoff:

- 40 host asset checks passed separately from native execution.
- Device-specific debug, native-test and optimized release compilation succeeded using SDK 9.2.0.
- Four native test groups passed in the target simulator (`0 failed, 0 errors`). The Garmin `monkeydo` launcher still returned **exit code 1**; that unexplained discrepancy remains documented and was not suppressed.
- Actual production simulator captures include 280 × 280 Classic Red / ASTROBYTE and HOBART, low-power operation and live midnight transition. They are in [the capture index](../design/simulator/README.md).
- The native suite exercised 100 explicit wake/sleep/settings callback cycles. These were fixtures, not physical cycles. Highest observed production simulator peak memory was 20.1 kB; no battery-life conclusion follows.
- Detailed methods and limits remain in [TEST_RESULTS.md](TEST_RESULTS.md).

**Actual device crash logs have not been collected.** No local physical crash log was identified in this project. Existing GTK/simulator-host crash logs concern the Linux host and are not device logs. Raw local evidence and build/debug artifacts are preserved outside Git; no personal watch data was uploaded. The watch was not accessed during this handoff. There is no verified hardware black-screen reproduction, recorded event timestamp, duration, recovery sequence or physical failure screenshot yet.

## Source map for independent review

The following are review targets, **not confirmed causes**. Links point to the unchanged implementation; search the named functions for exact locations.

| Area | Actual implementation and review boundary |
|---|---|
| Initial view and app settings | [TokyoApp.mc](../source/TokyoApp.mc): `TokyoApp.getInitialView()` creates `TokyoView`; `onSettingsChanged()` calls `reloadSettings()` and requests an update. |
| Full update and partial update | [TokyoView.mc](../source/TokyoView.mc): `TokyoView.onUpdate(dc)` reads time, may return early, refreshes telemetry and calls `render()`. There is **no `onPartialUpdate` override**. `drawSeconds()` is called from `onUpdate`, not from a partial-update callback. |
| Sleep and wake | `TokyoView.onEnterSleep()` sets `awake=false`, `dirty=true`, requests an update. `onExitSleep()` sets `awake=true`, `dirty=true`. |
| Returning after another view | No explicit `onShow()` or `onHide()` override is present in `TokyoView`; no custom return-to-face delegate appears in `TokyoApp`. Framework lifecycle and the subsequent `onUpdate`/dirty-state behaviour need review; a hardware transition has not been traced. |
| Clearing and draw state | `TokyoView.render()` begins with `clearClip()`, white foreground/black background and `clear()`, then draws the full layout. `drawSeconds()` sets a small clip, clears, draws, then clears the clip. There is no `try/finally` draw-state restoration. |
| Cached rendering and early returns | `awake`, `dirty`, `lastMinute`, `lastSample` in `TokyoView`; `reloadSettings()` invalidates dirty/sample state. `onUpdate()` returns when `!dirty && minute==lastMinute`, optionally drawing seconds. It caches data/timestamps, not a retained full-frame bitmap. The rendering path sets `dirty=false` after completion. |
| MIP versus AMOLED | `Profile` in `TokyoView.mc` and [manifest.xml](../manifest.xml) enable only the 280px primary MIP target. Low-power rendering uses the same full `render()` layout; seconds depend on `awake`. There is no AMOLED/AOD branch or supported AMOLED profile. |
| Telemetry fallback and exceptions | [Data.mc](../source/Data.mc): `DataSnapshot.refresh()` and `Format` helpers implement missing/stale data placeholders. Steps, HR and weather reads each have empty `catch(e)` handlers. System stats/device settings reads outside those handlers and the drawing/time/settings paths have no general exception handler. No physical exception trace is available. |
| Settings and text | [Settings.mc](../source/Settings.mc): `FaceSettings.reload()`, type/range validation, `safeText()` and `LocationLabelProvider.plate()`; `TokyoView.fitted()`/`drawPlate()` fit text. |
| Existing fixture coverage | [FaceTests.mc](../tests/FaceTests.mc): `formatting`, `headerSettings`, `rendererMatrix`, `repeatedPowerCycles`. Their passing results do not establish behaviour after arbitrary hardware view transitions or explain this defect. |

No implementation changes or proposed diagnosis are part of this handoff. The next investigation should correlate an observed hardware event with lifecycle/render state and any available redacted device error evidence before claiming a cause or fix.
