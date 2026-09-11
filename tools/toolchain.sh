#!/usr/bin/env bash
# Shared by compiler and simulator so both select the same installed SDK.
if [[ -z "${CIQ_SDK_HOME:-}" ]]; then
  if [[ -f "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]]; then
    CIQ_SDK_HOME="$(cat "$HOME/.Garmin/ConnectIQ/current-sdk.cfg")"
  elif [[ -d "$HOME/.local/share/garmin-toolchain/sdk-9.2.0" ]]; then
    CIQ_SDK_HOME="$HOME/.local/share/garmin-toolchain/sdk-9.2.0"
  else
    echo 'Set CIQ_SDK_HOME to the installed Garmin SDK.' >&2
    return 2
  fi
fi
[[ -x "$CIQ_SDK_HOME/bin/monkeyc" ]] || { echo "No executable monkeyc in $CIQ_SDK_HOME/bin" >&2; return 2; }
export CIQ_SDK_HOME
