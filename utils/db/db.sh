#!/bin/bash

# Define color codes
DIMMED='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# The root directory of the repository
repo_dir=$(dirname "${BASH_SOURCE[0]}")

# The path of our database file
utils_db_file="${repo_dir}/db.json"

alias dbdump="cat $repo_dir"
alias echo_opts='eval "[[ $1 == -n && -n $2 ]] && shift && opts=-n"'
log_blue() { echo -e "${BLUE}$*${NC}"; }
log_yellow() { echo -e "${YELLOW}$*${NC}"; }
log_red() { echo -e "${RED}$*${NC}"; }
log_green() { echo -e "${GREEN}$*${NC}"; }
log_cyan() { echo -e "${CYAN}$*${NC}"; }
log_pink() { echo -e "${PINK}$*${NC}"; }
# log_blue() { echo -e "${BLUE}$*${NC}"; }

# Colored logging functions
log() {
    printf "${BLUE}[INFO] ${NC}%s\n" "$1"
}

log_warn() {
    printf "${YELLOW}[WARN] ${NC}%s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR] ${NC}%s\n" "$1"
}

log_debug() {
    printf "${PINK}[DEBUG] ${NC}%s\n" "$1"
}

# Check if jq is installed
check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        log_error "jq could not be found"
        return 1
    fi
}

# Make sure db.json exists
ensure_db_exists() {
    if [ ! -f "$utils_db_file" ]; then
        printf "{}" > "$utils_db_file"
    fi
}

# set operation
_db-set() {
    local key="$1"
    local value="$2"

    check_jq_installed || return 1
    ensure_db_exists

    if [ -z "$key" ] || [ -z "$value" ]; then
        log_error "Missing key or value for set operation"
        return 1
    fi
    local json="$(cat "$utils_db_file")"
    
    # log_debug "json: $json"
    
    local updated_json="$(_jq_set_value "$key" "$value" "$json")"
    # log_debug "updated_json:\n$updated_json"

    [[ -z $updated_json ]] && log_error "jq didn't return any json" && return 1
    echo "$updated_json" > $utils_db_file && 
        log "$key = $value" || 
        log_error "Failed to write json to file."
    # local json_path=".${key//./.}"
    # echo jq "$json_path = \"$value\"" "$utils_db_file" > tmp.json && mv tmp.json "$utils_db_file"
    # jq "$json_path = \"$value\"" "$utils_db_file" > tmp.json && mv tmp.json "$utils_db_file"
    
}

_jq_set_value() {
    local value_is_json=false
    local OPTIND
    while getopts ":j" opt; do
        case "${opt}" in
            j) value_is_json=true ;;
            : ) log_error "Option '${OPTARG}' expects an argument."; return 1 ;;
            \? ) log_error "Invalid option: '${OPTARG}'"; return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    local key="$1"
    local value="$2"
    local json="${3:-'{}'}"
    # [[ -z $json ]] && json='{}'
    local arg_type='arg'
    $value_is_json && arg_type='argjson'
    local val_args=(--arg val "$value")
    # $value_is_json && val_args[0]='--argjson'

    local query=".$key = \$val"
    # local args=("${val_args[@]}" "$query")
    # args+=(".$key =" '$val')
    # log_debug "echo \"$json\" | jq --arg key_path \"$key\" \"${val_args[@]}\" '. | setpath(($key_path |  split(\".\")); $val)'"
    # log_debug <<<-EOS


    local updated_json="$(
        # echo "$json" | 
            jq "${val_args[@]}" "$query" <<<"$json"
        )"
    # local updated_json="$(
    #     echo "$json" | 
    #         jq --arg key_path "$key" "$val_args[@]}" \
    #             '. | setpath(($key_path |  split(".")); $val)'
    #     )"
    echo "$updated_json"
}

json_str_escape() {
    jq -n --arg str "$*" '$str | @json'
}

# get operation
_db-get() {
    local key="$1"
    local raw=true
    # [[ $1 =~ --raw ]] && raw=true && shift

    check_jq_installed || return 1
    ensure_db_exists

    if [ -z "$key" ]; then
        log_warn "No key supplied"
        jq -r "." "$utils_db_file"
        return
    fi

    # -r outputs raw values instead of json strings
    local value
    value=$(jq -r ". | .$key" "$utils_db_file") ||
        log_error "Failed to get json"
    # local json_path=".${key//./.}"
    # value=$(jq -r "$json_path" "$utils_db_file")
    # $raw && echo "$value"|| log_blue "$value"
    echo "$value"
}

# list operation
_db-list() {
    local is_tabular="$1"

    check_jq_installed || return 1
    ensure_db_exists

    if [ "$is_tabular" == "-t" ]; then
        jq -r 'to_entries[] | "\(.key) \(.value)"' "$utils_db_file" | column -t -s ' ' -o ' | '
    else
        jq . "$utils_db_file"
    fi
}

# Show help
_db-help() {
    echo -e "${BLUE}Usage:${NC} db <command> [arguments]

Commands:
    ${YELLOW}set${NC}   <key> <value>    Sets a value in the database.
    ${YELLOW}get${NC}   <key>           Retrieves a value from the database.
    ${YELLOW}ls${NC}    [-t]            Lists keys in the database. Use -t for tabular output.

Options:
    ${YELLOW}-h${NC}, ${YELLOW}--help${NC}       Show this help text.
"
}

# Main db function
db() {
    local command="$1"
    local key="$2"
    local value="$3"

    case "$command" in
        set)
            _db-set "$key" "$value"
            ;;
        get)
            _db-get "$key"
            ;;
        ls|list)
            _db-list "$key"
            ;;
        -h|--help)
            _db-help
            ;;
        i|install)
            _db-install
            ;;
        *)
            log_error "Invalid command: $command"
            _db-help
            return 1
            ;;
    esac
}

# Installation script
install_db() {
    local bashrc="${HOME}/.bashrc"
    local init_path=$(realpath ${BASH_SOURCE[0]})
    [[ $init_path =~ /tmp ]] && log_error "Invalid path for this file: $init_path" && return 1
    if ! grep -q "source $init_path" "$bashrc"; then
        echo "source '$init_path'" >> "$bashrc"
        log "db command installed. Please reload your bashrc or restart your terminal to use it."
    else
        log_warn "db command already installed."
    fi
}

# If the script is invoked with the install argument
if [ "$1" == "install" ]; then
    install_db
fi
