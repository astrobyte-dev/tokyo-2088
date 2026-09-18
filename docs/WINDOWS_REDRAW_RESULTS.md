# Windows redraw investigation — 11 September 2026

**Source flaw addressed; native simulator regression passed; physical issue unresolved. Refs #1.** The owner reports intermittent complete blackness without a visible IQ icon. Trigger, duration and recovery remain unknown. No watch installation, deletion, reset or firmware change was performed.

## Diagnosis and minimal change

The fresh Windows checkout matched reviewed commit `7244158815f65233be23fc3cd213c609dabceb8d` exactly, with origin `https://github.com/astrobyte-dev/tokyo-2088.git`. Work is on `fix/windows-mip-redraw`. GitHub visibility was verified PUBLIC and preserved.

The original `onUpdate` returned on clean same-minute callbacks, doing no drawing with seconds off or drawing only the seconds rectangle with active seconds. Its cached objects were telemetry, settings and font resources, not a retained full-frame bitmap. This cannot restore a DC whose pixels have been cleared.

Garmin's [WatchFace documentation](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html) describes full updates each second while active and minute updates in low power. [View documentation](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html) also allows multiple updates during transitions. The explicit statement about differing clear-before-update frameworks comes from [Garmin's developer response in the linked report](https://forums.garmin.com/developer/connect-iq/i/bug-reports/vivoactive-4-clears-screen-before-onupdate), not a fenix 8 hardware trace. This supports high confidence in the source flaw and a strong candidate explanation for this device report, without confirming its cause. An absent IQ icon does not exclude an exception.

The production change removes the same-minute early return. Every full update now executes the existing full renderer, then optional active seconds. The existing 60-second data throttle, backward-time handling and settings-triggered refresh remain. Two tiny overridable clock accessors support deterministic fixtures. No rendering geometry, resource, palette, identity behavior, UUID, low-power policy, timer or data API was changed. `dirty` and `lastMinute` remain lifecycle bookkeeping, no longer permission to omit drawing.

`render` clears clipping and reconstructs the scene; `drawSeconds` clears its clip after drawing. Low power omits seconds and retains the full MIP face. Full updates after inherited `onShow` now repaint without requiring invalidation. An extra `onShow` override would add no rendering guarantee. The existing sleep callback requests one update; `onUpdate` does not request another. No new catch-all handler or framebuffer cache was added.

## Executed validation

Native Windows toolchain: Git, Microsoft OpenJDK **17.0.18**, Monkey C extension **1.1.3**, SDK Manager discovered, active SDK/compiler **9.1.0**. It was the only installed SDK; 9.2.0 was not assumed available. Device package: `fenix8solar51mm`, API **6.0.0**, 280 × 280 MIP, ARGB2222, 131,072-byte watch-face limit; package version `45fe3cbb0de8ea0a70e12628d2697915f1272301`. Historical Linux results used SDK 9.2.0 / device API 6.0.2. Package versions do not establish watch firmware.

| Check | Actual result |
|---|---|
| Baseline debug / native-test / release / capture builds | Successful, native compiler exit 0, no warnings |
| Candidate debug / native-test / release / both capture builds | Successful, native compiler exit 0, no warnings |
| Regression before production fix | Four existing groups passed; both new reset groups raised assertion errors at the first cleared same-minute update |
| Final baseline suite, same tests as candidate | **5 passed, 0 failed, 2 errors**; both reset tests fail; benchmark passes |
| Final candidate native execution | **7 passed, 0 failed, 0 errors** |
| Native Windows launcher exit | **0 on both failing baseline and passing candidate**; distinct from historical Linux exit 1 |
| Test wrapper result | Baseline failure exit 1; candidate pass exit 0; original native status and framework verdict both preserved |
| Host asset checks | **40 passed**, isolated worktree only; Pillow emitted a `getdata` deprecation warning |
| Native PNG comparison | Baseline black with seconds off, only seconds with seconds on; candidate restores plate, Tokyo/2088 and both time rows; exact matching reference regions |
| Physical defect | Still open; not reproduced on hardware during this task |

The final baseline uses original production behavior plus only the clock seam; baseline/candidate use the same Windows compiler, key and committed resources. A detached worktree under `build/windows/baseline-source` holds the baseline. Final baseline test artifacts are in `build/windows/baseline-final`; initial baseline builds remain in `build/windows/baseline`; candidate artifacts are in `build/windows/candidate`. These are new builds, not the previously installed release.

The reset tests render once, clear the Garmin DC externally, then call production `onUpdate` without marking dirty or changing the minute. They compare the complete sequence of actual production text calls, explicitly verifying hours, minutes, both plate lines, Tokyo and 2088. They cover seconds off/on, ten repeated clears, a fresh buffered DC, stale clip entry, sleep/wake, hide/show return, minute and local midnight/month/year changes, backward time and settings reload. A counting data fixture verifies telemetry remains cached across repeated updates and lifecycle callbacks. Real Garmin font/DC rendering still executes. Pixel validation is performed on exported simulator PNGs; no invented pixel-reading API is used.

Existing formatting/settings/data fallback tests and the 140-render matrix still pass, as do 100 wake/sleep/settings cycles. Native fixtures simulate lifecycle callbacks; they are distinct from manually selecting simulator display modes and from physical events.

## Images and cost

See the [capture index](../design/simulator/windows-redraw/README.md). Exported PNGs are actual native 280 × 280 Garmin captures. The injected reset fixture is explicitly labelled. `python tools/compare-redraw-captures.py` checks the baseline failure pixels, compares candidate time/identity regions to the preserved `classic-red-0827-280.png`, and asserts that candidate seconds-off/on images differ only in the seconds rectangle. It passed. The normal Windows baseline's identity regions also matched the restored candidate.

The production baseline and candidate were visually inspected in High Power and Always-Active modes. The release remained visible across observed real simulator minute changes. Active seconds and low-power suppression are also verified by deterministic native callback tests. Midnight/month/year transitions pass in the clock fixture; no new live simulator midnight or physical timezone/DST claim is made.

| Measurement | Baseline | Candidate |
|---|---:|---:|
| 240 fixed-time callbacks, seconds off | 0 ms (timer resolution) | 1,891 ms |
| 240 fixed-time callbacks, seconds on | 31 ms | 1,766 ms |
| Benchmark sampled maximum heap | 30,000 bytes | 29,928 bytes |
| Telemetry refreshes across 480 benchmark callbacks | 1 | 1 |
| 100 lifecycle cycles sampled maximum | 29,640 bytes | 29,568 bytes |

Benchmark timing includes loop/stat collection and rendering onto a buffered test DC with fixed data; it is simulator wall time, not physical CPU time or energy. The candidate averages about 7.4–7.9 ms per full callback in this run. The baseline's cheap early return is precisely the broken behavior under test. Production optimized release memory viewer: **17.8 / 123.9 kB current**, **19.4 kB reported peak**, **0 new resource allocations in last onUpdate**. These viewer units and samples are retained as reported; they are not a universal peak bound. No battery-life conclusion follows.

## Watch evidence and artifact provenance

Windows WPD and Shell MTP discovery found the connected fenix. Relevant `GARMIN/Apps/LOGS` entries were inspected read-only and `CIQ_LOG.BAK` copied to ignored local evidence. MTP advertised zero bytes, but the copied file contained 462 bytes; relying on the listing alone would have missed it. It contains an older error for a different application, not TOKYO 2088. No matching TOKYO exception record was found in that inspected directory. This does not prove that no relevant device evidence exists elsewhere. Raw logs and device identifiers are not committed or uploaded.

The private owner signing key is unavailable on Windows. All investigation PRGs are signed with a separately generated **temporary Windows development key**, RSA 4096-bit PKCS#8 DER, stored outside the repository and cloud sync. The original owner explicitly authorized this investigation key; it was not adopted as the canonical key. No key contents are in logs or Git.

Candidate release: `build/windows/candidate/TOKYO2088-fenix8solar51mm-release.prg`, **24,172 bytes**, SHA-256 **`7e3c596c7f85eabd7fe535a3025d431e0d4e298726099b279a93363833dbd038`**. UUID `d8c8adfe21c74bdd97fa2088ac010001`, version `0.1.0`, unchanged. This artifact is not the original 24,188-byte installed PRG with SHA-256 `8a3469f4ab629d809d22b4ba61fd060f329919b1d7013f0b679ef0ea2f29ac64`. No original installed-release binary or private Linux key was present in this fresh checkout.

Generated assets changed in the isolated asset-check worktree (font metrics/PNG encoding/previews); none of those changes entered the fix checkout. Source/resource diff inspection confirmed production assets remain unchanged. Raw build/debug files stay local; reviewed test logs and native screenshots accompany this report.

Remaining limits: original-key transfer and separately approved installation; physical reproduction/retest; real battery cost; original PRG backup for binary rollback. Garmin's settings editor requested login and was not used, while native settings/fallback tests completed. Follow [Windows build/signing/install and physical retest instructions](WINDOWS_BUILD_AND_RETEST.md). Do not merge or close issue #1 based only on this simulator result.
