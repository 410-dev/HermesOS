#!/bin/bash
sys_log "Setup" "Writing global configurations..."
echo "[*] Writing global configurations..."
regwrite "SYSTEM/Common/DataSetupDone" "1" >/dev/null
regwrite "USER/Shell/StartupMode" "Login" >/dev/null
regwrite "SYSTEM/Common/SetupDone" "1" >/dev/null
regwrite "SYSTEM/Common/ConfigureDone" "1" >/dev/null
echo "[*] Done."
sys_log "Setup" "Finished writing global configurations."