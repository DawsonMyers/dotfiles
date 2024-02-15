#!/bin/bash

# # /etc/sysctl.conf
# pip install cpustat

conadac() {
    for f in $(find . -name conda); do
    echo COND = $f
    done
}
# Activates the first venv or conda env found in the current directory or any child directory, in a depth first manner.
function utils::activate_venv() {
    currentDepth=$(pwd | tr -cd '/' | wc -c)
    minDiff=999999 # Initialize with a large value
    minPath=""

    # Perform a depth-first search on the current directory
    while IFS= read -r -d '' dir; do
        echo "$dir"
        # Check if the directory contains an 'activate' script
        if [[ -f "$dir/activate" ]]; then
            dirDepth=$(echo "$dir" | tr -cd '/' | wc -c)
            depthDiff=$(( dirDepth - currentDepth ))
            
            # If this 'activate' script is closer to the current directory, update minPath
            if (( $depthDiff < $minDiff )); then
                minDiff=$depthDiff
                minPath=$dir
            fi
        fi
    done < <(find . -type d \( -path "*/venv/bin" -o -path "*/conda/bin" \) -print0)

    if [[ -n $minPath ]]; then
        source "${minPath}/activate"
        echo "Activated venv at ${minPath}/activate"
    else
        echo "No venv or conda env found"
    fi
}

alias activate_venv='utils::activate_venv '
alias actv='activate_venv '
alias cac='conda activate '

is_alias() {
    alias $1 &>/dev/null
}

is_alias 'e' && unalias 'e'
e() {
    [[ -z $1 ]] && echo "no arg supplied" && return
    local -n ref=$1
    local val="$ref"
    [[ -z $val ]] && { 
        val="$(eval "$1" &> /dev/null)" ||
            { echo not set ; return 1; }
    }
    if [[ -n $1 ]]; then
        echo "$1 = $val"
    fi
}

try_link() {
    local target=$1
    local pointer=$2
    [[ -f $pointer ]] && return
    ln -sv "$target" "$pointer"
}

# Prints out a clickable hyperlink without actually printing the URL.
# https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
hyperlink() {
    local link=$1 label=$2
    # printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'
    printf "\e]8;;$link\e\\$label\e]8;;\e\\\n"
}

# echo utils.sh loaded


timestamp() {
    [[ $1 == *-h* ]] && echo '~/dotfiles/env-utils/utils.sh'
    date +"%Y-%m-%d_%H-%M-%S"
}

alias pingg='ping google.com'

# Re-runs a command forever.
rerun() { while true; do "$@" && echo DONE || echo ERROR; echo 'Restarting in 3...'; sleep 3; done }

# sed 's/:/\n/g' <(echo $PATH)
alias @p="echo $PATH | sed 's/:/\n/g'" @path=@p

split() {
    local delim=' '
    local str=''

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--delim)
                delim="$2"
                shift 2
                ;;
            *)
                echo "Invalid option: $1" >&2
                shift
                ;;
        esac
    done

    str="$1"

    echo "$str" | sed "s/$delim/\n/g"
}