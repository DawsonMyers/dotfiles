#!/bin/bash
alias cur_file_path='"$(dirname $(realpath $BASH_SOURCE))"'

export DOTFILES_DIR="$(dirname $(realpath $BASH_SOURCE))"

shopt -s dotglob;

# for file in ~/dotfiles/configs/*; do
#     . "$file"
# done

! $(log_info &> /dev/null) && . "$DOTFILES_DIR/env-utils/log.sh"

function source_dir() {
    local file 
    local pattern='*.sh'
    [[ $1 == --init-only ]] && shift && pattern='*init.sh'
    for file in $(find $1 -name "$pattern"); do
    # for file in $HOME/dotfiles/$1/*; do
        # echo "init::file $file"
        [[ $file =~ install.sh ]] && continue
        . "$file" # && echo "Sourced: $file"
    done
}

# source_dir --init-only $DOTFILES_DIR/configs
source_dir $DOTFILES_DIR/env-utils
# source_dir $DOTFILES_DIR/env-utils

