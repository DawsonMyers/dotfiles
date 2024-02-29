#!/bin/bash
# v3

# Global constant variables for color sequences
export ALI_RED='\033[0;31m'
export ALI_GREEN='\033[0;32m'
export ALI_YELLOW='\033[1;33m'
export ALI_CYAN='\033[0;36m'
export ALI_NC='\033[0m' # No color

export ALI_HOME="$HOME/dotfiles/utils/aliaser"
export ALIAS_FILE="$ALI_HOME/aliases.json"

# Functions for log helpers
ali_log_info() {
  echo -e "${ALI_GREEN}INFO:${ALI_NC} $1"
}

ali_log_warn() {
  echo -e "${ALI_YELLOW}WARN:${ALI_NC} $1"
}

ali_log_err() {
  echo -e "${ALI_RED}ERROR:${ALI_NC} $1"
}
alias ali_log_error=ali_log_err

ali_log_verb() {
  echo -e "${ALI_CYAN}VERB:${ALI_NC} $1"
}

ali_func_trace() {
  local caller_info=$(caller)
  local line_number=$(echo "$caller_info" | awk '{print $1}')
  local function_name=$(echo "$caller_info" | awk '{print $2}')
  local file_name=$(basename "${BASH_SOURCE[1]}")

  echo -e "${ALI_CYAN}TRACE:${ALI_NC} $1 (Function: $function_name, Line: $line_number, File: $file_name)"
}

ali_error() {
  log_err "Unknown command: $1"
  # ali help
  return 1
}

# Function for reloading aliases
reload_aliases() {
  # Unalias all existing aliases
  while IFS= read -r ALIAS; do
    alias $ALIAS &> /dev/null &&  unalias "$ALIAS"
  done < <(jq -r 'keys[]' $ALIAS_FILE)

  # Load all aliases
  while IFS= read -r ALIAS; do
    ALIAS_COMMAND=$(jq -r ".$ALIAS" $ALIAS_FILE)
    alias "$ALIAS=$ALIAS_COMMAND"
  done < <(jq -r 'keys[]' "$ALIAS_FILE")
}

# Function for managing aliases
aliaser() {
  local subcommand=$1
  shift

  ali_"$subcommand" "$@"
}

# Subcommand functions
ali_set() {
  if [ ! -s "$ALIAS_FILE" ]; then
    ali_log_info "Creating new alias file at $ALIAS_FILE."
    echo '{}' > "$ALIAS_FILE"
  fi
  if jq -e ".$1" "$ALIAS_FILE" >/dev/null; then
    ali_log_warn "Alias '$1' already exists. It will be overwritten."
  fi

  jq ". + {\"$1\": \"$2\"}" "$ALIAS_FILE" > temp.json &&
    mv temp.json "$ALIAS_FILE" \
    && ali_log_info "Alias '$1' created for command '$2'."
  reload_aliases
}

alias ali_add=ali_set 

ali_get() {
  ALIAS_COMMAND=$(jq -r ".$1" "$ALIAS_FILE")
  if [ "$ALIAS_COMMAND" == "null" ]; then
    ali_log_err "Alias '$1' does not exist."
  else
    ali_log_info "Alias '$1' is for command '$ALIAS_COMMAND'."
  fi
}

ali_init() {
  mkdir -p "${1:-$PWD}"
  echo '{}' > "$ALIAS_FILE"
  ali_log_info "Alias directory initialized at ${1:-$PWD}."
}

ali_list() {
  ALIAS_KEYS=$(jq --color-output '.' "$ALIAS_FILE")
  echo -e "${ALI_CYAN}Existing aliases:${ALI_NC} $ALIAS_KEYS"
}
ali_ls() { ali_list "$@"; }

ali_remove() {
  if jq -e ".$1" "$ALIAS_FILE" >/dev/null; then
    jq "del(.$1)" "$ALIAS_FILE" > temp.json && mv temp.json "$ALIAS_FILE"
    ali_log_info "Alias '$1' has been removed."
    reload_aliases
  else
    ali_log_err "Alias '$1' does not exist."
  fi
}

ali_help() {
  echo -e "${ALI_GREEN}Usage:${ALI_NC}"
  echo -e " aliaser set|add|create <alias> <command>    # Add new alias"
  echo -e " aliaser get <alias>                         # Get the command for an alias"
  echo -e " aliaser init [path to data dir|CWD if empty]# Initialize alias directory"
  echo -e " aliaser ls|list                             # List all aliases"
  echo -e " aliaser rm|remove <alias>                   # Remove an alias"
  echo -e " aliaser help|--help                         # Display this help message"
}

# Load all aliases
reload_aliases

# Create `ali` alias for `aliaser`
alias ali='aliaser'
