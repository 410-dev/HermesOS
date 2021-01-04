#!/bin/bash
echo "[*] Writing global configurations..."
mplxw "SYSTEM/DATASETUP_COMPLETE" "Done" >/dev/null
mplxw "USER/INTERFACE/START_MODE" "Login" >/dev/null
mplxw "SYSTEM/COMMON/SetupDone" "" >/dev/null
mplxw "SYSTEM/COMMON/CONFIGURE_DONE" "TRUE" >/dev/null
echo "[*] Done."