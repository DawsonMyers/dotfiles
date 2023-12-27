export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"

for file in $DOTFILES_DIR/configs/linked-to-home/*; do
    [[ $file =~ $BASH_SOURCE ]] && continue
    ln -svf "$file" ~/$(basename $file)
done

for file in $DOTFILES_DIR/**/install.sh; do
    [[ $file =~ $BASH_SOURCE ]] && continue
    . $file0
done


gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'