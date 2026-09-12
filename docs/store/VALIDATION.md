# Executed release-preparation validation

## Private beta preparation — current milestone

The beta source uses separate UUID `ca80e764ffae413996a66e11abd76ed9` and name TOKYO 2088 BETA with the same primary profile, runtime renderer/resources and 12 phone properties. The new offline font-notice reader is reached only through Garmin's separate settings entry point. The production manifest and preserved wrist binary remain unchanged.

Native Windows beta run: **9 passed, 0 failed, 0 errors; launcher exit 0**. The prior eight groups remain passing and `fontNoticeDelivery` verifies resource loading, all pages, complete text reconstruction and page boundaries. DejaVu/Arev is 4,763 characters / 41 pages; Noto/OFL is 4,243 characters / 37 pages. Initial development checks caught a notice-extraction error and strict release initialization error; both were fixed before the passing run and checked export.

Logs: `build/windows/beta/validation-final/`. Renderer matrix sampled 34,752 bytes, power-cycle fixture 34,120 and repeated-update fixture 34,480; 240 fixed-time updates took 1,875ms in each seconds mode with one telemetry refresh. These are simulator samples/timings, not hardware peak-memory or battery measurements.

The beta package checker verifies the alternate identity, primary profile only, original property schema, excluded fixtures and the complete applicable licence text **inside each PRG**. Final export was built from clean commit `c5c54b968cd812b69957b166012f16273a335e4c`, signed with the retained temporary Windows development key. No key was generated or adopted for public release.

- IQ: `build/windows/beta/export-owner-1/TOKYO2088-BETA.iq`, **58,738 bytes**.
- IQ SHA-256: `cb5f5e6d3ba6bcb730c8421df84478d819e51c61ad41cc9384fbc40b3901738d`.
- Each packaged PRG: **36,540 bytes**, SHA-256 `ac462d3575e37c866e47fedaf0ddbd56ec817b1db5836b800604983d4f6fe726`, matching the standalone beta release.
- Native export/checker exit 0; existing-export and production-candidate-folder rejection guards pass. Complete resource text is verified in both primary-profile part entries.
- A hash-verified private local IQ copy and resumable upload-status record are retained outside Git/cloud-sync. **One private beta entry is now verified.** Exact entry URL, private location and key reference stay in the local record.
- [Sanitized beta evidence](evidence/beta-owner-1.json). The evidence follow-up also makes the host text check tolerate Git's CRLF conversion; it does not change runtime/package inputs or generate another beta.

**Private upload completed and verified on 11 September 2026.** Chrome showed the intended Astrobyte account and the selected testing-only checkbox with Garmin's explicit owner-only download/test notice. The unchanged IQ size/hash matched this record before upload. Garmin verified the package and signature, expected beta manifest UUID and version 0.1.0. The owner personally handled the agreement and final Submit action. The resulting listing shows BETA, Free, version 0.1.0 (Internal: 1), the owner-only notice and an enabled Download button; the dashboard shows one beta entry with Status: Pending. That status is recorded as displayed, not represented as public approval or physical installation. The exact entry URL is private.

Prepared cover, hero and labelled native simulator screenshot were accepted into the listing. Automatic device migration and review email notifications are off; monetization was No. No package rebuild, key change, merchant flow, fee, public release or watch operation occurred during that upload session. The retained temporary key remains private and is approved for this beta only.

### Owner phone/watch update — 12 September 2026

| Check | Recorded result |
| --- | --- |
| Store-to-phone/watch installation | **Owner-reported success.** The owner reports the existing owner-only beta installed on their actual watch through the Android Connect IQ app. |
| Phone settings screen | **Visibly loaded**, displaying the watch-face controls, per the owner's update referencing their supplied screenshot. |
| Saving changed settings to the watch | **Not yet confirmed.** Opening the settings screen does not establish save/sync delivery. |
| Restart persistence | **Not yet confirmed.** |
| Font-notice reader visuals/device navigation | **Pending.** The phone controls screenshot does not validate the separate notice reader. |
| Extended wear and battery observations | **Pending.** |

This update records owner feedback only; the current beta and its recorded artifact identity are unchanged. No rebuild, reinstall, upload or public release was performed for this update. Later same-beta-UUID update retention remains a separate pending test.

Optional customer-facing wording suggestions for later: “Larger telemetry” → “Larger data text”; “Equipment footer” → “Show bottom label”. These suggestions are deferred and **not implemented during this test**.

## Historical Store-preparation export (preserved)

Executed on native Windows, 11 September 2026, using the installed Connect IQ SDK 9.1.0 (`2026-03-09-6a872a80b`) and primary `fenix8solar51mm` profile. No SDK or watch firmware was changed. Final committed export identity is recorded below.

## Tests and runtime

- **8 native test groups passed, 0 failed, 0 errors; launcher exit 0.** Groups: customerSettingsPreservation, formatting, headerSettings, rendererMatrix, repeatedPowerCycles, resetSurfaceSecondsOff, resetSurfaceSecondsOn, repeatedUpdateCost.
- Both same-minute surface-reset regressions remain passing after neutral-default/settings changes. The inherited redraw implementation is unchanged.
- Customer test verifies malformed-type neutral fallbacks, legacy stored strings, long-text display-only shortening, blank manual city, enum fallbacks and the actual application settings-change callback. Static/compiled schema checks establish the packaged fresh defaults and all 12 prompts/keys. Phone transport is not tested.
- The initial customer-test draft referenced a nonexistent Properties deletion API; native compilation rejected it. It was corrected to exercise malformed types with the documented property APIs before the successful test run. No failed build is the reviewed release.
- Renderer matrix sampled 31,904 bytes; 100 wake/sleep/settings cycles sampled a maximum of 31,272 bytes in the test context. Repeated-update fixture sampled 31,632 bytes. These are sampled simulator values, not a proven application peak or hardware power result.
- 240 fixed-time callbacks took 5,329ms with seconds off and 5,703ms with seconds active; telemetry refreshed once. Host timing is diagnostic only, not comparable battery evidence.
- Production `-r` release compiled successfully, ran in the native simulator and supplied the [genuine artwork capture](../../design/store/README.md). Native full-update rendering and normal default appearance were inspected. No simulated frame is a hardware photograph.

Logs remain under ignored `build/windows/store-prep/validation/`. A sanitized framework-results summary is retained in [evidence](evidence/native-results.json); private device logs/settings are not copied into Git.

## Package checks

Native `-e -r` export succeeds with the production jungle. Inspection verifies the unchanged UUID, only the primary profile's two Garmin part-number entries, identical packaged release PRGs, all customer settings/prompts/defaults and exclusion of test/preview/fixture/capture symbols. No private key is in the package. Store acceptance, installation and phone settings are not inferred from compilation.

Final review export, built from clean commit **`f912b162ccf667d49e586221aabba133bcb9dbb4`**:

| Item | Recorded value |
| --- | --- |
| Local IQ path | `build/windows/store-prep/export-review/TOKYO2088-store-prep.iq` |
| IQ size | **44,379 bytes** |
| IQ SHA-256 | `a082dd6936afe3dc7afb54f4879f970750a31f1c66b424af586f9cba73f22529` |
| Each packaged release PRG | **25,612 bytes**; SHA-256 `b18891337d16544063ea118b69d589c60789cd912a57ff59ec5b82f4e6a41d92` |
| Signing | **Existing temporary Windows development key**, retained privately; permanent release choice pending |
| Export / package checker | Native exit **0** / checker exit **0** |
| Working tree at export | Clean |
| Overwrite guards | Existing export directory rejected; hardware candidate directory rejected; existing export hash unchanged |

The packaged PRG is byte-identical to the standalone production release used for simulator inspection/artwork. The native tests ran against the same source changes before their commit. This follow-up evidence commit changes documentation/evidence only; it does not create another runtime release. [Sanitized export evidence](evidence/export-review.json)

The earlier pilot export remains separately under `build/windows/store-prep/export-validation/`; its IQ archive hash differs, while the packaged PRG hash matches. This illustrates why the actual final IQ is preserved and identified rather than assuming deterministic archive bytes. All notice sidecars were included in the final export folder. Neither IQ export is the preserved hardware build.

Local documentation links, saved artwork dimensions/sRGB profiles and recorded artwork hashes passed inspection. The final diff passes `git diff --check`. The preserved 24,172-byte wrist candidate and its private archived copy were independently rehashed and still match the approved checksum; the existing temporary signing key remains present outside the repository.

## Hardware status remains separate

The owner reported the **prior 24,172-byte redraw candidate** running well on their actual fenix 8 Solar 51mm. Positive initial feedback is recorded on PR #2 and issue #1. The historical production Store-prep export has not been reported installed; the separate owner-only beta now has owner-reported installation success as recorded above. Full wrist-raise/return-from-glance/notification/idle-minute checklist, overnight reliability, comparable battery testing and phone-to-watch settings save/sync and restart persistence remain pending. No black-screen-resolution claim, issue closure or merge follows from these results.

The wrist artifact's exact identity and signing provenance remain in [signing](SIGNING.md). Existing private hardware backups and temporary signing key remain locally retained.
