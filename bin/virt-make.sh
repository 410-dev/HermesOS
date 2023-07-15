#!/bin/bash

# Check if virtualizable
if [[ "$(bootArgumentHas "vm.nested=1")" == 1 ]]; then
    echo "Nested virtualization is unavailable."
    exit 90
fi
if [[ "$(FIRMWARE_INFO "virtualization")" -ne "1" ]]; then
    echo "Virtualization is unavailable."
    exit 90
fi

# Get container name.
ContainerName="$1"
if [[ -z "$ContainerName" ]]; then
    echo "Missing container name."
    exit 90
fi
if [[ "$ContainerName" == "."* ]]; then
    echo "Invalid container name."
    exit 90
fi

# Get image path
ImagePath="$2"
if [[ -z "$ImagePath" ]]; then
    echo "Missing image path."
    echo "Try using --clone or --system to create a new virtual machine from current system."
    exit 90
fi
if [[ "$(access_fs "$USERDATA/$ImagePath")" == -9 ]]; then
	echo "${OPERATION_NOT_PERMITTED}File Read"
	exit 99
fi

# Get third parameter (--legacy or -a)
LegacyMode="false"
AutoConfiguration="false"
if [[ "$3" == "--legacy" ]]; then
    LegacyMode="true"
elif [[ "$3" == "-a" ]]; then
    AutoConfiguration="true"
fi

# Get fourth parameter (-a)
if [[ "$AutoConfiguration" == "true" ]]; then
    if [[ "$(access_fs "$USERDATA/$4")" == -9 ]]; then
        echo "${OPERATION_NOT_PERMITTED}File Read"
        exit 99
    fi
    AutoConfigurationFile="$(cat "$USERDATA/$4")"
fi

# Create container at data
if [[ -e "$USERDATA/VirtualMachines/containers/$ContainerName" ]] ||
    [[ -e "$USERDATA/VirtualMachines/configs/$ContainerName" ]]; then
    echo "Container already exists."
    exit 90
fi

echo "Creating new virtual machine '$ContainerName'..."

# Create container
echo "Creating container..."
mkdir -p "$USERDATA/VirtualMachines/containers/$ContainerName/disk"

# Create config
echo "Creating config..."
mkdir -p "$USERDATA/VirtualMachines/configs/$ContainerName"

# Create config file
echo "$ContainerName" > "$USERDATA/VirtualMachines/configs/$ContainerName/name"
echo "$ImagePath" > "$USERDATA/VirtualMachines/configs/$ContainerName/imagePath"
echo "$AutoConfiguration" > "$USERDATA/VirtualMachines/configs/$ContainerName/autoconfig"
if [[ "$AutoConfiguration" == "true" ]]; then
    echo "$AutoConfigurationFile" > "$USERDATA/VirtualMachines/configs/$ContainerName/AUTOCONFIG"
fi
if [[ "$LegacyMode" == "true" ]]; then
    echo "true" > "$USERDATA/VirtualMachines/configs/$ContainerName/legacy"
fi

# Create containers
if [[ "$ImagePath" == "--clone" ]] || [[ "$ImagePath" == "--system" ]]; then
    : # Do nothing
elif [[ ! -f "$USERDATA/$ImagePath" ]]; then
    echo "Image file not found."
    exit 90
else
    # If legacy, use zip
    if [[ "$LegacyMode" == "true" ]]; then
        cp "$USERDATA/$ImagePath" "$USERDATA/VirtualMachines/containers/$ContainerName/image.zip"
    else
        # If not legacy, use tar
        cp "$USERDATA/$ImagePath" "$USERDATA/VirtualMachines/containers/$ContainerName/image.tar.gz"
    fi
    
fi

# Extract image to container disk
echo "Installing system to container disk..."
if [[ "$ImagePath" == "--clone" ]] || [[ "$ImagePath" == "--system" ]]; then
    # Clone current system
    echo "Cloning current system..."
    cp -r "$SYSTEM" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/"
else
    # Extract image
    echo "Extracting image..."
    
    # If legacy, use unzip
    mkdir -p "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System"
    if [[ "$LegacyMode" == "true" ]]; then
        echo "Legacy mode enabled."
        unzip -q "$USERDATA/VirtualMachines/containers/$ContainerName/image.zip" -d "$USERDATA/VirtualMachines/containers/$ContainerName/disk/System"
    else
        # If not legacy, use tar
        tar -xf "$USERDATA/VirtualMachines/containers/$ContainerName/image.tar.gz" -C "$USERDATA/VirtualMachines/containers/$ContainerName/disk"
    fi
fi

echo "Cleaning extended attributes..."
find "$USERDATA/VirtualMachines/containers/$ContainerName/disk" -exec xattr -c {} \;

if [[ -x "$USERDATA/VirtualMachines/containers/$ContainerName/System/boot/firm" ]]; then
    echo "The image contains built-in firmware. Use --firm to use it."
fi

# If clone, copy library
if [[ "$ImagePath" == "--clone" ]]; then
    echo "Copying library..."
    cp -r "$LIBRARY" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/"
fi


# If autoconfig, copy autoconfig
if [[ "$AutoConfiguration" == "true" ]]; then
    echo "Copying autoconfig..."
    cp "$USERDATA/VirtualMachines/configs/$ContainerName/AUTOCONFIG" "$USERDATA/VirtualMachines/containers/$ContainerName/disk/"
fi

echo "Virtual machine is ready to go. The bootloader will automatically be patched when you start the virtual machine."
echo "Done."
