export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"

# ln -sv "$DOTFILES_DIR/env-utils/aliases.sh" ~/.aliases

for file in $DOTFILES_DIR/configs/linked-to-home/*; do
    [[ $file =~ install.sh ]] && continue
    ln -svf "$file" ~/$(basename $file)
done

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'