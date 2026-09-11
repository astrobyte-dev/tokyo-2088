# Executed release-preparation validation

## Private beta preparation — current milestone

The beta source uses separate UUID `ca80e764ffae413996a66e11abd76ed9` and name TOKYO 2088 BETA with the same primary profile, runtime renderer/resources and 12 phone properties. The new offline font-notice reader is reached only through Garmin's separate settings entry point. The production manifest and preserved wrist binary remain unchanged.

Native Windows beta run: **9 passed, 0 failed, 0 errors; launcher exit 0**. The prior eight groups remain passing and `fontNoticeDelivery` verifies resource loading, all pages, complete text reconstruction and page boundaries. DejaVu/Arev is 4,763 characters / 41 pages; Noto/OFL is 4,243 characters / 37 pages. Initial development checks caught a notice-extraction error and strict release initialization error; both were fixed before the passing run and checked export.

Logs: `build/windows/beta/validation-final/`. Renderer matrix sampled 34,752 bytes, power-cycle fixture 34,120 and repeated-update fixture 34,480; 240 fixed-time updates took 1,875ms in each seconds mode with one telemetry refresh. These are simulator samples/timings, not hardware peak-memory or battery measurements.

The beta package checker verifies the alternate identity, primary profile only, original property schema, excluded fixtures and the complete applicable licence text **inside each PRG**. Final clean-source export identity is recorded in the evidence follow-up after committing the implementation. Temporary Windows key provenance is explicit; no key was generated or adopted for public release.

**Not uploaded.** Browser control stopped because it could not confidently determine Opera's URL; neither the intended Garmin account nor live beta-only setting was observed. No new agreement, merchant flow, fee, public listing, phone installation or watch action occurred. Owner asked to open/sign in to the dashboard in Chrome/Edge. Reader visual UI, actual beta/phone route, settings transport/persistence and physical wear remain pending; native tests do not establish them.

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

The owner reported the **prior 24,172-byte redraw candidate** running well on their actual fenix 8 Solar 51mm. Positive initial feedback is recorded on PR #2 and issue #1. The current Store-prep release has not been installed. Full wrist-raise/return-from-glance/notification/idle-minute checklist, overnight reliability, comparable battery testing and ordinary phone-to-watch settings remain pending. No black-screen-resolution claim, issue closure or merge follows from these simulator results.

The wrist artifact's exact identity and signing provenance remain in [signing](SIGNING.md). Existing private hardware backups and temporary signing key remain locally retained.
