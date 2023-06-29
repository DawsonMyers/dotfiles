export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"
shopt -s dotglob;

# for file in ~/dotfiles/configs/*; do
#     . "$file"
# done

function source_dir() {
    local file 
    local pattern='*.sh'
    [[ $1 == --init-only ]] && shift && pattern='*init.sh'
    for file in $(find $1 -name "$pattern"); do
    # for file in $HOME/dotfiles/$1/*; do
        echo "init::file $file"
        ll $file
        [[ -d $file ]] && echo 'dir found' && source_dir "$file" && continue
        # [[ -f $file && $file == $pattern$ ]] && . "$file" && echo "Sourced: $file"
        . "$file" # && echo "Sourced: $file"
    done
}

source_dir $DOTFILES_DIR/configs
source_dir $DOTFILES_DIR/env-utils