#!/bin/bash
clear
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"
source "$(dirname "$0")/bootloader/bootconf"
OSSTART "$@"
leaveSystem
exit 0
