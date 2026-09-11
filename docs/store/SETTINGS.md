# Customer settings and verification

For a Store-installed copy, open **Connect IQ Store → Device → My Watch Faces → TOKYO 2088 → Settings**. Adjust the values, select **Save**, and allow the paired watch to sync. Garmin documents this route in its [settings instructions](https://support.garmin.com/en-NZ/?faq=TMj0wxIdjh382mBFh5rG46&searchType=noProduct). The exact labels may vary by app version.

This normal phone-to-watch workflow has **not** been exercised for TOKYO 2088. The current watch build remains untouched. Garmin notes that its normal configurable-content flow applies to Store-downloaded content; sideloading is not a substitute for validating it. [Garmin Connect settings](https://support.garmin.com/en-PH/?faq=SPo0TFvhQO04O36Y5TYRh5).

| Setting / stable key | New-install default | Behaviour |
| --- | --- | --- |
| Palette / `Palette` | Classic Red (0) | Red, Cyan, Monochrome, Amber; all included. Invalid enum → 0. |
| Identity plate / `HeaderMode` | Original (0) | Astrobyte / Industries, Custom, Manual city, Hidden. Invalid enum → 0. |
| Custom first line / `HeaderLine1` | YOUR NAME | Custom mode only. Existing COREY or any user text is retained. |
| Custom second line / `HeaderLine2` | PERSONAL TERMINAL | Custom mode only; blank text is allowed. |
| City text (manual) / `City` | YOUR CITY | Manual city mode only. No automatic location. Blank → Original plate. Existing HOBART remains valid stored input. |
| City subtitle / `CitySubtitle` | LOCAL EDITION | Manual city mode only. Blank subtitle is allowed. |
| Larger telemetry / `Readable` | Off | Larger values where they fit; long values fall back to the smaller data font. |
| Clock format / `ClockMode` | Follow device (0) | 24-hour (1), 12-hour (2). All use watch local time. |
| Hour leading zero / `LeadingZero` | On | 08 versus 8; minutes always two digits. |
| Seconds / `Seconds` | Off (0) | While active (1); hidden in low power. No continuous-seconds option. |
| Temperature units / `TempUnits` | Follow device (0) | Celsius (1), Fahrenheit (2); Garmin cached outdoor weather only. |
| Equipment footer / `Footer` | On | Decorative TERMINAL // AC-01 label. |

Four text fields accept up to 64 characters in the schema. Display normalization uppercases, limits processing to 64 characters, substitutes `?` for unsupported characters and trims outer spaces. The small bitmap fonts support printable ASCII for user text. The fixed Tokyo glyphs are separate assets; arbitrary Japanese/emoji user text is not supported. Rendering measures width, uses a smaller plate font where appropriate, then ellipsis; no shortened value is written back to Properties.

No property IDs/types or enum meanings changed. Only the custom first-line/city packaged defaults and malformed-type fallbacks became neutral. Booleans still validate type; enums validate type/range. `onSettingsChanged()` reloads the face, invalidates the telemetry sample and requests an update. Source never writes or migrates customer properties.

## Prepared normal-customer test — not yet run

Run only on an explicitly authorized Store-installed build after the current wear trial. A developer beta requires its own manifest ID and is private to the uploading account; see [distribution plan](COMPATIBILITY.md). No beta ID or upload has been created here.

| Step | Expected observation | Result |
| --- | --- | --- |
| Fresh Store install | Original plate, Red, seconds off; neutral text when switching modes | Pending |
| Select each palette, Save/sync | Same layout, correct accent; survives returning from a glance | Pending |
| Custom mode; edit both lines | Entered text displayed; long text abbreviated without changing stored input | Pending |
| Manual city; city/subtitle | Manual label only; no location permission/request; blank city uses Original | Pending |
| Hidden, readable, footer | Each toggle changes only its documented content | Pending |
| 12/24/follow-watch, leading zero | Correct format at a suitable morning/noon/evening time | Pending |
| Celsius/Fahrenheit/follow-watch | Correct cached-weather units when conditions exist | Pending |
| Seconds off/while active | Visible only in active state when enabled; complete low-power face | Pending |
| Edit while face is not selected | Correct values on return, with full redraw | Pending |
| Disconnect phone after sync | Clock/plate continue; optional cached fields expire gracefully | Pending |
| Reopen settings and restart face/watch | Saved values remain; no reinstall required | Pending |
| Authorized same-UUID, same-key Store update | Prior custom strings/enums retained | Pending |

Native `customerSettingsPreservation` covers malformed text fallbacks, prior personal strings, overlength display-only shortening, blank manual city, enum range fallback and the actual settings callback. It passed alongside all redraw tests. The compiled IQ settings schema contains all 12 keys, prompts and neutral defaults. These are local/native checks, not a phone transport test.
