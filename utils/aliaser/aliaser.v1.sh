#!/bin/bash

# Color constants for output
readonly ALI_NONE="\033[0m"
readonly ALI_RED="\033[0;31m"
readonly ALI_GREEN="\033[0;32m"
readonly ALI_YELLOW="\033[1;33m"

# Function to log informational message with green color
log_info() {
    echo -e "${ALI_GREEN}[INFO]: $1${ALI_NONE}"
}

# Function to log warning message with yellow color
log_warn() {
    echo -e "${ALI_YELLOW}[WARN]: $1${ALI_NONE}"
}

# Function to log error message with red color
log_err() {
    echo -e "${ALI_RED}[ERROR]: $1${ALI_NONE}"
}

# Function to initialize alias storage
init() {
    local dir=${1:-$(pwd)}
    ALIAS_DIR="$dir/.local/share/aliaser"
    ALIAS_FILE="$ALIAS_DIR/aliases.json"
    mkdir -p $ALIAS_DIR
    if [[ ! -f $ALIAS_FILE ]]; then
        echo '{}' > $ALIAS_FILE
        log_info "🚀 Initialized aliaser at $ALIAS_FILE"
    else
        log_warn "🚀 Aliaser already initialized at $ALIAS_FILE"
    fi
}

# Function to set an alias
set_alias() {
    local name=$1
    shift
    local cmd=$@
    local aliases=$(cat $ALIAS_FILE)
    local new_aliases=$(echo $aliases | jq --arg n "$name" --arg c "$cmd" '. + {($n): $c}')
    echo $new_aliases > $ALIAS_FILE
    log_info "✅ Alias set: $name -> $cmd"
}

# Function to get an alias
get_alias() {
    local name=$1
    local aliases=$(cat $ALIAS_FILE)
    local cmd=$(echo $aliases | jq -r --arg n "$name" '.[$n]')
    if [[ "$cmd" != "null" ]]; then
        log_info "📎 Alias found: $name -> $cmd"
    else
        log_err "❌ Alias not found: $name"
    fi
}

# Function to list all aliases
list_aliases() {
    log_info "📋 Listing all aliases:"
    local aliases=$(cat $ALIAS_FILE)
    echo $aliases | jq -r 'to_entries[] | "\(.key) -> \(.value)"'
}

# Function to remove an alias
remove_alias() {
    local name=$1
    local aliases=$(cat $ALIAS_FILE)
    local new_aliases=$(echo $aliases | jq --arg n "$name" 'del(.[$n])')
    echo $new_aliases > $ALIAS_FILE
    log_info "❌ Removed alias: $name"
}

# Function to print help information
print_help() {
    log_info "🔮 Aliaser usage:"
    echo -e "${ALI_GREEN}set|add|create <alias> <command>${ALI_NONE} - Set a new alias"
    echo -e "${ALI_GREEN}get <alias>${ALI_NONE} - Get an existing alias"
    echo -e "${ALI_GREEN}init [path to data dir|CWD if empty]${ALI_NONE} - Initialize aliaser"
    echo -e "${ALI_GREEN}ls|list${ALI_NONE} - List all aliases"
    echo
}