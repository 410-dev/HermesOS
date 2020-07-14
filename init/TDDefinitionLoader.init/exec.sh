#!/bin/bash
export Source="$TDLIB/Services/DefinitionLoaders/"
export Target="$CACHE/def"
echo "[*] Generating space on cache drive..."
mkdir -p "$Target"
cd "$Source"
echo "[*] Uploading definition files..."
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
echo "[*] Upload done."
exit 0