# Native Windows production export

This workflow creates a **local review package**, not an upload or installation. Use the existing installed Windows SDK; no SDK switch, toolchain download, asset regeneration or signing-key generation is part of this workflow.

The local 0.1.1 polish candidate is recorded in [validation](VALIDATION.md#local-polish-candidate-011--12-september-2026), under `build/windows/beta/polish-0.1.1/`. It uses the same beta UUID/key and is **not uploaded or installed**. Any further export must use another fresh output directory. The commands below are the **historical owner-1 workflow**; preserve those existing output files and do not rerun builds into them.

The beta uses the same helpers with `-Beta`:

```powershell
powershell.exe -NoProfile -File tools/build.ps1 test -Beta -DeveloperKey $releaseKeyPath -OutputDir build/windows/beta/validation-final
powershell.exe -NoProfile -File tools/simulator.ps1 test -Beta -OutputDir build/windows/beta/validation-final
powershell.exe -NoProfile -File tools/build.ps1 release -Beta -DeveloperKey $releaseKeyPath -OutputDir build/windows/beta/validation-final
powershell.exe -NoProfile -File tools/export-store.ps1 -Beta -DeveloperKey $releaseKeyPath -SigningProvenance TemporaryDevelopment -OutputDir build/windows/beta/export-owner-1
python tools/check-store-prep.py --beta --iq build/windows/beta/export-owner-1/TOKYO2088-BETA.iq
```

Each export needs a new folder. Beta mode uses committed `manifest-beta.xml` and `beta.jungle`, never rewrites the production manifest, and constrains output to a beta subfolder. `beta-tests.jungle` shares the same beta identity/resources while including native tests only for the test PRG. The final IQ excludes all fixtures. No export helper uploads or installs anything. The user's one-upload approval is conditional on live beta/account verification, not encoded as automatic submission in a build script.

Garmin's official VS Code command is **Monkey C: Export Project**, which generates an `.iq` for manifest products. The script uses the corresponding native compiler package/release options (`-e -r`) and production jungle. [Official export instructions](https://developer.garmin.com/connect-iq/submit-an-app/), [compiler options](https://developer.garmin.com/connect-iq/monkey-c/compiler-options/)

## Prerequisites

- Existing Windows Connect IQ SDK and supported Java. This run used SDK **9.1.0**, build `2026-03-09-6a872a80b`, and Java 17.0.18. Device profile version/hashes are in [evidence](evidence/device-profiles.json).
- `CIQ_SDK_HOME`, or the current SDK selected by Garmin in `%APPDATA%/Garmin/ConnectIQ/current-sdk.cfg`.
- An explicitly selected existing private RSA-4096 DER key outside the repository. Current validation used the retained **temporary Windows development key**, not a permanent Store-key decision.
- Python 3.9+ and Windows `tar` for the package checker. Artwork regeneration additionally uses Pillow (tested 12.1.1); font provenance inspection used fontTools 4.62.1. No dependency is installed by the script.

## Commands from the repository root

Set `$releaseKeyPath` privately to the authorized existing key path. Do not put its contents or an actual private path into public documentation or a commit.

```powershell
# These outputs are separate from build/windows/candidate (the wrist artifact).
powershell.exe -NoProfile -File tools/build.ps1 test `
  -DeveloperKey $releaseKeyPath -OutputDir build/windows/store-prep/validation
powershell.exe -NoProfile -File tools/simulator.ps1 test `
  -OutputDir build/windows/store-prep/validation
powershell.exe -NoProfile -File tools/build.ps1 release `
  -DeveloperKey $releaseKeyPath -OutputDir build/windows/store-prep/validation

# Start the native simulator if needed, then run the ordinary production PRG.
powershell.exe -NoProfile -File tools/simulator.ps1 release `
  -OutputDir build/windows/store-prep/validation

# Choose a NEW folder for every export. This script refuses overwrite.
powershell.exe -NoProfile -File tools/export-store.ps1 `
  -DeveloperKey $releaseKeyPath -SigningProvenance TemporaryDevelopment `
  -OutputDir build/windows/store-prep/export-review
```

The simulator command remains attached while the app runs; stop the simulated app normally after inspection. Do not copy simulator settings JSON to a physical device. Never omit the separate output directory from the older build/simulator helpers during this trial, because their historical default is the preserved candidate folder.

The exporter guards the single manifest profile and exact production inputs (`source`, `resources`, exclusions `test;preview;fixture;capture`). It captures the native exit code and log, then verifies the generated package/settings, exact profile parts and absence of fixture symbols in each compiled debug map. Export failure stops the workflow. Tests are run separately; a successful export is not evidence that tests passed.

## Output and verification

- `TOKYO2088-store-prep.iq`: signed native Store package. This SDK writes a **7z-format archive**, not ZIP. Do not repackage or hand-edit it.
- `export.log` and `.exit-code.txt`: native compiler outcome.
- `package-check.json` / log: package and PRG hashes/sizes, part numbers, settings and fixture checks. The included `dev_key.pub` is public signing material, not the private key.
- `EXPORT_INFO.private.json`: source commit/dirty state, SDK location, UUID, version, hash and signing provenance. Remains in ignored local output; do not publish this private file blindly.
- `notices/`: supplementary original and embedded-font notices. Current source also compiles the complete applicable font terms into the PRGs and supplies an offline settings reader; see [verified notice delivery](LICENSING.md). Historical pre-beta exports are preserved and do not gain these new resources retroactively.

Repeat read-only package verification with:

```powershell
python tools/check-store-prep.py --iq build/windows/store-prep/export-review/TOKYO2088-store-prep.iq
Get-FileHash -Algorithm SHA256 build/windows/store-prep/export-review/TOKYO2088-store-prep.iq
```

The current `.iq` contains two part-number entries from Garmin's one primary product profile, with identical release PRGs. This is explained in [compatibility](COMPATIBILITY.md). Debug sidecars inside a native release export are expected and are inspected for excluded code; their presence does not make the PRG a debug/test build.

Run a checker from the source revision that produced the artifact. The current checker expects the new full notice resources; it will correctly reject older preserved exports that lack them. Historical Store-prep hash/check results remain in [validation](VALIDATION.md).

Production outputs are ignored by Git. The final review export and exact source/hash are recorded in [validation](VALIDATION.md). Reproduction requires retaining the private key, exact toolchain/profile versions and committed inputs. Signatures/archive metadata can affect package byte identity; compare recorded binary hashes rather than promising all future exports are byte-identical.

Before public upload: finish launch gates, choose the permanent key, confirm private backup, choose the public version and obtain owner authorization. The separately authorized private beta uses the retained development key but still requires verified live owner-only access and the intended account. Any required new agreement must be handled directly by the owner. No paid merchant onboarding is presumed necessary for an unpaid beta.
