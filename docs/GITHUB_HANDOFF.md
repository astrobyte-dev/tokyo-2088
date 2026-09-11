# Private source-review handoff — 11 September 2026

This repository preserves the existing implementation for independent review of the [open physical black-screen defect](BLACK_SCREEN_INVESTIGATION.md). Read that report before proposing changes. The source, resources, tests and existing build scripts were not modified for this handoff. No watch-face rebuild, reinstall or watch access was performed.

## What is preserved

Before documentation/packaging changes, the complete project was archived locally, including `dist`, `bin`, `build`, original logs and debug mappings. A separate copy of the 24,188-byte release and a complete local file-hash inventory were also saved. The archive is outside this repository under the owner's local `tokyo2088-local-archives` directory. The private signing key remains outside the project and was not copied into the archive or repository.

There was no existing Git repository, history or remote to preserve. Git is initialized only in this project. [Source-state hashes](evidence/source-state.json) cover current build inputs; [release identity](evidence/installed-release-build-info.json) records the installed artifact's hash and limited historical source provenance. Do not describe a new reviewer build as the installed binary.

## Review materials

- Complete Monkey C source/resources, fonts and notices, manifest and Jungle configurations, VS Code tasks, build/simulator scripts and native tests.
- Original brief and right-hand TOKYO concept board. `START_HERE.md` is an explicitly labelled historical prompt, not a request to restart development.
- Unaltered native simulator captures and labelled nearest-neighbour enlargements in `design/simulator/`. Older `design/previews/` images are design renders, not native execution evidence.
- Current build/install documentation, original test outcomes, selected simulator memory evidence and sanitized historical logs/first-install evidence.

`docs/evidence` uses a reviewed allowlist in `.gitignore`. Raw originals remain local. Sanitized log filenames and report notices distinguish them from untouched originals; redactions remove home paths and the device-specific MTP URI. The first-install record's original execution status is historical; current owner-reported status is initial operation with an intermittent black-screen defect still open.

## Reproducing a new reviewer build

Use a separate checkout so builds cannot overwrite the preserved local release. Existing environment: Ubuntu 24.04 x86_64, OpenJDK 17.0.20, Connect IQ SDK/compiler **9.2.0**, installed **fenix8solar51mm** device package (API 6.0.2). App minimum API is 3.2.0. See [package metadata](evidence/primary-device-package.sanitized.json) and [BUILD_AND_TEST.md](BUILD_AND_TEST.md) for Linux library/simulator caveats. SDK and device packages must be obtained through Garmin; they are not redistributed here.

Set paths to your own SDK and private DER signing key outside the checkout:

```bash
export CIQ_SDK_HOME='/path/to/your/connect-iq-sdk'
export CIQ_DEVELOPER_KEY='/path/outside/checkout/to/your-developer-key.der'
./tools/doctor.sh
./tools/build.sh debug fenix8solar51mm
./tools/build.sh test fenix8solar51mm
./tools/build.sh release fenix8solar51mm
```

Never commit or share your signing key. The compiler needs the checked-in bitmap fonts/resources; asset regeneration is optional. Python 3 and Pillow are required for `tools/check_assets.py` and asset/image tooling. The existing `check_assets.py` imports the generator and can rewrite generated resources/previews, so run it in a separate checkout when preserving exact original artifacts. The AT-SPI UI helper additionally relies on host accessibility tooling/xdotool; it is operator-assisted, not a portable unattended harness.

Start the simulator with `./tools/simulator.sh start`, then run `./tools/simulator.sh test` and `./tools/simulator.sh run-release` as described in the build guide. Preserve both framework output and launcher status: previous native tests reported four passing groups while `monkeydo` exited 1. No rebuild or test rerun was performed during the source-upload task.

## Intentional exclusions and access limits

- Generated PRG/ZIP outputs, debug mappings and intermediate builds: retained locally for binary/log interpretation, not committed. No GitHub Release binary was uploaded.
- Raw USB/MTP inventories, device URI/serial, raw first-install files and readback PRG: retained locally; sanitized evidence is included.
- SDK Manager/login screenshot, local host inventories, full host crash dump/log and incidental simulator UI probes: local only. Relevant simulator-host error excerpt is included and labelled.
- Signing keys, credentials, environment secrets, SDK installations/caches and unrelated files: excluded. No actual physical crash logs have been collected or uploaded.

The repository is private. The other ChatGPT session's GitHub connection must be granted access to this repository in the owner's GitHub integration settings; successful upload does not prove that separate session has indexed or can access it. No Connect IQ Store publication or new sideload settings route is implied. The unchanged sideload still lacks an on-watch header editor; companion-app configuration limitations remain documented in FIRST_INSTALL.md.
