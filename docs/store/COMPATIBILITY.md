# Controlled device and tester plan

The launch baseline remains **fenix 8 Solar 51mm, 280 × 280 MIP**. The owner's device is the only physical test device. Its initial feedback applies to the preserved redraw candidate; extended wear and battery results remain pending. No new device was enabled by this branch.

## Installed official profiles

Read from Garmin's installed device profiles on 11 September 2026. [Sanitized profile evidence](evidence/device-profiles.json) records exact profile versions, file hashes, product aliases, API and firmware fields. These describe compiler targets, not private connected-device identifiers or measured hardware capacity.

| Profile | Screen / display | Profile API | Watch-face memory limit | Proposed disposition |
| --- | --- | --- | --- | --- |
| `fenix8solar51mm` | 280 × 280 MIP | 6.0 | 131,072 bytes | Existing primary; native tests, simulator and initial owner feedback |
| `enduro3` | 280 × 280 MIP | 6.0 | 131,072 bytes | First additional target to qualify; not enabled or tested |
| `fenix7x` | 280 × 280 MIP | 5.2 | 131,072 bytes | Second additional profile; inspect aliases and older-API behavior; not enabled or tested |
| `fenix8solar47mm` | 260 × 260 MIP | 6.0 | 131,072 bytes | Later deliberate layout/resource adaptation; current fixed coordinates are not qualified |
| `fenix847mm` | 454 × 454 AMOLED | 6.0 | 131,072 bytes | Separate project phase: layout/assets plus AMOLED low-power/AOD and burn-in requirements |

**Aliases matter.** The unchanged primary profile generates parts `006-B4533-00` and `006-B4776-00`, displayed by Garmin as fenix 8 Solar 51mm / tactix 8 Solar 51mm. Native export creates identical programs for both parts. This is not evidence of physical tactix testing. Inspect the final Store Compatible Devices list and obtain an owner decision on this profile alias before upload; do not hand-edit the signed archive to filter it.

The `fenix7x` profile similarly covers fenix 7X, tactix 7, quatix 7X Solar and Enduro 2. Qualifying a representative rendering profile does not justify claiming every alias has physical results. The manifest's minimum API remains 3.2.0, while the installed profile/export imposes its own supported firmware/API metadata; neither number proves behavior on old firmware.

## Qualification sequence

1. For each proposed profile, review its APIs, fonts/graphics support, firmware and memory against actual code. Build into a separate device-specific folder with explicit signing provenance.
2. Run formatting, settings, all palettes/plates and both same-minute cleared-surface regressions. Inspect clipped text, large data, missing/old readings, wake/sleep, seconds and date boundaries at native size.
3. Measure runtime memory and update cost on that simulator; results are not physical battery measurements.
4. Recruit an owner of the exact model, provide a positively identified signed PRG and checksum with supported sideload instructions and a built-in-face fallback. Obtain installation consent; preserve their settings and original artifact where possible. Never share a key or account.
5. Collect initial and overnight feedback, then a comparable battery observation with seconds mode, firmware, display/phone/use conditions and duration. Keep raw/private data out of public issues. Enable the target in a separate reviewed change only after evidence is adequate.

## Payment compatibility is a separate check

Garmin's published native paid-app list includes fenix 8 Solar 51mm, Enduro 3, fenix 7X/Enduro 2, fenix 8 Solar 47mm and fenix 8 AMOLED sizes. This does not prove rendering, every profile alias, seller approval or every buyer's firmware/region. Recheck exact aliases and the live checkout compatibility at release time. KiezelPay library/device compatibility is unverified because no integration has been approved. [Garmin app sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)

## Supported tester distribution

Garmin's developer **beta listing is private to the uploading account**. Its URLs are not accessible outside that account, and beta staging requires an alternate manifest app ID. It is useful for the owner's own Store/settings pipeline, **not an invitation-link beta for arbitrary testers**. No beta UUID or upload was created. [Official beta rules](https://developer.garmin.com/connect-iq/core-topics/beta-apps/)

For outside owners before public release, use an authorized **device-specific signed PRG sideload** through visible `GARMIN/Apps`, following Garmin's documented running-on-device procedure. An IQ export is a Store package, not the PRG to copy to a watch. Device import behavior can rename/hide programs; identify existing applications, avoid duplicate filenames, and report checksum-readback limitations honestly. Do not access hidden storage or delete settings to force replacement. [Garmin running-on-device/signing](https://developer.garmin.com/connect-iq/core-topics/security/), [first-app device procedure](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/)

Sideload testing does not establish the normal phone settings flow. A wider Store-distributed test would require a separately approved submission/review and accurate public availability/testing disclosures. During review Garmin documents self-download for the submitting owner; do not promise outside access. [Publishing rules](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/)
