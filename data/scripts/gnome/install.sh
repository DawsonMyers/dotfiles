export DF_SCRIPT_DIR="$(dirname $(realpath $BASH_SOURCE))"
! $(log_info &> /dev/null) && . ~/dotfiles/env-utils/log.sh

echo $(
    cd $DF_SCRIPT_DIR
    log_info "Installing Gnome scripts"
    local path
    for s in ./*.sh; do 
        path="$PWD/$s"
        [[ $s =~ install.sh ]] && continue

        log_info "Linking $s in $PWD"
        chmod u+x $s
        
        [[ ! -f $path ]] && ln -sv $PWD/$s ~/.local/share/nautilus/scripts/
    done
)