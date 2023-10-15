#!/bin/bash

for file in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    [[ ! $file =~ \.service$ ]] && echo "ERROR: File must end with '.service'" && continue
    if [ -e "$file" ]; then
        echo "Adding service $(basename $file)"
        chmod u+x "$file"
        ln -sv "$file" ~/.config/systemd/user/
        systemctl --user daemon-reload
        systemctl --user start $(basename $1)
    fi
done