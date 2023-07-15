#!/bin/bash
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/internal_func"
source "$(dirname "$0")/bootloader/bootconf"
OSSTART "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
leaveSystem