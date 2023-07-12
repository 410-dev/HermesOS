#!/bin/bash

echo "Boot Information:"
echo "--Memory Allocation--"
cat "$CACHE/alloc_data"
echo ""
echo "--Loaded Extensions--"
cat "$CACHE/extension_loaded"
echo ""
echo "--Async Extensions--"
cat "$CACHE/async_loaded"
echo ""
echo "--Boot Arguments--"
echo "$BOOTARGS"
