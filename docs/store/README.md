# TOKYO 2088 — release preparation

**Review package, not a Store launch.** Prepared 11 September 2026 on `release/store-prep`, branched from the fixed implementation at `d8a86d2332805272b6cf4f2d8fa11fb6436e4b37`. PR #2 remains unmerged and issue #1 remains open. The initial checkout was clean.

The owner reports that the redraw candidate is running on their actual fenix 8 Solar 51mm and working well so far. That is positive **initial owner feedback**, not completion of the full checklist, overnight reliability or battery testing. The owner continues normal wear through tomorrow. This preparation did not access or reinstall the physical watch.

## Readiness checklist

| Category | Status / action |
| --- | --- |
| Already verified | Fixed source inherited; 8 native test groups now pass, including both cleared-screen regressions and customer settings preservation; production release and native IQ export compile; package inspection excludes test/capture symbols. See [executed results](VALIDATION.md). |
| Already verified | One primary manifest profile; four palettes; custom/manual-city/hidden plate; no network/GPS/payment library or app permissions; real runtime artwork. |
| Completed now | Neutral custom-text/city defaults; prompts and length messages; [settings guide/test](SETTINGS.md); [listing copy](LISTING.md); [privacy/data flow](PRIVACY.md); [Windows export](WINDOWS_EXPORT.md); [artwork](../../design/store/README.md); licensing and payment comparisons; compatibility plan. |
| Work possible after review | Complete third-party notice delivery inside the final customer distribution, fix any review findings, assign the final version, refresh screenshots if rendering changes. Current notice sidecars are retained; Store-delivered notice availability is not yet verified. |
| Owner decisions | Confirm Astrobyte branding/support contact and concept provenance; choose original-source licence, payment route/price, permanent release key and final version. No decisions are inferred from a public repository or proposed price. |
| Garmin account/onboarding | Existing account status unknown; developer identity/contact/trader information, applicable agreements and Store-form requirements must be verified by the owner. Merchant onboarding/fees only if native paid distribution is selected. No account or merchant actions performed. |
| Physical tests pending | Full event checklist, ordinary wear through tomorrow, overnight reliability and comparable battery run. New customer-default build has simulator validation only. |
| Customer settings pending | Actual Store-installed phone → watch save/sync, restart persistence and update retention. Native callback tests do not establish phone delivery. |
| Submission gates | Owner-approved permanent key and private backup, rights/notices, support/privacy contacts, merchant approval if paid, final package/version/device review, complete testing, explicit approval for each upload/installation/payment activation. |

## Review order

1. [Customer listing and release notes](LISTING.md), [settings](SETTINGS.md), [privacy](PRIVACY.md).
2. [Payment route comparison](PAYMENTS.md), [licensing](LICENSING.md), [signing](SIGNING.md).
3. [Compatibility and tester distribution](COMPATIBILITY.md), [export workflow](WINDOWS_EXPORT.md), [actual validation](VALIDATION.md).
4. [Runtime artwork and specifications](../../design/store/README.md).

## Launch checklist — intentionally unfinished

- [ ] Owner reports extended physical results; review issue #1 and PR #2 separately.
- [ ] Final candidate has repeatable primary native, simulator and physical results; comparable battery observations recorded with settings/conditions.
- [ ] Normal customer settings workflow passes on an authorized Store-installed build.
- [ ] Astrobyte identity, support channel/availability and privacy contact finalized; concept rights resolved.
- [ ] Source licence selected; third-party notice delivery completed and checked in the actual customer payload.
- [ ] Permanent key selected and recoverable private backups verified; neither previous key discarded.
- [ ] Merchant eligibility/account approved if paid; owner chooses route, price/refunds and explicitly authorizes fees/activation.
- [ ] Final version and exact supported products reviewed, including Garmin profile aliases. No untested device expansion.
- [ ] Final `.iq`, packaged PRGs, toolchain, source commit, signing provenance, artwork/captions and hashes recorded.
- [ ] Store form validates current dimensions/limits and support/privacy details; no placeholders or unsupported claims.
- [ ] Owner explicitly authorizes first upload. A beta upload is still an upload and is not pre-approved.

No automatic merge, issue closure, Store upload, payment integration or future watch installation is scheduled by this package.
