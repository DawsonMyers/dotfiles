#!/bin/bash
export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"

. "$DOTFILES_DIR"/env-utils/log.sh
shopt -s dotglob # include hidden files in globbing
for file in $DOTFILES_DIR/configs/linked-to-home/*; do
    [[ $file =~ ($BASH_SOURCE)|install ]] && continue
    [[ -f $file && $(basename "$file") =~ ^.{1,2}$ ]] &&   mv "$file" "$file.bac"

    ln -sv "$file" "$HOME/$(basename "$file")"
done

for file in $(find $DOTFILES_DIR -name install.sh -type f); do
    [[ $file =~ $BASH_SOURCE ]] && continue
    log_blue "Sourcing $file"
    . "$file"
done
shopt -u dotglob # disable dotglob


gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'

# Install fonts
for i in firacode firamono geistmono hack intelonemono JetBrainsMono Meslo sourcecodepro nerdFontsSymbolsOnly ubuntu ubuntumono; do
    oh-my-posh font install $i
done