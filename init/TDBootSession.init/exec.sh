#!/bin/bash
echo "[*] Generating Session hash..."
md5 -qs "$(date)" > "$CACHE/SESSION_NUM"
echo "[*] Complete."