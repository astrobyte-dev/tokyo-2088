# Customer settings and verification

For a Store-installed copy, open **Connect IQ Store → Device → My Watch Faces → TOKYO 2088 → Settings**. Adjust the values, select **Save**, and allow the paired watch to sync. Garmin documents this route in its [settings instructions](https://support.garmin.com/en-NZ/?faq=TMj0wxIdjh382mBFh5rG46&searchType=noProduct). The exact labels may vary by app version.

On 12 September 2026 the owner confirmed initial beta installation through Android Connect IQ, phone settings access, and palette/custom-header delivery. The owner subsequently reports that the **existing owner-only beta updated to 0.1.1 through Connect IQ**, with **custom identity text and palette retained after updating and after a subsequent watch restart**. Both font notices opened and navigated on the physical watch, and exiting returned to the working face. Other settings, extended/overnight reliability and measured battery use remain pending. See [validation](VALIDATION.md#owner-011-update-and-final-presentation-review--12-september-2026).

| Setting / stable key | New-install default | Behaviour |
| --- | --- | --- |
| Palette / `Palette` | Classic Red (0) | Red, Cyan, Monochrome, Amber; all included. Invalid enum → 0. |
| Identity plate / `HeaderMode` | Original (0) | Original shows ASTROBYTE / INDUSTRIES; Custom uses Custom first/second line; Manual city uses City text/subtitle; Hidden hides the plate. Invalid enum → 0. |
| Custom first line / `HeaderLine1` | YOUR NAME | Custom mode only. Previously saved user text is retained. |
| Custom second line / `HeaderLine2` | PERSONAL TERMINAL | Custom mode only; blank text is allowed. |
| City text (manual) / `City` | YOUR CITY | Manual city mode only. No automatic location. Blank → Original plate. Previously saved city labels remain valid stored input. |
| City subtitle / `CitySubtitle` | LOCAL EDITION | Manual city mode only. Blank subtitle is allowed. |
| Larger data text / `Readable` | Off | Larger values where they fit; long values fall back to the smaller data font. |
| Clock format / `ClockMode` | Follow device (0) | 24-hour (1), 12-hour (2). All use watch local time. |
| Hour leading zero / `LeadingZero` | On | 08 versus 8; minutes always two digits. |
| Seconds / `Seconds` | Off (0) | While active (1); hidden in low power. No continuous-seconds option. |
| Temperature units / `TempUnits` | Follow device (0) | Celsius (1), Fahrenheit (2); Garmin cached outdoor weather only. |
| Show bottom label / `Footer` | On | Shows/hides the decorative TERMINAL // AC-01 text at the bottom of the face. |

Four text fields accept up to 64 characters in the schema. Display normalization uppercases, limits processing to 64 characters, substitutes `?` for unsupported characters and trims outer spaces. The small bitmap fonts support printable ASCII for user text. The fixed Tokyo glyphs are separate assets; arbitrary Japanese/emoji user text is not supported. Rendering measures width, uses a smaller plate font where appropriate, then ellipsis; no shortened value is written back to Properties.

The 0.1.1 settings polish changes display labels/help only: all 12 property IDs, types, enums, defaults and stored values/behaviour are preserved. Text fields remain visible in Garmin settings in every mode; the selected Identity plate mode determines which saved fields are used. No dynamic hiding is implemented. The earlier Store-prep change made new-install custom first-line/city defaults and malformed-type fallbacks neutral. Booleans still validate type; enums validate type/range. `onSettingsChanged()` reloads the face, invalidates the telemetry sample and requests an update. Source never writes or migrates customer properties.

## Normal-customer test — partial owner confirmation

`TOKYO 2088 BETA` uses UUID `ca80e764ffae413996a66e11abd76ed9`. The existing owner-only beta is now 0.1.1 by owner report; the original 0.1.0 artifacts and evidence remain preserved. The same beta UUID/key are retained. A fresh beta has its own defaults and settings, separate from the production identity; successful same-beta retention does not establish migration between different UUIDs. See [current status](README.md).

The original 0.1.0 upload-time Pending status is historical. The companion Codex task's handoff, relayed by the owner, records its directly performed/observed 0.1.1 upload: Garmin showed Status: Verified, Signature: Verified and unchanged beta manifest identity; after submission the existing listing showed version 0.1.1 (Internal: 2), BETA and explicit owner-only download/test access. The physical Connect IQ update and settings retention are separate owner-reported results. Account-specific details stay private.

Open the existing beta in **Connect IQ Store > Device > My Watch Faces > TOKYO 2088 BETA > Settings**. To replace ASTROBYTE, set Identity plate to Custom and enter the first/second lines, or choose Manual city and enter City text/subtitle. Save and sync. Palette/custom-header delivery, same-beta update retention and subsequent restart persistence are owner-reported successes. Other controls, return-from-glance and low-power behaviour remain separate observations.

The offline font-notice reader is available through the watch face's own settings/customization entry. It is separate from the unchanged 12 phone-editable settings and does not write preferences. The owner reports that both DejaVu / Arev and Noto / SIL OFL opened and navigated on the physical watch and exiting returned to the working face. This is separate from the earlier native simulator first/middle/last-page, clipping and boundary checks; exhaustive hardware page inspection and exact firmware labels were not reported.

| Step | Expected observation | Result |
| --- | --- | --- |
| Store beta installation and phone settings access | Installed beta; controls open | Owner-confirmed on actual fenix 8 Solar 51mm |
| Fresh defaults | Original plate, Red, seconds off; neutral text when switching modes | Not separately confirmed |
| Palette Save/sync | Changed palette reaches actual watch | Owner-confirmed; every palette and return-from-glance not separately confirmed |
| Custom identity/header Save/sync | Changed text reaches actual watch | Owner-confirmed; both fields individually and long-text preservation not separately confirmed |
| Manual city; city/subtitle | Manual label only; no location permission/request; blank city uses Original | Pending |
| Hidden, larger data text, bottom label | Each toggle changes only its documented content | Pending |
| 12/24/follow-watch, leading zero | Correct format at a suitable morning/noon/evening time | Pending |
| Celsius/Fahrenheit/follow-watch | Correct cached-weather units when conditions exist | Pending |
| Seconds off/while active | Visible only in active state when enabled; complete low-power face | Pending |
| Edit while face is not selected | Correct values on return, with full redraw | Pending |
| Disconnect phone after sync | Clock/plate continue; optional cached fields expire gracefully | Pending |
| Subsequent watch restart | Custom text and palette retained | Owner-reported success after the 0.1.1 update; other values and independent phone-value inspection not separately confirmed |
| Existing beta update to 0.1.1 | Custom text and palette retained | Owner-reported success through Connect IQ |
| Both physical font notices | Open, navigate and return to the face | Owner-reported success |
| Extended/overnight reliability and measured battery | Sustained observation / measurement | Untested; not inferred from retention or return to a working face |

Native `customerSettingsPreservation` covers malformed text fallbacks, prior personal strings, overlength display-only shortening, blank manual city, enum range fallback and the actual settings callback. It passed alongside all redraw tests. The compiled IQ settings schema contains all 12 keys, prompts and neutral defaults. These are local/native checks, not a phone transport test.

<a id="later-same-beta-update-retention-test--waiting-for-upload-approval"></a>

## Same-beta update-retention procedure

1. Before updating, privately record the installed beta version, current palette, Identity plate mode and complete custom first/second-line text from the phone settings. Do not change them for the test.
2. After separate approval to upload the exact candidate to the existing owner-only entry, update TOKYO 2088 BETA through Connect IQ under the same account, using the same beta UUID and retained key. **Do not uninstall**, reset app data or create a different beta entry.
3. After sync, inspect both the phone values and watch face. Record whether the exact custom strings, selected mode and palette remain; do not overwrite them before observing the result.
4. Restart the watch, reopen the beta face and phone settings, and compare again. Record update retention and restart persistence as separate owner observations. No result is presumed from simulator tests.

The 0.1.1 update, text/palette retention, subsequent restart persistence and physical notice navigation are now owner-reported successes. The steps above remain a repeatable procedure for future separately authorized updates; no further upload or installation is authorized in this local presentation pass. Keep settings values private and record each result separately.
