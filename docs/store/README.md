# TOKYO 2088 - release preparation

## Submitted to the Store — 19 September 2026

**Public 1.0.0 submitted as a paid app (KiezelPay, 24-hour trial, one-time US$2.50).** Listing `cf802fe8-f538-4922-b1b0-2825e40d90c6`, app UUID `d8c8adfe21c74bdd97fa2088ac010001`, package `TOKYO2088.iq` 72,333 bytes, SHA-256 `cf19ddad7efb922aa406e24c4ccfc7aa6544af4423aa256e853855d1d984aa29`, signed with the dedicated permanent public key (SPKI SHA-256 `5fcd2fb8…`). Status: App pending; Garmin review takes up to three days. Form values: Digital; privacy Yes with the main-branch PRIVACY.md URL; Monetization Yes, Other, Third-Party Payments; App Migration No. The upload form showed `Signature check failed.` in its green panel, which is Garmin's acknowledged bug CIQQA-4716 for first uploads; submission proceeded and was accepted into review.

The submitted package and its evidence were produced by the companion Codex track (12 to 16 September 2026) outside this repository. Its source is preserved on branch `codex/public-kiezelpay` (commits `e00816e`, `c25bad0` on top of `ce1dee3`); merge it into main to make the repository match the published app. The KiezelPay barrel, product configuration and signing keys stay in ignored private folders. [Structured record](evidence/store-submission-1.0.0.json).

The payment-free 1.0.0 exports made earlier the same day (retired-ID and fresh-ID packages) were not submitted; the fresh ID `92f2e364b0f34a829a8e350ce8f88f86` now simply identifies the payment-free internal build of `manifest.xml`, distinct from the published app.

## Public release 1.0.0 — prepared 19 September 2026

Production `manifest.xml` is now version **1.0.0** under a fresh production UUID `92f2e364b0f34a829a8e350ce8f88f86`. The earlier production ID `d8c8adfe21c74bdd97fa2088ac010001` was never published; on 19 September 2026 the Store upload form reported `Signature check failed` for a 1.0.0 package under that ID, signed with the same key Garmin had verified for the beta. That ID had only ever existed on the watch as the original Linux-signed sideload, so it was retired rather than debugged. Runtime source and resources are identical to the owner-tested beta 0.1.1 (source commit `e75af5febecfb829f0eda2a9627ba43150f222d9`); only the manifest identity and version differ. Release and test builds compiled with no warnings on SDK 9.1.0 and all 9 native test groups passed on 19 September 2026. Release-labelled screenshot canvases are under `design/store/artwork/release-1.0.0/` and the [listing copy](LISTING.md) points at them.

**Signed public package exported 19 September 2026 (fresh ID):** `build/windows/store-prep/release-1.0.0-newid/TOKYO2088-store-prep.iq`, 59,441 bytes, SHA-256 `66447c1e9f1921e2e1847c469ee9d98368debf718c0f112ed32da61f4f7e0938`; each packaged PRG 37,052 bytes, SHA-256 `705398cae4cd24fc19ed8123cf79bb325845373c04062e32914393334f0fce86`. Native export and package checker both exit 0. Signed with the same key as the owner-tested beta (identical packaged public key). The earlier same-day export under the retired ID (IQ SHA-256 `23abdd36…`) is superseded. [Structured evidence](evidence/release-1.0.0.json).

Owner decisions still recorded at upload time: publisher/support contact, free or paid distribution, and confirming the existing signing key as the permanent Store key with a recoverable backup. The owner reports continuous wear since 11 September 2026 with no black-screen recurrence on the full-repaint builds, and a read-only inspection of the watch on 19 September found no Connect IQ error log entry for TOKYO 2088 ([evidence](VALIDATION.md#hardware-wear-and-device-log-evidence--19-september-2026)). Battery use is still not measured.

The sections below are the preserved beta 0.1.1 record.

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
