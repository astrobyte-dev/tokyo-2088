# Device support — 11 September 2026

Only `fenix8solar51mm` is enabled in the manifest and accepted by the build script.

| Device / product ID | Explicit profile | Device compilation | Simulator | Physical watch |
|---|---|---|---|---|
| fēnix 8 Solar 51mm / `fenix8solar51mm` | Implemented, 280 × 280 MIP | Debug/test/release PASS | Production runs, captures and 4 native test groups PASS; limits in TEST_RESULTS | Owner reports initial operation; intermittent black screen OPEN |
| fēnix 8 Solar 47mm / `fenix8solar47mm` | Planned, 260 × 260 | Not attempted | Not tested | Unavailable |
| fēnix 7X / Enduro 2 / `fenix7x` | Planned, 280 × 280 | Not attempted | Not tested | Unavailable |
| fēnix 8 AMOLED 47/51mm / `fenix847mm` | Planned, 454 × 454 | Not attempted | Not tested; AOD unimplemented | Unavailable |

Primary package inspection confirms round 280 × 280 MIP, ARGB2222, 131,072-byte watch-face limit, API 6.0.2 and package version `3d0fb192a2cf01699aefd0f384af3f527e5885bd`. [Metadata](evidence/primary-device-package.sanitized.json). The simulator's combined fēnix/tactix title does not extend the tested product list.

Candidate IDs/dimensions were found in SDK documentation only; their installed packages/capabilities have not been qualified. App minimum API remains 3.2.0, distinct from SDK 9.2.0 and primary simulator API 6.0.2.

Expansion and automatic city remain deferred. Each future device needs its own layout/resource profile, package inspection, explicit build and simulator checks. AMOLED needs a separately designed and validated low-power/AOD implementation. Uniform scaling and blanket compatibility are not implemented.
