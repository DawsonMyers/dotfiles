#!/bin/bash

# Define color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# The root directory of the repository
repo_dir=$(dirname "${BASH_SOURCE[0]}")

# The path of our database file
db_file="${repo_dir}/db.json"

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

# Check if jq is installed
check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        log_error "jq could not be found"
        return 1
    fi
}

# Make sure db.json exists
ensure_db_exists() {
    if [ ! -f "$db_file" ]; then
        printf "{}" > "$db_file"
    fi
}

# set operation
db-set() {
    local key="$1"
    local value="$2"

    check_jq_installed || return 1
    ensure_db_exists

    if [ -z "$key" ] || [ -z "$value" ]; then
        log_error "Missing key or value for set operation"
        return 1
    fi
    local json_path=".${key//./.}"
    jq "(\"$json_path\") |= \"$value\"" "$db_file" > tmp.json && mv tmp.json "$db_file"
    log "Set $key = $value"
}

# set operation help
db-set-help() {
    echo -e "${BLUE}Usage:${NC} db set <key> <value>

This command sets a value in the database.
Keys are specified as dot-separated paths (e.g. a.b.c).
"
}

# get operation
db-get() {
    local key="$1"

    check_jq_installed || return 1
    ensure_db_exists

    if [ -z "$key" ]; then
        log_error "Missing key for get operation"
        return 1
    fi
    local json_path=".${key//./.}"
    local value
    value=$(jq -r "$json_path" "$db_file")
    log "Get $key = $value"
}

# get operation help
db-get-help() {
    echo -e "${BLUE}Usage:${NC} db get <key>

This command retrieves a value from the database.
Keys are specified as dot-separated paths (e.g. a.b.c).
"
}

# list operation
db-list() {
    local is_tabular="$1"

    check_jq_installed || return 1
    ensure_db_exists

    if [ "$is_tabular" == "-t" ]; then
        jq -r 'to_entries[] | "\(.key) \(.value)"' "$db_file" | column -t -s ' ' -o ' | '
    else
        jq . "$db_file"
    fi
}

# list operation help
db-list-help() {
    echo -e "${BLUE}Usage:${NC} db ls [-t]

This command lists keys in the database. 
Use -t for tabular output.
"
}

# Main db function
db() {
    local command="$1"
    local key="$2"
    local value="$3"

    case "$command" in
        set)
            if [ "$key" == "--help" ] || [ "$key" == "-h" ]; then
                db-set-help
            else
                db-set "$key" "$value"
            fi
            ;;
        get)
            if [ "$key" == "--help" ] || [ "$key" == "-h" ]; then
                db-get-help
            else
                db-get "$key"
            fi
            ;;
        ls|list)
            if [ "$key" == "--help" ] || [ "$key" == "-h" ]; then
                db-list-help
            else
                db-list "$key"
            fi
            ;;
        -h|--help)
            db-help
            ;;
        *)
            log_error "Invalid command: $command"
            db-help
            return 1
            ;;
    esac
}

# Main db function help
db-help() {
    echo -e "${BLUE}Usage:${NC} db <command> [arguments]

Commands:
    ${YELLOW}set${NC}   <key> <value>    Sets a value in the database.
    ${YELLOW}get${NC}   <key>           Retrieves a value from the database.
    ${YELLOW}ls${NC}    [-t]            Lists keys in the database. Use -t for tabular output.

Options:
    ${YELLOW}-h${NC}, ${YELLOW}--help${NC}       Show this help text or help text for a specific command.
"
}

# Installation script
install_db() {
    local bashrc="${HOME}/.bashrc"
    if ! grep -q "source $(realpath ${BASH_SOURCE[0]})" "$bashrc"; then
        echo "source $(realpath ${BASH_SOURCE[0]})" >> "$bashrc"
        log "db command installed. Please reload your bashrc or restart your terminal to use it."
    else
        log_warn "db command already installed."
    fi
}

# If the script is invoked with the install argument
if [ "$1" == "install" ]; then
    install_db
fi
