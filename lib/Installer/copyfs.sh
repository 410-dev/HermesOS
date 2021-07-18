#!/bin/bash
target="$1"
cp -r "$SYSLIB"/defaults/filesystem/root/* "$target/"
cp -r "$SYSLIB"/defaults/filesystem/data "$target/"
mv "$target/data" "$target/Data"
