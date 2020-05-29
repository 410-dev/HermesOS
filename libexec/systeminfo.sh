#!/bin/bash
profloc="$CACHE/init/TouchDown.System.SystemProfiler"
echo "System Information"
echo "OS Name: $(<$profloc/sys_name)"
echo "Version: $(<$profloc/sys_version) (build $(<$profloc/sys_build))"
echo "Compatibility: $(<$profloc/sys_compatibility)"
echo "Manufacturer: $(<$profloc/sys_manufacture)"
echo "Interface Version: $(<$profloc/interface_version)"
exit 0