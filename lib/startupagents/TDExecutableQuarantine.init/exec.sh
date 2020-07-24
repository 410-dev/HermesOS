#!/bin/bash
echo "[*] Copying quarantine data..."
DAT="
../
bash
zsh
sh
sudo
hdiutil
mount
umount
export
echo
rm
touch
shutdown
reboot
launchctl
halt
"
echo "$DAT" > "$CACHE/quarantine"
echo "[*] Done."
exit 0