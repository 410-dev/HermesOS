#!/bin/bash
echo "Reset process started."
echo "[1/4] Erasing all contents of /System..."
rm -vrf "$SYSTEM/"*
echo "[2/4] Copying new system from /Data/mount/sysimg..."
cp -vr "$DATA/mount/sysimg/"* "$SYSTEM/"
echo "[3/4] Unmounting image from /Data/mount/sysimg..."
hdiutil detach "$DATA/mount/sysimg" -force >/dev/null
echo "[4/4] Erasing /Data partition..."
rm -vrf "$DATA/"*
touch "$CACHE/upgraded"