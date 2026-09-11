# Privacy and data flow — reviewed code, draft notice

Scope: current store-preparation source, without payments. Before publication, the owner must supply the actual publisher/privacy contact and review the notice for the chosen markets. Astrobyte is proposed branding, not an established legal identity in this repository.

## Customer-facing draft

TOKYO 2088 displays information already available through your Garmin watch: local time/date, battery, steps, recent heart rate, and Garmin's cached outdoor weather. You can enter custom identity text or a manual city label through Garmin app settings.

The watch face does not send this information to Astrobyte or a custom server. It includes no analytics, advertising SDK, account system, GPS request, automatic city lookup or direct internet request. Optional readings are held in working memory for display. It does not write activity files or maintain a separate health/location history. Custom settings are stored by Garmin's application-properties system; the face reads them and derives a shortened display without overwriting your text.

Garmin's apps, services and device firmware operate under Garmin's own privacy practices. They may obtain/sync weather and settings independently of this watch face. This notice describes TOKYO 2088's code, not all processing done by the Garmin ecosystem.

Avoid putting sensitive information in your identity plate, since it is visible on the watch. Clear personal text through settings when desired; removing an app/settings is an owner action, not something this face initiates. A final privacy-contact channel is still required before publication.

No payment processor is integrated. If monetization adds a third-party service, this notice must be revised to describe its real data flow before release. Voluntary support messages are a separate flow; choose a support channel and its retention/access policy before launch. Public GitHub issues would be public, so private logs/settings should not be submitted there.

## Code audit

| Source | Input / processing | Retention / destination |
| --- | --- | --- |
| `TokyoView.onUpdate` | System clock, `Time.now`, Gregorian local date; full renderer on every full callback | Current view state; no transmission |
| `DataSnapshot.refresh` | Battery via System; steps via ActivityMonitor | In-memory snapshot, sampled at most once per 60 seconds except reload/backward time |
| Heart-rate history | Up to 8 samples within a 300-second history request; rejects invalid/nonpositive/future/older samples | One display string, not a new history database; no live sensor subscription |
| Cached weather | `Weather.getCurrentConditions`; temperature/observation time/condition | In memory; `OLD` after 1 hour, `--` after 2 hours; no use of observation location or coordinates |
| Application Properties | 12 customer settings; formatting/units/plate preferences | Garmin-managed persistent properties; production code only reads |
| `TokyoApp.onSettingsChanged` | Reloads settings, requests a redraw | No outbound communication or background job |
| Manifest/dependencies | Empty permissions and barrels; imports System, Time, ActivityMonitor, Weather, Graphics, WatchUi, Lang, Math, Application | No Communications, Position, Sensor streaming, analytics, payment SDK or custom server |

These age thresholds are product choices, not freshness guarantees from Garmin. Data can be unavailable without an error. No continuous or medical-monitoring claim is made.
