# TOKYO 2088 — release preparation

**Review package, not a Store launch.** Prepared 11 September 2026 on `release/store-prep`, branched from the fixed implementation at `d8a86d2332805272b6cf4f2d8fa11fb6436e4b37`. PR #2 remains unmerged and issue #1 remains open. The initial checkout was clean.

The owner reports that the redraw candidate is running on their actual fenix 8 Solar 51mm and working well so far. That is positive **initial owner feedback**, not completion of the full checklist, overnight reliability or battery testing. The owner continues normal wear through tomorrow. This preparation did not access or reinstall the physical watch.

## Current milestone: one private owner beta

The owner approves one unpaid developer-beta upload using the existing development key, **only after verifying the intended existing account and live owner-only beta setting**. No public release, new agreements, merchant fees, payment activation, production-watch replacement or PR merge is authorized.

| Stage | Current result |
| --- | --- |
| Beta package built and checked | PASS: separate stable UUID/name; shared production inputs; full notice text in both PRGs; 9 native tests pass. Exact committed export identity is in [validation](VALIDATION.md). |
| Beta uploaded privately | **One owner-submitted beta verified in Chrome.** Intended Astrobyte account; live listing marked BETA, Free, version 0.1.0 (Internal: 1), with explicit owner-only download/test notice. |
| Current blocker / next real action | No installation blocker reported. At upload verification the dashboard showed Status: Pending and an enabled Download button; account-specific details remain private. Next: owner confirms saving changed settings to the watch and restart persistence on the installed beta. |
| Store-to-phone/watch installation | **Owner-reported success, 12 September 2026:** existing owner-only beta installed on the actual watch through Android Connect IQ. |
| Phone settings screen | **Visibly loaded** with watch-face controls, per the owner's update referencing their supplied screenshot. |
| Settings transport / persistence | Saving changed settings to the watch and restart persistence **not yet confirmed**. Separate-beta fresh defaults are expected; later same-beta-UUID update retention is a different pending test. |
| Notice reader visual/device navigation | Full text and pagination pass native checks; visual UI and real watch menu navigation remain pending. |
| Wear / overnight / battery | Pending; original wrist build and private archive retained. |

Beta name **TOKYO 2088 BETA**, UUID `ca80e764ffae413996a66e11abd76ed9`. Keep this UUID/key for later beta updates. The production manifest/UUID, device profile and wrist artifact are unchanged. Concept provenance is confirmed as AI-generated during the project's ChatGPT design conversation, not from a Garmin listing; exclusive rights/trademark clearance are not asserted.

Optional wording suggestions for later: “Larger telemetry” → “Larger data text”; “Equipment footer” → “Show bottom label”. Recorded only, not implemented during this test; the current beta remains unchanged. See the [owner validation update](VALIDATION.md#owner-phonewatch-update--12-september-2026).

## Readiness checklist

| Category | Status / action |
| --- | --- |
| Already verified | Fixed source inherited; 9 native groups pass under the beta UUID, including both cleared-screen regressions, settings preservation and complete offline notice pagination. Native beta IQ export passes, with fixtures excluded. See [executed results](VALIDATION.md). |
| Already verified | One primary manifest profile; four palettes; custom/manual-city/hidden plate; no network/GPS/payment library or app permissions; real runtime artwork. |
| Completed now | Neutral custom-text/city defaults; prompts and length messages; [settings guide/test](SETTINGS.md); [listing copy](LISTING.md); [privacy/data flow](PRIVACY.md); [Windows export](WINDOWS_EXPORT.md); [artwork](../../design/store/README.md); licensing and payment comparisons; compatibility plan. |
| Completed notice delivery | Applicable full font terms are inside the new PRGs with a supported offline settings reader; native resource/pagination and byte inspection pass. Notice-reader visuals/device navigation remain pending. Historical pre-beta IQ files remain unchanged. |
| Owner decisions | Confirm Astrobyte branding/support/privacy contact; choose original-source licence, payment route/price, permanent public-release key and final version. Concept provenance and private-beta key use are now explicitly recorded. |
| Garmin account/onboarding | Existing Astrobyte developer account verified; owner personally handled the displayed agreement and final submission. Private beta entry verified. No merchant enrollment, fees or payment activation performed; public-release onboarding remains separate. |
| Physical tests pending | Beta installation is owner-reported successful. Full event checklist, extended wear, overnight reliability and comparable battery run remain pending. |
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
- [ ] Astrobyte identity, support channel/availability and privacy contact finalized; public rights/branding review completed (AI concept provenance recorded).
- [x] Full font notices included in the beta PRGs and reader tested natively; sidecars are supplementary.
- [ ] Source licence selected; real-device notice-reader navigation checked.
- [ ] Permanent key selected and recoverable private backups verified; neither previous key discarded.
- [ ] Merchant eligibility/account approved if paid; owner chooses route, price/refunds and explicitly authorizes fees/activation.
- [ ] Final version and exact supported products reviewed, including Garmin profile aliases. No untested device expansion.
- [ ] Final `.iq`, packaged PRGs, toolchain, source commit, signing provenance, artwork/captions and hashes recorded.
- [ ] Store form validates current dimensions/limits and support/privacy details; no placeholders or unsupported claims.
- [x] Owner explicitly authorizes ONE private beta, conditional on live account/access-scope verification; temporary key approved for that beta.
- [x] Live beta-only checkbox and intended account verified, then one private upload completed; resulting owner-only entry verified separately from installation.
- [ ] Owner separately authorizes the first public submission and its permanent signing key.

No automatic merge, issue closure, public Store upload, payment integration or replacement of the current wrist installation is authorized. Current private-beta status is recorded above.
