chmod u+x xbanish.service
ln -s $(realpath xbanish.service) ~/.config/systemd/user/xbanish.service

# Enable
systemctl reload-units
systemctl --user enable xbanish

systemctl --user start xbanish