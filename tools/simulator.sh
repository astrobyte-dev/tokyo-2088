#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/toolchain.sh
compat="$HOME/.local/share/garmin-toolchain/compat-jammy/usr/lib/x86_64-linux-gnu"
if [[ -d "$compat" ]]; then export LD_LIBRARY_PATH="$compat${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"; fi
# Avoid loading Snap GTK/GIO modules into Garmin's native Linux process.
unset GTK_PATH GTK_EXE_PREFIX GTK_IM_MODULE_FILE GIO_MODULE_DIR
unset GDK_PIXBUF_MODULE_FILE GDK_PIXBUF_MODULEDIR GSETTINGS_SCHEMA_DIR GTK_MODULES
export XDG_DATA_DIRS=/usr/local/share:/usr/share
case "${1:-start}" in
 start) exec "$CIQ_SDK_HOME/bin/connectiq" ;;
 run) exec "$CIQ_SDK_HOME/bin/monkeydo" "bin/TOKYO2088-fenix8solar51mm-debug.prg" fenix8solar51mm -a bin/TOKYO2088-fenix8solar51mm-debug-settings.json:GARMIN/Settings/TOKYO2088-FENIX8SOLAR51MM-DEBUG-settings.json ;;
 run-release) exec "$CIQ_SDK_HOME/bin/monkeydo" "bin/TOKYO2088-fenix8solar51mm.prg" fenix8solar51mm -a bin/TOKYO2088-fenix8solar51mm-settings.json:GARMIN/Settings/TOKYO2088-FENIX8SOLAR51MM-settings.json ;;
 test) exec "$CIQ_SDK_HOME/bin/monkeydo" "bin/TOKYO2088-fenix8solar51mm-tests.prg" fenix8solar51mm -t ;;
 preview) exec "$CIQ_SDK_HOME/bin/monkeydo" "bin/TOKYO2088-fenix8solar51mm-preview.prg" fenix8solar51mm ;;
 *) echo 'Usage: tools/simulator.sh start|run|run-release|test|preview' >&2;exit 2;;
esac
