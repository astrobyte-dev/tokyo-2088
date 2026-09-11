#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/toolchain.sh
printf 'Compiler directory: %s\n' "$CIQ_SDK_HOME"
"$CIQ_SDK_HOME/bin/monkeyc" -v
if [[ -f "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]]; then
  printf 'SDK Manager active configuration: present\n'
else
  printf 'SDK Manager active configuration: absent; using explicit/local fallback\n'
fi
package="$HOME/.Garmin/ConnectIQ/Devices/fenix8solar51mm"
if [[ -d "$package" ]]; then
  printf 'Device directory: %s\n' "$package"
  python3 - "$package/compiler.json" <<'PYINFO'
import json,sys
c=json.load(open(sys.argv[1]));w=next(x for x in c["appTypes"] if x["type"]=="watchFace")
print(c["deviceId"],c["resolution"],c["displayType"],c["pixelFormat"])
print("Watch-face memory limit:",w["memoryLimit"],"bytes;",c["deviceGroup"])
print("Package version:",c["deviceVersion"])
PYINFO
else
  printf 'Device package not found: %s\n' "$package"
  exit 2
fi
