for file in $DOTFILES_DIR/configs/linked-to-home/*; do
    [[ $file =~ install.sh ]] && continue
    ln -svf "$file" ~/$(basename $file)
done