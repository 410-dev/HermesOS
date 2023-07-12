#!/bin/bash

if [[ "$(FIRMWARE_INFO "instruction" "zsh")" -ne "1" ]] || [[ "$(FIRMWARE_INFO "instruction" "java")" -ne "1" ]]; then
    echo "Firmware does not support zlang."
    exit 1
fi

echo "Installing ZLang..."
curl -Ls https://raw.githubusercontent.com/410-dev/ZLang/main/installer.zsh -o "$CACHE/installer.sh"
chmod +x "$CACHE/installer.sh"
mkdir -p "$LIBRARY/Developer/ZLang"
zsh "$CACHE/installer.sh" "2023MarD-preliminary" "$LIBRARY/Developer/ZLang"
rm -rf "$CACHE/installer.sh"

echo "Installation complete."
