#!/bin/bash
export Source="$TDLIB/Services/DefinitionLoaders/"
export Target="$CACHE/def"
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
export Source=""
export Target=""
exit 0