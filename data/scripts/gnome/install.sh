#!/usr/bin/env bash
export DF_SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
! $(log_info &> /dev/null) && . ~/dotfiles/env-utils/log.sh

(
    cd "$DF_SCRIPT_DIR" || {
         log_error "script dir not found"; return 1 
         }
    log_info "Installing Gnome scripts"
    shopt -s dotglob
    
    for s in ./*.sh; do 
        path="$PWD/$s"
        [[ $s =~ install.sh ]] && continue

        log_info "Linking $s in $PWD"
        chmod u+x "$s"
        
        [[ ! -f $path ]] && ln -sv "$PWD/$s" ~/.local/share/nautilus/scripts/
    done
    shopt -u dotglob
)