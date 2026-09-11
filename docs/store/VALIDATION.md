# Executed release-preparation validation

Executed on native Windows, 11 September 2026, using the installed Connect IQ SDK 9.1.0 (`2026-03-09-6a872a80b`) and primary `fenix8solar51mm` profile. No SDK or watch firmware was changed. Final committed export identity is recorded below after the clean-source review export.

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

The final export identity will be recorded in the follow-up evidence commit after exporting the committed source. The earlier pilot export remains separately under `build/windows/store-prep/export-validation/` and is not the preserved hardware build.

## Hardware status remains separate

The owner reported the **prior 24,172-byte redraw candidate** running well on their actual fenix 8 Solar 51mm. Positive initial feedback is recorded on PR #2 and issue #1. The current Store-prep release has not been installed. Full wrist-raise/return-from-glance/notification/idle-minute checklist, overnight reliability, comparable battery testing and ordinary phone-to-watch settings remain pending. No black-screen-resolution claim, issue closure or merge follows from these simulator results.

The wrist artifact's exact identity and signing provenance remain in [signing](SIGNING.md). Existing private hardware backups and temporary signing key remain locally retained.
