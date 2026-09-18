# Store copy — ready for owner review

Local presentation pass, 12 September 2026, based on reviewed beta 0.1.1. No live listing edit or public submission. Copy only the customer-facing sections below into the eventual approved listing; review notes and release gates are not customer copy. Price, public version, support/privacy contacts and publication remain owner decisions.

## Title

TOKYO 2088

## Short description

Oversized stacked time, four restrained palettes and an identity plate you can make your own.

## Full description

Oversized hours and minutes. Vertical Tokyo lettering. An industrial identity plate above a compact row of everyday data. TOKYO 2088 brings a restrained future-city look to the fenix 8 Solar 51mm MIP display.

Choose Classic Red, Neon Cyan, Monochrome or Amber. All four palettes and identity options are included in the same face.

**Make the plate yours**

Keep the original ASTROBYTE / INDUSTRIES plate, select Custom for your own first and second lines, choose Manual city for a city label and subtitle you enter yourself, or hide the plate. Manual city does not use GPS or look up your location. The clock always follows your watch's local time; the Tokyo theme does not change your timezone.

**Time and everyday data**

- Local time and date, with follow-watch, 12-hour or 24-hour format and an optional hour leading zero.
- Battery percentage and stripe, steps, recent heart rate and outdoor temperature when available.
- Seconds off by default. Choose While active to show them during the watch's active state; they disappear in low power.
- Larger data text where space permits, temperature-unit choices and an optional decorative TERMINAL // AC-01 bottom label.

Weather uses Garmin's cached outdoor conditions, not the watch's temperature sensor. Availability and freshness depend on Garmin's weather data; the face does not fetch weather itself. Missing or expired readings show `--`. Weather older than one hour is marked `OLD` and expires after two hours. Heart rate is a recent reading, not continuous monitoring. Time continues without a phone connection.

Open the face's Settings in the Connect IQ app, choose your options, then Save and sync. Select Custom or Manual city to activate the matching text fields. Text is displayed in uppercase; unsupported characters become `?`. Long text is shortened on screen without changing the saved entry. A blank city label uses the original plate.

Designed for the fenix 8 Solar 51mm, 280 × 280 MIP. Check Compatible Devices before installing. Neon Cyan is a colour name, not a glowing-screen effect; 2088 is a design mark, not the current year.

Product images are native Garmin simulator captures with simulated data, not watch photographs. Full font notices are available offline from the watch face's settings menu.

## Screenshot order and captions

Use these existing labelled canvases in this exact order. The unchanged native frames remain linked alongside each one; no new render or image regeneration is needed. The five-image review sheet is a review aid, not an extra listing slot. File-size, dimension, count and text limits still require a check in the eventual public submission form.

| Order | Existing listing canvas | Caption / alt text | Native 280 × 280 |
| --- | --- | --- | --- |
| 1 | [Classic Red](../../design/store/artwork/release-1.0.0/classic-red-final-720x840.png) | Classic Red with the original identity plate. Native simulator capture; simulated data. | [Raw](../../design/store/runtime/polish-0.1.1/classic-red-final-280.png) |
| 2 | [Neon Cyan](../../design/store/artwork/release-1.0.0/neon-cyan-720x840.png) | Neon Cyan, the same layout with a cyan accent. Native simulator capture; simulated data. | [Raw](../../design/store/runtime/polish-0.1.1/neon-cyan-280.png) |
| 3 | [Monochrome](../../design/store/artwork/release-1.0.0/monochrome-720x840.png) | Monochrome with white and grey details. Native simulator capture; simulated data. | [Raw](../../design/store/runtime/polish-0.1.1/monochrome-280.png) |
| 4 | [Amber](../../design/store/artwork/release-1.0.0/amber-720x840.png) | Amber with a warm accent. Native simulator capture; simulated data. | [Raw](../../design/store/runtime/polish-0.1.1/amber-280.png) |
| 5 | [Custom header](../../design/store/artwork/release-1.0.0/custom-header-720x840.png) | Custom plate: NIGHT SHIFT / FIELD TERMINAL, a fictional text example in Classic Red. Native simulator capture; simulated data. | [Raw](../../design/store/runtime/polish-0.1.1/custom-header-280.png) |

[Five-image review sheet](../../design/store/artwork/release-1.0.0/palettes-and-custom-review.png) · [Actual-size readability review and provenance](../../design/store/README.md#final-presentation-and-readability-review--12-september-2026)

These canvases are labelled Release 1.0.0. The underlying frames were captured from the beta 0.1.1 release binary, whose runtime source and resources are identical to 1.0.0; only the manifest identity and version differ. Manual city, active seconds and larger-data mode are explained by the copy, not represented as pictured in this screenshot set.

## Release notes — proposed first public release

- Oversized stacked time with four included palettes.
- Original, Custom, Manual city and Hidden identity plates.
- Clear settings help, optional larger data text and a decorative bottom label toggle.
- Offline DejaVu / Arev and Noto / SIL OFL notices.

## Support copy — ready after the contact channel is configured

For help, use Contact Developer and describe the problem, app version and what you were doing immediately beforehand. Keep personal identity text, serial numbers, health/location information and raw device logs out of public reports.

If a saved text field is not showing, check that Identity plate is set to Custom or Manual city, then Save and sync. `--` means the reading is unavailable; zero steps is a valid reading. If the face repeatedly blanks or fails to open, select a built-in watch face and contact support.

## Review notes — not listing copy

- Owner reports the existing owner-only beta updated to 0.1.1 through Connect IQ. Custom identity text and palette survived the update and a subsequent restart. Both notices opened and navigated on the physical watch, and exiting returned to the working face. These physical-watch results are owner reports, not a complete settings matrix. Separately, the companion Codex task's handoff records its directly performed/observed upload: Status: Verified, Signature: Verified, unchanged beta manifest identity, then the existing listing at 0.1.1 (Internal: 2), BETA and explicit owner-only download/test access.
- Overnight reliability, extended wear and measured battery use remain untested. Make no battery-life, all-conditions readability or continuous-reliability promise.
- No price, paid unlock, trial or future payment requirement is advertised here. No payment code exists. Resolve distribution/price separately in [PAYMENTS.md](PAYMENTS.md) before publication; this pass does not select a route or activate payments.
- Finalize publisher/branding, rights/source licence, real support and privacy contacts, public version and signing custody; validate the actual public package and Store form. See the [remaining release requirements](README.md#remaining-public-release-requirements).
