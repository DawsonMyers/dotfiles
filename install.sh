export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"

ln -sv "$DOTFILES_DIR/env-utils/aliases.sh" ~/.aliases

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'