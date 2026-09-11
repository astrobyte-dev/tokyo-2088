# TOKYO 2088
## Design and implementation brief for Astra in VS Code

**Project:** A native Garmin Connect IQ watch face.
**Owner:** Corey / Astro.
**Primary device:** Garmin fēnix 8 Solar 51mm, round MIP display.
**Direction:** Approved. Build TOKYO 2088, not DEAD SIGNAL.
**Brief prepared:** 11 September 2026.

## 1. Your assignment

Act as the product designer, typography designer, and Garmin developer for this project. Turn the approved TOKYO 2088 concept into a beautiful, functioning, battery-conscious watch face that I can install on my actual watch.

Work in the current workspace. Inspect existing files and instructions before editing. If this is an unrelated project, create an isolated `tokyo-2088` subdirectory rather than changing that project. Make sensible, reversible decisions and start building. Do not respond with only a plan, a web mockup, or another request for me to choose a direction.

I want a product that feels like an authentic personal instrument from a fictional Japanese industrial technology company in 2088. It must retain the distinctive composition of the reference, not become a generic fitness dashboard with some red text.

Build one excellent watch face first. Do not start by constructing a general-purpose framework for six different watch faces.

## 2. Approved visual reference

The supplied image is at:

`design/reference/tokyo-2088-concept-board.png`

It contains two concepts side by side. **Only the right-hand TOKYO 2088 concept is approved.** Use the large red-accent watch as the main reference. The smaller cyan, monochrome, and amber watches are palette references. Ignore the DEAD SIGNAL half.

The image is mood and composition guidance, not a production asset or an accurate representation of my display. Rebuild the watch face as real dynamic interface elements. Do not crop the image into a background, copy the surrounding watch hardware, reproduce generated spelling errors, or treat the illustrated sensor readings as real data.

If the image is not accessible, state that briefly and proceed using the specification below. Do not pretend to have inspected it.

### Preserve this visual identity

- Very large, condensed, stacked hours and minutes. The time is the hero.
- Vertical red `東` above `京` on the left, with the small fictional model-year mark `2088` below.
- Compact weekday, day, and month column to the right of the time.
- A small two-line identity plate above the time. This is customizable.
- A restrained diagonal-stripe motif on the right, preferably functioning as a battery indicator.
- A compact telemetry row below the time, followed by a very small optional footer.

The impression should be late-1980s Japanese industrial futurism: equipment labels, precision typography, manufactured hardware, and restrained asymmetry. Black background, strong light numerals, red structural accents, and intentional negative space.

Do not introduce skulls, constant glitches, rainbow gradients, bulky complication circles, animated cityscapes, copied franchise logos, or tiny decorative text everywhere. Avoid anything that makes the time harder to read.

## 3. Device facts and expansion strategy

Garmin's current device reference identifies my model as follows [1]:

| Property | Primary target |
| --- | --- |
| Product ID | `fenix8solar51mm` |
| Display | Round, 280 × 280 pixels |
| Technology | MIP, 64 display colours |
| Watch-face application memory limit | 131,072 bytes |
| Physical testing | This is the only watch I own for testing |

Verify these against the installed device package before compiling. Do not accidentally select the fēnix 8 AMOLED 51mm profile. The larger watch case does not mean a 454-pixel MIP screen.

**MIP is the lead design, not a reduced-quality export of an AMOLED design.** Every important element must work at native 280 × 280 resolution without glow, soft shadows, or photographic texture.

After the first target works, use the same application with explicit layout/resource profiles for a small initial expansion set [2]:

| Candidate | Purpose |
| --- | --- |
| fēnix 8 Solar 47mm, 260 × 260 MIP | Smaller MIP layout |
| fēnix 7X or Enduro 2, 280 × 280 MIP | Earlier-generation capability check |
| fēnix 8 AMOLED 47mm/51mm, 454 × 454 | AMOLED rendering and always-on mode |

Discover each exact product ID and supported API level from Garmin's device packages. Do not invent IDs or enable all watches just because a round layout scales. Keep 240-pixel MIP and other AMOLED sizes as later expansion candidates, not first-build obligations.

Maintain separate compatibility statuses: planned, compiled, simulator-tested, physically tested. My primary device is initially available for physical testing, not already tested. Only mark hardware testing complete after I provide results.

## 4. Layout, typography, and visual quality

### Layout hierarchy

Use a 280-pixel logical design grid for the primary composition, then deliberate per-resolution tuning. Respect the actual circular safe area, especially around the top plate and bottom telemetry. Do not simply scale all coordinates and fonts uniformly.

A structural sketch, not final spacing or type:

    ASTROBYTE
    INDUSTRIES

    東       08      FRI
    京       27       11
    2088             SEP
                     ////

       74%    68    6.4K    11°
         PERSONAL TERMINAL // AC-01

The clock uses the watch's local time. The Tokyo theme does not switch it to Japanese time. `2088` is a fixed fictional design mark, not the current calendar year.

The two time rows should look like one custom instrument, with consistent digit widths and strong optical alignment. Prototype at `08:27`, but check difficult combinations including `11:11`, `00:00`, `12:59`, and `23:59`.

### Fonts and graphics

Create an original condensed numeric treatment or use a suitably licensed typeface with documented provenance. Use a crisp, readable secondary face for data and settings-driven text. Generate only the glyph subsets and sizes required by each target. Keep editable asset sources and reproducible generation scripts.

The fixed Japanese identity must render correctly regardless of the watch's interface language. Use a tiny dedicated glyph subset or original static artwork for `東` and `京` rather than assuming universal system-font coverage. Document the source and licensing of any third-party glyph artwork.

Do not load a full Japanese font to display two characters. Do not invent additional Japanese slogans. An optional Japanese footer can come later after its wording and legibility are checked; an English equipment label is sufficient for v1.

Custom user text needs a documented supported character set and sensible fallback. Measure actual rendered width. Reduce within a readable size range, then truncate cleanly or omit the subtitle. Never squash lettering horizontally or shrink it into illegibility to fit.

### Palette and finish

Provide four coordinated presets: **Classic Red** as the default, **Neon Cyan**, **Monochrome**, and **Amber**. Palette names describe the style, not a promise of emissive neon on MIP. Map each preset to real supported display colours and inspect it in the target simulator.

Keep essential time and telemetry high contrast. Saturated accents are for identity and structure, not the only way to communicate a warning. A clean typography finish is the default. Very light static distress can be an optional later finish, but it must not eat away useful digit strokes.

The side stripe should show a truthful battery fraction and become visually distinct at low charge. Missing battery data must not appear as a full battery. Exact numbers elsewhere remain authoritative if the stripe is coarsely segmented.

## 5. The customizable identity plate

The small `ASTROBYTE / INDUSTRIES` area is a personalization slot, not permanently baked into a bitmap. Keep the `東京 / 2088` identity separate so the design remains recognizable.

Implement these v1 modes through app settings:

| Mode | Example | Behaviour |
| --- | --- | --- |
| Original | `ASTROBYTE` / `INDUSTRIES` | Default reference branding |
| Custom | `COREY` / `PERSONAL TERMINAL` | Editable first and second lines |
| Manual city | `HOBART` / `LOCAL EDITION` | User-entered city and editable subtitle |
| Hidden | No plate | Intentional clean layout, not an awkward hole |

These are examples, not restrictions. Other users must not be forced to display my name, my city, or my branding. Preserve their settings across updates. Store full text where practical and derive a display-safe shortened version; do not silently overwrite the user's original input.

### Optional automatic city: investigate, do not fake

I like the idea of the plate reflecting the user's location, but this must not delay the core face.

Garmin currently marks `Weather.CurrentConditions.observationLocationName` as deprecated and potentially removable after System 11. It can also be null. It describes a weather observation location, not a guaranteed live city fix [7]. Do not build a mandatory feature around it or relabel a weather station as the user's exact current city.

Implement manual city first. Keep a small `LocationLabelProvider` boundary so automatic city can be added without redesigning the renderer.

Investigate an officially supported, permission-appropriate source. Distinguish cached weather-area text, cached coordinates, and a genuine resolved locality. If resolving coordinates requires an external service or companion component, document that as a separate optional feature with its privacy, cost, maintenance, and battery implications.

Do not add a background GPS loop, quietly transmit coordinates, introduce a paid API, or require a companion app for the basic watch face. Do not show an enabled automatic-city setting until it genuinely works.

For a later opt-in implementation, define freshness, caching, missing permissions, travel updates, disconnection, and deletion behaviour. Use manual city or original branding when automatic information is missing or too old. Stop optional processing and clear its stored location cache when disabled. Do not invent live location or GPS-status indicators.

## 6. Real data and settings

### v1 data

Display local hours and minutes, weekday/day/month, battery percentage, steps, a recent valid heart-rate value, and current cached outdoor temperature with a simple weather icon where available.

Use documented, target-supported Connect IQ sources. Verify the method signatures, permissions, units, and null behaviour before using them. Useful starting points are `System.getDeviceSettings()` for clock/unit preferences and phone connection, `System.getSystemStats()` for battery, `ActivityMonitor.getInfo()` for daily activity, bounded recent heart-rate history, and `Weather.getCurrentConditions()` for cached weather [6][8][9][10].

Do not assume a one-second redraw supplies a new heart-rate sample. Do not start continuous sensors just to animate the face. Treat heart rate as the latest valid sample, with age checks. Never use the watch's on-wrist temperature sensor as if it were outdoor air temperature.

Centralize missing/stale handling. `--` means unavailable, while zero remains a valid value for metrics such as steps or temperature. Weather should keep functioning as an optional field, not prevent the clock from rendering. Unknown weather conditions need a neutral fallback icon.

Define conservative, documented freshness thresholds as product choices, not Garmin guarantees. Show stale weather differently or remove the value after expiry. Do not keep an old heart-rate reading visible indefinitely after the watch is removed.

Keep the compact row readable. If four fields do not fit at native size, use a deliberate two-row arrangement or compact numeric notation before shrinking the font. Check negative temperatures, three-digit heart rates, `100%`, and five/six-digit step totals.

### v1 settings

Provide palette, header mode/text, a clean/readable layout option, 12/24-hour preference with a follow-device default, leading-zero preference, seconds mode, temperature units with a follow-device default, and footer visibility. Add a controlled choice of implemented metrics to telemetry slots if it remains simple.

Do not expose long menus of unsupported metrics. Defer Body Battery, stress, training readiness, live altitude, complication shortcuts, and other advanced fields until watch-face access is verified for each target. Never synthesize these values from unrelated inputs.

Support settings changes without reinstalling, validate malformed or old values, and use stable defaults [11]. The basic face must not depend on taps, swipes, or on-watch text entry. Settings available through the supported Garmin settings flow are sufficient for v1; on-device editing is an optional extension.

## 7. Power behaviour: separate MIP and AMOLED

Follow the real WatchFace lifecycle. Garmin documents minute updates in low-power mode, active-mode callbacks, and constrained partial updates on supported devices [4]. Use those facilities, not a permanent animation timer.

### Primary MIP behaviour

Keep the core design visible in normal low-power operation. Do not strip my MIP face to a tiny AMOLED-style clock. Refresh minute-level information when needed and cache data/formatting appropriately.

Default seconds to **Off** for the first hardware build. Add **While active** as the first optional mode. Continuous seconds may be offered later only on supported MIP targets after implementing a small clipped `onPartialUpdate()` region and measuring its budget. Restore clipping after the partial draw and handle budget-exceeded conditions safely [4].

No full-screen redraw every second. No flashing background, blinking separator by default, scrolling city name, or continuous random texture generation. Precompute geometry and stable assets. Avoid unnecessary allocations and persistent-storage writes inside render callbacks.

### AMOLED expansion

Use a separate low-power/AOD layout with reduced content and thin or appropriately reduced time graphics. Preserve the identity without carrying the entire filled, bright hero-clock design into AOD.

Garmin's rules vary by generation and include burn-in protection and luminance constraints. Verify the selected product's requirements and use the applicable simulator checks [5]. Do not apply one old rule indiscriminately to every AMOLED model. Moving large filled digits a pixel or two is not, by itself, proof of compliance.

Respect display-off mode. Do not force the screen, backlight, or brightness on. Suspend optional motion outside supported active states.

## 8. Implementation expectations

Build a native **Monkey C / Connect IQ Watch Face**, using Garmin's official toolchain and VS Code extension [3]. A browser renderer can be a supplementary design tool, never the deliverable in place of a real watch face.

Inspect the OS, available SDK, Java/tool requirements, device packages, and developer signing-key setup. Record exact versions actually used. Garmin's SDK page listed 9.2.0 on 11 September 2026; recheck before installation. The SDK release number is not the same thing as the application's minimum API level [3]. Choose the minimum API from actual features and target compatibility.

Use clear boundaries for drawing, settings, data snapshots, display profiles, and the optional location label. Prefer a small implementation over a speculative framework. Capability-check APIs and resources where necessary, and exclude unsupported features at build time when runtime checks are insufficient.

Suggested project contents, adapting to the real toolchain:

    manifest.xml
    monkey.jungle
    source/
    resources/
    assets-src/
    tools/
    tests/
    design/reference/
    design/previews/
    docs/BUILD_AND_TEST.md
    docs/DEVICE_SUPPORT.md
    docs/DESIGN_DECISIONS.md
    README.md
    THIRD_PARTY_NOTICES.md
    .gitignore

Configure reproducible build/run tasks for the primary target and a small device matrix. Keep machine-specific SDK paths and private signing keys out of tracked configuration. Never overwrite an existing key, commit secrets, upload health/location data, or publish the project/store listing without my explicit instruction.

Keep the supplied concept board as a reference only, not a bundled runtime resource. Use original or appropriately licensed assets and record provenance. Do not copy Garmin's logo or another watch face's proprietary assets into this design.

## 9. Execution order

### Stage A: design and first working slice

Inspect the workspace and toolchain, then produce a native 280 × 280 first slice with the real clock, vertical Tokyo mark, date, original identity plate, and correct red palette. Derive two closely related previews: reference-faithful and readability-first. Select the stronger one and continue without waiting for an aesthetic questionnaire.

Generate flat face previews at native resolution and enlarged nearest-neighbour views. Label previews clearly as design renders or actual simulator captures. A glossy device mockup is not evidence that the native face works.

### Stage B: usable primary-device build

Finish data handling, personalization, palettes, settings, power transitions, and fallbacks. Build an installable `.prg` for `fenix8solar51mm`. Give me exact local build/run and sideload instructions, including a safe way to revert to another face.

### Stage C: controlled expansion and polish

Compile and inspect the smaller MIP target and the 454-pixel AMOLED target. Add the earlier-generation MIP target when capabilities are verified. Complete AOD testing before claiming AMOLED support. Do not sacrifice the primary MIP design to make the matrix larger.

If a toolchain, permission, network, or signing dependency prevents a stage, identify the exact blocker and continue with independent work. Do not fabricate binaries, passing tests, screenshots, or measurements. Do not hide an unfinished stage behind a finished-looking mockup.

## 10. Acceptance tests

Test the real renderer and data formatting, not just helper code. Keep results concise and reproducible.

| Area | Required checks |
| --- | --- |
| Time/date | Midnight/noon, 12/24-hour modes, leading zero, date/month/year rollover, timezone/DST changes without double offsets |
| Data | Missing/invalid/stale HR, missing weather, unknown weather icon, negative temperatures, valid zeros, large step counts, battery 0/1/9/10/99/100% |
| Header | Original/custom/manual city/hidden, blank text, long city, mixed supported glyphs, unsupported glyph fallback, settings changes after reload |
| Layout | Native-size legibility, round-edge clipping, all palettes, difficult digit combinations, primary and alternate resolutions |
| Power | Active/sleep transitions, optional seconds, clipping reset, no low-power animation loops, applicable AMOLED AOD and display-off tests |
| Resources | Peak measured memory with worst-case settings, repeated wake/settings cycles, missing asset protection, release build warnings |
| Offline | No phone/weather/location available; correct local clock and graceful optional-field fallback |

Simulator checks cannot establish real battery life or real-world MIP readability. Provide a short physical-test checklist for me: indoor light, daylight, backlight, normal glance distance, overnight use, and a comparable battery run against my usual face with the same watch settings.

Record settings and conditions when comparing battery use. Do not promise a specific number of days or a drain percentage without measurements. Do not mark physical tests as passed on my behalf.

## 11. First handoff requirements

Provide the working source, editable asset sources, build configuration, actual native previews, the primary-target binary if compilation/signing succeeded, a tested-device matrix, and practical setup/sideload instructions. Include test results, measured resource use, known limitations, and a short explanation of any visual deviations from the reference.

The end-of-session summary should distinguish what is implemented, what was actually run, what was only inspected, and what is blocked. Link to the files in the workspace. Do not label the whole product production-ready after only a simulator screenshot.

The first meaningful success is a recognizable, good-looking TOKYO 2088 face running in the primary simulator and ready for my watch. Optional auto-city, advanced metrics, elaborate motion, monetization, and broad store distribution must not delay that.

**Start by inspecting the reference and workspace, then build the first working MIP version.**

## 12. Official references

These sources were checked on 11 September 2026. Revalidate APIs and device packages during implementation. Where documentation and the installed target differ, document the discrepancy rather than guessing.

[1]: https://developer.garmin.com/connect-iq/device-reference/fenix8solar51mm/ "Primary device ID, resolution, colours, and watch-face memory limit"
[2]: https://developer.garmin.com/connect-iq/compatible-devices/ "Device display technologies, resolutions, and supported API levels"
[3]: https://developer.garmin.com/connect-iq/sdk/ "Official SDK and VS Code setup"
[4]: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html "Watch-face lifecycle and partial updates"
[5]: https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/ "AMOLED AOD, luminance, and burn-in guidance"
[6]: https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html "Cached weather access"
[7]: https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/CurrentConditions.html "Weather values and deprecated observation location name"
[8]: https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor.html "Activity data and heart-rate history"
[9]: https://developer.garmin.com/connect-iq/api-docs/Toybox/System/Stats.html "Battery and system statistics"
[10]: https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html "Clock, unit, connection, and display-related device settings"
[11]: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Properties.html "Persistent application properties"
