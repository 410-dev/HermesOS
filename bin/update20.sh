#!/bin/bash
if [[ "$HUID" -ne 0 ]]; then
    echo "${PERMISSION_DENIED}$HUID"
    exit 0
fi


echo -e "${YELLOW}This command will update your system to HermesOS 2x.x.${C_DEFAULT}"
echo "Warning: HermesOS 2x.x is not compatible with HermesOS 1x.x."
echo "         This means that your configuration will not be preserved during the update."
echo "         If you wish to preserve your configuration and data, please backup your system before continuing."
echo ""
echo "Warning: Your personal data may be preserved, but it is not guaranteed."
echo "         Please backup your data before continuing."
echo "         Configuration files will not be preserved at all."
echo ""
echo "This command will download installation image from 20.0 Prerelease branch."
echo ""
echo "Do you wish to continue? (y/n)"
read -p "> " -n 1 -r
echo ""
echo "Downloading using dlutil@Services.Update-2x..."
"$OSSERVICES/Library/Services/Update-2x/dlutil"
if [[ ! -z "$(file "$LIBRARY/image.tar.gz" | grep "gzip compressed data")" ]]; then
    echo "Download was successful."
else
    echo "Download failed."
    exit 0
fi

echo "Preparing update..."
echo "update" > "$NVRAM/bootaction"
if [[ -f "$LIBRARY/image.zip" ]]; then
    rm -f "$LIBRARY/image.zip"
fi
touch "$LIBRARY/image.zip"
echo "Shutting down..."
"$SYSTEM/bin/shutdown"
