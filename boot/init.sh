#!/bin/bash
clear
source "$(dirname "$0")/partitions.hdp"
source "$(dirname "$0")/llhooks.ll" 2>/dev/null
source "$(dirname "$0")/internal_func"
source "$(dirname "$0")/bootloader/osstart"
OSSTART "$@"
leaveSystem
exit 0
