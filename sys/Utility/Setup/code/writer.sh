#!/bin/bash
sys_log "Setup" "Writing global configurations..."
echo "[*] Writing global configurations..."
mplxw "SYSTEM/Common/DataSetupDone" "Done" >/dev/null
mplxw "USER/Shell/StartupMode" "Login" >/dev/null
mplxw "SYSTEM/Common/SetupDone" "" >/dev/null
mplxw "SYSTEM/Common/ConfigureDone" "TRUE" >/dev/null
echo "[*] Done."
sys_log "Setup" "Finished writing global configurations."