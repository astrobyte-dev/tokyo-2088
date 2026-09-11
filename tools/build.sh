#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/toolchain.sh
key="${CIQ_DEVELOPER_KEY:-$HOME/.config/tokyo2088/developer_key.der}"
[[ -f "$key" ]] || { echo 'Set CIQ_DEVELOPER_KEY to your private DER signing key.' >&2; exit 2; }
mode="${1:-release}"
device="${2:-fenix8solar51mm}"
[[ "$device" == 'fenix8solar51mm' ]] || { echo 'Only the primary profile is enabled.' >&2; exit 2; }
mkdir -p bin build/logs
args=(-f monkey.jungle -d "$device" -y "$key" -w)
case "$mode" in
 release) output="bin/TOKYO2088-$device.prg"; args+=(-r) ;;
 debug) output="bin/TOKYO2088-$device-debug.prg" ;;
 test) output="bin/TOKYO2088-$device-tests.prg"; args=(-f tests.jungle -d "$device" -y "$key" -w -t) ;;
 preview) output="bin/TOKYO2088-$device-preview.prg"; args=(-f preview.jungle -d "$device" -y "$key" -w) ;;
 syntax) output="build/generic-syntax-only.prg"; args=(-f monkey.jungle -y "$key" -w) ;;
 *) echo 'Usage: tools/build.sh release|debug|test|preview|syntax [fenix8solar51mm]' >&2;exit 2;;
esac
"$CIQ_SDK_HOME/bin/monkeyc" "${args[@]}" -o "$output" 2>&1 | tee "build/logs/$mode.log"
[[ "$mode" != syntax ]] || echo 'Generic compile only: NEVER sideload this binary.'
