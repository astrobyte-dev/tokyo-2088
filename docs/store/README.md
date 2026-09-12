# TOKYO 2088 - release preparation

**Presentation review only; no public launch.** The companion Codex task's handoff confirms the completed **0.1.1 owner-only beta upload**; physical update and watch checks are **owner-reported**. Custom identity text and palette survived its Connect IQ update and a subsequent watch restart. Both font notices opened and navigated on the physical watch, and exiting returned to the working face. Overnight reliability and measured battery use remain untested.

## Current milestone: owner-tested beta 0.1.1

The companion Codex task directly performed and observed the upload, according to its handoff relayed by the owner: Garmin displayed **Status: Verified**, **Signature: Verified** and the unchanged beta manifest identity. After final submission, the existing listing showed **0.1.1 (Internal: 2)**, **BETA**, and the explicit **owner-only download/test notice**. Physical update, retention, restart and notice-navigation results below are attributed separately to the owner. Earlier 0.1.0 records remain historical evidence. No account-specific URL, personal settings or device logs are included here.

| Check | Current result |
| --- | --- |
| Beta package and native tests | Existing 0.1.1 production beta export/checker passed; 9 native groups passed, 0 failed, 0 errors. Not rebuilt or rerun during this presentation pass. |
| Portal upload and existing listing | Companion Codex handoff: package/signature Verified, unchanged beta identity; submitted listing 0.1.1 (Internal: 2), BETA, owner-only notice. |
| Connect IQ update | Owner-reported: existing owner-only beta updated to 0.1.1. |
| Phone settings access and delivery | Earlier owner-confirmed phone settings opening, palette delivery and custom-header delivery remain recorded. |
| Update retention | Owner-reported: custom identity text and palette survived the update. |
| Restart persistence | Owner-reported separately: custom identity text and palette survived a subsequent restart. |
| Physical notice navigation | Owner-reported: DejaVu / Arev and Noto / SIL OFL opened and navigated; exiting returned to the working face. |
| Other controls / comprehensive event checks | Pending; no blanket pass for all settings, every notice page, wake/glance events or every viewing condition. |
| Extended/overnight reliability | Untested. Returning to a working face is not extended reliability evidence. |
| Measured battery use | Untested; no drain or battery-life claim. |

[Executed validation and owner report](VALIDATION.md#owner-011-update-and-final-presentation-review--12-september-2026) and [structured evidence](evidence/beta-polish-0.1.1.json) keep native checks, image observations, companion portal observations and owner hardware results separate. The [settings matrix](SETTINGS.md) retains outstanding cases and the repeatable update-retention procedure.

## Preserved identities and artifacts

- Beta: **TOKYO 2088 BETA**, UUID `ca80e764ffae413996a66e11abd76ed9`, existing retained signing key. No signing-policy change.
- 0.1.1 build source: `e75af5febecfb829f0eda2a9627ba43150f222d9`; review commit: `a4719cd455c442d01f9a45fa029ae09ab48d62b2`.
- Preserved IQ: `build/windows/beta/polish-0.1.1/export-review/TOKYO2088-BETA.iq`, 59,397 bytes, SHA-256 `27522cdf71b3992ea9a7fde0927fe0d57e0e7c44eaec5f9d7dfc72cbfdfb1487`.
- Original 0.1.0 IQ copies, source/hash evidence and private signing key are retained and rechecked unchanged. Original wrist artifacts remain preserved.
- Separate production manifest/UUID `d8c8adfe21c74bdd97fa2088ac010001`, property schema, supported profile and resources are unchanged. Beta success does not imply retention across a different app UUID.

## Final presentation pass

The clean starting branch was `polish/customer-settings` at `a4719cd`; local documentation/evidence work is isolated on `polish/final-presentation`. PR #4 still targets `release/store-prep`, PR #3 targets `fix/windows-mip-redraw`, and PR #2 targets `main`. All remain open; issue #1 remains open. The owner subsequently authorized committing and pushing the eight documentation/evidence files and opening a PR against `polish/customer-settings`, stacked on PR #4. The current visual design is frozen. This handoff does not authorize code changes, rebuilding, live Store edits, signing changes, payments, merges or public publication.

[Ready-to-review Store copy](LISTING.md) explains manual city entry, optional active-state seconds and weather availability. [Screenshot order](LISTING.md#screenshot-order-and-captions): Classic Red, Neon Cyan, Monochrome, Amber, Custom header. Use the existing genuine labelled canvases with their unchanged raw captures.

[Actual-size readability review](../../design/store/README.md#final-presentation-and-readability-review--12-september-2026) found no clipping/collisions in these five 280 x 280 frames. The original subtitle and bottom labels remain small; no demonstrable visual improvement justified changing the renderer, fonts or composition. No new before/after render is claimed. All 12 setting IDs/types and runtime behaviour are unchanged.

## Remaining public-release requirements

- **Physical validation:** complete the outstanding settings/event cases, extended and overnight wear, and a comparable measured battery run with settings/conditions recorded privately. Review issue #1 separately; do not infer resolution from this limited report.
- **Publisher and rights:** confirm Astrobyte/TOKYO 2088 branding and contributor/asset rights, select the original-source licence, and finalize the real support channel and privacy contact/notice. Full font notices are packaged; physical opening/navigation is now owner-confirmed.
- **Signing and public artifact:** explicitly choose permanent public-release signing custody and verify recoverable private backups. Preserve the established beta key/UUID. Select the public version and validate its exact source/package hashes under the unchanged intended production identity and supported profile before submission; current evidence is for beta 0.1.1.
- **Distribution decision:** choose free or paid distribution. If paid, separately authorize and complete the selected payment/merchant requirements and accurate pricing/refund disclosures. No payment code or activation is introduced here.
- **Final listing review:** check live screenshot dimensions/count/size and text limits, final artwork/version-label accuracy, compatible devices and working support/privacy links. No placeholder or unsupported battery/readability claim should reach the public listing.
- **Release approval:** obtain explicit public-submission authorization and any separately required repository integration approval. No merge, issue closure, public publication or further beta upload is authorized by this presentation task.

## Review references

[Listing](LISTING.md) / [Settings](SETTINGS.md) / [Privacy](PRIVACY.md) / [Licensing](LICENSING.md) / [Signing](SIGNING.md) / [Payment decisions](PAYMENTS.md) / [Compatibility](COMPATIBILITY.md) / [Export workflow](WINDOWS_EXPORT.md) / [Validation](VALIDATION.md) / [Artwork](../../design/store/README.md)
