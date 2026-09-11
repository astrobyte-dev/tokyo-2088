# Design and implementation decisions

## Composition

Only the right-hand TOKYO 2088 concept is used. Original chamfered 50 × 78 numerals create two aligned rows, 156 pixels of time height plus a 3-pixel gap. All numerals have the same advance; narrow `1` remains optically centred. The left 東京 glyphs are a dedicated 40px two-character subset, separate from the user plate. `2088` is fixed artwork text, never the calendar year. Local time comes from `System.getClockTime()` and the local Gregorian date from `Gregorian.info(Time.now())`; no Tokyo or manual timezone offset is applied.

Classic Red is selected over the readability variant because it gives telemetry more breathing room and preserves the clock's hierarchy. The readable setting increases telemetry from 13 to 16 nominal font pixels, falling back to 13 when a field exceeds its measured 48px slot. Reference deviations: no distressed texture; no glow; smaller 2088; labelled telemetry instead of tiny ambiguous icons; short English footer `TERMINAL // AC-01`; simple weather icon in the spare date-column area. All are intentional native-resolution choices.

Design previews are Pillow renders of the same glyph artwork and primary grid, with illustrative values. They are not executed Monkey C frames. The native source has added live weather and settings behaviours beyond these static previews. 4× images use nearest-neighbour scaling. Forty unmasked preview combinations passed a circular-edge pixel check; this does not replace simulator layout checks.

## Typography and colours

Numeric contours are original editable JSON polygons. Secondary fonts are DejaVu Sans Condensed; 東京 is Noto Sans CJK JP Bold. Licensed subsets and provenance are in `THIRD_PARTY_NOTICES.md`. Only required resources are declared. Glyph PNG coverage is binary; there is no antialiasing or photographic background.

Palette accents: red `FF0000`, cyan `00FFFF`, white `FFFFFF`, amber `FFAA00`. Essential digits and telemetry remain white; secondary labels use `AAAAAA`; structure/inactive battery segments use `555555`; background is black. These are 4-level RGB cube candidates for the target's 64 colours. Classic Red has since been inspected in the target simulator; other palettes have native render coverage but still need equivalent visual review.

Custom text is normalized to uppercase printable ASCII (U+0020–U+007E); unsupported characters become `?`; leading/trailing spaces are removed for display. At most 64 characters are processed. Original stored Properties values are never overwritten by renderer normalization/truncation. The title tries 13px then 11px; custom subtitles use 11px. Actual Garmin DC width determines clean `...` truncation. The fixed original subtitle is 9px. Hidden removes both identity lines while retaining the alignment rule. Empty manual city falls back to Original. Empty Custom lines stay empty by choice.

## Data policy

| Field | Source | Missing/freshness policy |
|---|---|---|
| Battery | `System.getSystemStats().battery` | Null/out of 0–100 -> `--`, no lit stripe segments, `?` marker. Valid zero retained. Rounded exact percentage is authoritative. |
| Steps | `ActivityMonitor.getInfo().steps` | Null/negative -> `--`; zero valid; compact thousands floor rather than exaggerate progress. |
| HR | `ActivityMonitor.getHeartRateHistory(Duration(300), true)` | At most 8 newest entries; latest valid 1–255 sample with timestamp age 0–300 seconds; invalid sentinel ignored. Missing/future/stale -> `--`. |
| Outdoor temperature | `Weather.getCurrentConditions()` | Celsius source; follow-device or explicit C/F display. Observation timestamp required. Age 0–1h normal, >1–2h labelled `OLD`, >2h/future/null removed. Zero and negatives valid. |

Freshness limits are product choices, not Garmin guarantees. A removed watch's last valid HR may remain for up to five minutes plus minute refresh latency. A weather sample can remain up to two hours plus minute refresh latency. No watch-temperature substitution, continuous HR sensor or fabricated observations. Unknown weather gets a neutral question mark; clear/fair and common cloud conditions have small geometric icons. Other conditions currently use the neutral icon even when the cached temperature is valid.

Snapshot refresh is at most once per minute, plus settings reload. A clock rollback resets the cache. Optional reads are isolated by try/catch so weather/HR failure does not prevent the local clock. No optional user data is logged or persisted by production code. Manifest requests no GPS, Communications, Sensor, UserProfile or background permissions; production uses ActivityMonitor, not SensorHistory. Simulator execution has since been checked; physical telemetry/permission behaviour remains unvalidated.

Battery stripe: ten segments, full tens rounded down; any 1–9% gets one segment. 0% gets none. <=10% adds a white outline, exclamation and `LOW` label so colour is not the only warning. Null never appears full.

## Lifecycle and settings

`TokyoView` extends `WatchUi.WatchFace`. Minute transitions/settings/power transitions redraw the composition. Repeated active callbacks with no minute change return immediately with seconds off. Active seconds sets a small clip, clears/draws that region, and clears the clip afterwards. No timers and no continuous partial-update implementation. Low-power MIP retains the full face. No data writes occur in render callbacks.

Stable property keys and validation are in `FaceSettings`; `TokyoApp.onSettingsChanged()` reloads and requests redraw. Manual title, subtitle and city are independent fields. Settings XML exposes only implemented options. App minimum 3.2.0 supports cached weather; later targets require explicit capability/package checks.

## Automatic city investigation

`LocationLabelProvider` currently returns only manual/original/custom text. No automatic setting is exposed. Garmin's `Weather.CurrentConditions.observationLocationName` is nullable, deprecated and describes an observation area, not guaranteed current locality. Coordinates alone are not city names. A future opt-in locality resolver would need a documented coordinate source and possibly a phone/server component, explicit consent, freshness/caching/travel/disconnection rules, service cost/privacy/maintenance review, manual fallback and deletion of location cache when disabled. That separate feature does not block manual branding or the face.

## Current evidence boundary

Target compilation, actual simulator captures, native execution, memory and settings/power/clock checks are recorded in TEST_RESULTS.md. The owner now reports initial physical operation and intermittent black screens; see BLACK_SCREEN_INVESTIGATION.md. Physical MIP readability and other acceptance checks remain unvalidated. AMOLED AOD is not implemented. No battery-life claims are made.

## Primary simulator refinement — 11 September 2026

Kept the established layout after inspecting actual target captures against the right-hand concept. The 280px clock/Tokyo/plate hierarchy is crisp without redesign. Native execution revealed and fixed string-value/Unicode-character handling in settings and data sentinels; unsupported user characters still become `?`, while dedicated fixed Japanese resources are unchanged. Added explicit repeated lifecycle/cache assertions to native tests.

Actual captures live under `design/simulator/`; design renders remain separately labelled under `design/previews/`. Classic Red has direct running-face visual review. Other palettes ran in the production renderer's native matrix but still need equivalent individual visual review. The low-power mode keeps the complete MIP composition; real simulator power transitions and a live midnight change have been captured. See TEST_RESULTS for exact results and memory, rather than interpreting old setup/generic compilation records as current status.
