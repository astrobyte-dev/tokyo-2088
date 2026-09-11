> Historical record, superseded by current TEST_RESULTS.md and BLACK_SCREEN_INVESTIGATION.md. Sanitized for review.

# Test results — 11 September 2026

## Continuation: package verification and Linux launcher repair

On the continuation after the owner reported completing installation, the required explicit command `./tools/build.sh debug` was executed again. It still failed with `ERROR: Invalid device id specified: 'fenix8solar51mm'.` No generic build was used as a substitute.

`~/.Garmin/ConnectIQ/current-sdk.cfg` and `~/.Garmin/ConnectIQ/Devices/fenix8solar51mm` were absent. Searches of the accessible home, Snap directories, /opt, /root and temporary locations found only the SDK reference-artwork directories with this name, not `compiler.json`/`simulator.json` device packages. The SDK Manager presented its first-time Login screen. This is an installation-location/state discrepancy with the owner's report; the location has been requested.

A concrete launch failure was reproduced when clicking Login: the WebKit helper loaded a VS Code Snap plug-in linked against incompatible libc (`__libc_pthread_init, version GLIBC_PRIVATE`). Added `tools/sdk-manager.sh` to remove those GTK/GIO overrides for that process. **Verified that the sign-in form subsequently loaded successfully**, and left it open on the physical desktop. The build and simulator scripts now share SDK selection through `tools/toolchain.sh`; the simulator also clears incompatible Snap GTK/GIO overrides.

| Required status | Continuation result |
|---|---|
| Asset checks | Re-executed: **40 passed**. These remain design-asset checks, not native renderer execution. |
| Device-specific compilation | **Attempted and failed**, exact target `fenix8solar51mm`; missing device package. |
| Executed native tests | **Not run**; no target test executable can be produced. Prior suite compilation remains compilation-only. |
| Simulator visuals/runtime | **Not run on target**; no running-face screenshots and no measured runtime memory. The Manager login screen is setup evidence only. |
| Physical-watch testing | **Pending**; no Garmin USB device or MTP volume visible, and no transfer attempted. |

Evidence: [fresh build output](primary-build-recheck.log), [toolchain diagnostics](toolchain-recheck.sanitized.txt), [local-only setup evidence omitted], [local-only setup evidence omitted], [local-only setup evidence omitted].

Linux transfer verification: Ubuntu `gvfs-backends` 1.54.4 and libmtp 1.1.21 are installed. Garmin's fēnix 8 manual confirms selectable MTP mode; no actual storage path is claimed until the watch is connected and discovered. Updated instructions are in [BUILD_AND_TEST](../BUILD_AND_TEST.md).

No visual/layout changes were made in this continuation. Additional devices, automatic locality, hardware claims and battery-life claims remain deferred. Smallest unblock: provide the installed package location if it exists elsewhere, or finish the repaired desktop Manager's sign-in/package download under this account.

## Earlier handoff record

The product is **not yet a validated runnable primary-device build**. The following records separate executed checks from source inspection and blocked tests.

| Check | Actual result | Evidence |
|---|---|---|
| Full brief and approved image | Read completely; right-hand TOKYO 2088 inspected | Supplied files retained in workspace |
| Asset generation | Executed with Pillow; primary fonts, icon, four palettes and two telemetry sizes generated | `tools/generate_assets.py`, `design/previews/` |
| Native-size visual review | Classic Red and readable 280px images inspected, along with 4× Classic Red | Design renders only; not simulator screenshots |
| Asset geometry/palette | **40 cases passed**: 2 layouts × 4 palettes × 5 clocks; no nonblack pixels outside unmasked circular boundary, 4-level RGB colours and binary glyph coverage/advance checks | [Machine-readable results](../asset-checks.json), `python3 tools/check_assets.py` |
| Project XML / shell syntax | All project XML parsed; build/run scripts passed `bash -n` | Checks executed locally |
| Production source generic compilation | **BUILD SUCCESSFUL**, with expected missing-device warning; no source warnings in latest pass | [Compiler output](generic-source-compile.sanitized.log) |
| Native test suite generic compilation | **BUILD SUCCESSFUL**, missing-device warning | [Compiler output](generic-test-compile.sanitized.log) |
| Fixture app generic compilation | **BUILD SUCCESSFUL**, missing-device warning | [Compiler output](generic-preview-compile.sanitized.log) |
| Primary `-d fenix8solar51mm` build | **BLOCKED**, device ID unavailable to compiler because its package is not installed | [Exact failed build output](primary-build-blocker.log) |
| SDK Manager / simulator startup | Both executable UIs launched after Linux dependency repair; Manager stops at login, simulator has no device skin | Launch check only; no face ran |
| Primary runtime unit tests | **NOT RUN** | Package/login blocker |
| Actual native renderer screenshots | **NONE** | Design renders must not be relabelled |
| Peak runtime memory / draw budget | **NOT MEASURED** | Binary size is not runtime memory |
| Phone settings and USB sideload | **NOT TESTED** | No primary binary/hardware session |
| Physical readability / battery | **NOT TESTED / NOT MEASURED** | Owner must perform |
| Expansion / AMOLED AOD | **NOT IMPLEMENTED / NOT RUN** | Primary-first gate |

## Compiled native tests awaiting execution

`tests/FaceTests.mc` tests the production `Format`, settings/provider and `TokyoView` code. It contains time format/noon/midnight checks; HR invalid/missing/future/stale checks; steps missing/zero/large counts; temperature missing/stale/negative/zero and conversion; battery boundary checks; header modes, unsupported-glyph fallback and malformed property defaults.

The renderer test creates a real Garmin drawing context and invokes the production renderer over all four palettes, five difficult digit pairs and seven battery cases, then long headers, hidden header, readable telemetry and sleep/active transitions. This is **test code that compiled**, not passing runtime tests. Its memory log would describe a test-buffer context, not production high-water memory.

`tests/Preview.mc` is a separate deterministic fixture app using the production renderer. It is excluded from release source and uses a separate UUID. It has not run.

## Remaining acceptance work after package installation

1. Inspect actual compiler/simulator package metadata and resolve the minimum API/package range; target debug and release builds with warnings visible.
2. Run native unit tests and correct any resource, API, memory or rendering failures. Capture flat 280px frames and nearest-neighbour enlargements from the real simulator.
3. Inspect all palettes, long custom/city strings, unsupported input, hidden/blank modes, negative temperatures and three-digit HR with both telemetry sizes. Test true settings reload/restart without losing full input.
4. Use simulator time controls for midnight/noon, month/year rollover, timezone and DST transitions. Check no double offset against device local time. These local-time transitions were not simulated in this handoff.
5. Supply missing/invalid/stale HR and weather, unknown weather conditions, disconnected phone and valid zero values. Confirm cached reads and no old HR retained indefinitely.
6. Run repeated wake/sleep and settings cycles; check seconds disappear on sleep and the clipping region resets. Measure actual production memory high-water, not the fixture/test-buffer memory. Confirm behaviour across a whole low-power minute.
7. Only after primary success, build explicit smaller-MIP and AMOLED profiles, with separate AOD work and checks before compatibility claims.
8. Owner performs the physical checklist in [BUILD_AND_TEST](../BUILD_AND_TEST.md). Record firmware and conditions; do not infer hardware battery life from simulator results.

## Reproduction

```bash
python3 tools/check_assets.py
./tools/build.sh syntax                 # runs now; generic only, never sideload
./tools/build.sh debug                  # blocked until device package installed
./tools/build.sh test
./tools/simulator.sh start              # separate terminal
./tools/simulator.sh test
./tools/build.sh release
```
