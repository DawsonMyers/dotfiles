#!/bin/bash
export _SCRIPT_DIR="$(dirname $(realpath $BASH_SOURCE))"
chmod u+x $_SCRIPT_DIR/xbanish.service
ln -sv $(realpath $_SCRIPT_DIR/xbanish.service) ~/.config/systemd/user/xbanish.service

# Enable
systemctl reload-units
systemctl --user enable xbanish

systemctl --user start xbanish