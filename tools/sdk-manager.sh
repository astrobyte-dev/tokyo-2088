#!/usr/bin/env bash
set -euo pipefail
manager="${CIQ_SDK_MANAGER:-$HOME/.local/share/garmin-toolchain/manager/bin/sdkmanager}"
compat="$HOME/.local/share/garmin-toolchain/compat-jammy/usr/lib/x86_64-linux-gnu"
# VS Code Snap exports GTK/GIO plug-ins linked to Snap's incompatible libc.
exec env -u GTK_PATH -u GTK_EXE_PREFIX -u GTK_IM_MODULE_FILE \
  -u GIO_MODULE_DIR -u GDK_PIXBUF_MODULE_FILE -u GDK_PIXBUF_MODULEDIR \
  -u GSETTINGS_SCHEMA_DIR -u GTK_MODULES \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  LD_LIBRARY_PATH="$compat" "$manager" "$@"
