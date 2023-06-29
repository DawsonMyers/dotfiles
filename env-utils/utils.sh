#!/bin/bash

# # /etc/sysctl.conf
# pip install cpustat

conadac() {
    for f in $(find . -name conda); do
    echo COND = $f
    done
}

function activate_venv() {
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

# Prints out a clickable hyperlink without actually printing the URL.
# https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
hyperlink() {
    local link=$1 label=$2
    # printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'
    printf "\e]8;;$link\e\\$label\e]8;;\e\\\n"
}

# echo utils.sh loaded