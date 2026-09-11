# Actual Garmin simulator captures

These are Garmin **Save Screen Capture** exports of the running compiled production Monkey C face on **fenix8solar51mm**, SDK 9.2.0 / device API 6.0.2. Raw captures are unaltered 280 × 280 PNGs. No alternate preview renderer or generated artwork was used. Data and dates are simulator-controlled, not physical readings.

| Capture | Original, native 280px | Labelled 4× nearest-neighbour copy |
|---|---|---|
| Classic Red / ASTROBYTE / 08:27 | [Native](classic-red-0827-280.png) | [1120px nearest-neighbour](classic-red-0827-280-4x-nearest.png) |
| HOBART / LOCAL EDITION / 08:27 | [Native](hobart-0827-280.png) | [1120px nearest-neighbour](hobart-0827-280-4x-nearest.png) |
| Optimized release, restored Original plate, 1% battery | [Native](release-original-0827-280.png) | [1120px nearest-neighbour](release-original-0827-280-4x-nearest.png) |

Additional actual frames:

- [Long custom plate, clean truncation](long-custom-header-280.png)
- [12-hour PM format](12-hour-pm-280.png)
- [23:59 / 31 DEC](before-year-rollover-280.png) and [00:00 / 1 JAN, 1% battery](after-year-rollover-280.png)
- [Hidden header, active seconds visible](seconds-on-active-280.png) and [same full MIP layout in low power, seconds gone](seconds-off-low-power-280.png)
- [HOBART at 08:28](hobart-0828-280.png)
- [Release at 08:35 after sustained low-power running](release-low-power-after-running-280.png)
- [Live 23:59 / FRI 11 SEP](live-midnight-start-confirmed-280.png) → [00:00 / SAT 12 SEP](live-midnight-completed-280.png), continuously running release in low power

The optimized release initially retained Hidden/readable/active-seconds preferences saved in the debug program, because both use the same app identity. `release-retained-hidden-seconds-*` records that persistence check; it is not the shipped default. The source defaults and final restored Original screenshot have seconds off.

All `*-4x-nearest.png` files were created by `tools/enlarge_capture.py`, which checks the input is 280 × 280 and verifies its SHA-256 remains unchanged. No interpolation, smoothing, annotations or replacement pixels were applied to raw captures. Raw PNG hashes are listed in `capture-hashes.json`.

The earlier `../previews/design-*` images are explicitly **design renders**, not simulator evidence. `tests/Preview.mc` is an unused alternate fixture and did not create these images. See [TEST_RESULTS](../../docs/TEST_RESULTS.md) for control settings, actual native test counts, memory and limitations.
