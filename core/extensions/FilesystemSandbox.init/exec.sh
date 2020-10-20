#!/bin/bash
mkdir -p "$CACHE/proc.faccess"
verbose "[*] Limiting write permission..."
echo "$(<"$(dirname "$0")/write")" > "$CACHE/proc.faccess/wlim"
verbose "[*] Limiting read permission..."
echo "$(<"$(dirname "$0")/read")" > "$CACHE/proc.faccess/rlim"
verbose "[*] Limiting catalog permission..."
echo "$(<"$(dirname "$0")/catalog")" > "$CACHE/proc.faccess/clim"
exit 0