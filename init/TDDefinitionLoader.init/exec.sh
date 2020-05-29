#!/bin/bash
export Source="/Volumes/VFS/System/TouchDown/Services/DefinitionLoaders/"
export Target="/Volumes/VFS/cache/def"
mkdir -p "$Target"
cd "$Source"
for file in *.def
do
    cp "$file" "$Target/"
    if [[ "$?" == "0" ]]; then
        echo "[*] Uploaded: $file"
    else
        echo "[-] Failed: $file"
    fi
done
exit 0