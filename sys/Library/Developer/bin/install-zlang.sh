#!/bin/bash

if [[ "$(FIRMWARE_INFO "instruction" "zsh")" -ne "1" ]] || [[ "$(FIRMWARE_INFO "instruction" "java")" -ne "1" ]]; then
    if [[ "$(regread "SYSTEM/ZLang/BypassCompatibilityCheck")" -eq "1" ]]; then
        echo "Bypassing compatibility check..."
    else
        echo "Firmware does not support zlang. (Expected 11, but received $(FIRMWARE_INFO "instruction" "zsh")$(FIRMWARE_INFO "instruction" "java").)"
        exit 1
    fi
fi

if [[ "$(regread "SYSTEM/ZLang/UseOfflineInstaller")" -eq "1" ]]; then
    FPATH="$(regread "SYSTEM/ZLang/OfflineInstallerPath")"
    if [[ ! -f "$FPATH" ]]; then
        echo "Offline installer not found. Exiting..."
        exit 1
    fi
    echo "Installing ZLang using offline installer..."
    zsh "$FPATH" "2023MarD-preliminary" "$LIBRARY/Developer/ZLang"
    exit $? # Exit with the same exit code as the offline installer.
else
    echo "Installing ZLang..."
    curl -Ls https://raw.githubusercontent.com/410-dev/ZLang/main/installer.zsh -o "$CACHE/installer.sh"
    chmod +x "$CACHE/installer.sh"
    mkdir -p "$LIBRARY/Developer/ZLang"
    zsh "$CACHE/installer.sh" "2023MarD-preliminary" "$LIBRARY/Developer/ZLang"
    rm -rf "$CACHE/installer.sh"
fi

echo "Installation complete."
