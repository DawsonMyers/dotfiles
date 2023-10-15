#!/bin/bash

for i in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    if [ -e "$i" ]; then
        echo "Moving $i up one level to $(dirname ./..)"
        mv "$i" ./..
    fi
done