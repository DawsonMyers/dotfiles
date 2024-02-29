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
log_info() {
  echo -e "${ALI_GREEN}INFO:${ALI_NC} $1"
}

log_warn() {
  echo -e "${ALI_YELLOW}WARN:${ALI_NC} $1"
}

log_err() {
  echo -e "${ALI_RED}ERROR:${ALI_NC} $1"
}
alias log_error=log_err

log_verb() {
  echo -e "${ALI_CYAN}VERB:${ALI_NC} $1"
}

ali_func_trace() {
  ali_func_trace() {
    local caller_info=$(caller)
    local line_number=$(echo "$caller_info" | awk '{print $1}')
    local function_name=$(echo "$caller_info" | awk '{print $2}')
    local file_name=$(basename "${BASH_SOURCE[1]}")

    echo -e "${ALI_CYAN}TRACE:${ALI_NC} $1 (Function: $function_name, Line: $line_number, File: $file_name)"
  }
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
    alias $ALIAS &> /dev/null && ali_func_trace &&  unalias "$ALIAS"
  done < <(jq -r 'keys[]' $ALIAS_FILE || ali_func_trace "Failed to read keys from $ALIAS_FILE")

  # Load all aliases
  while IFS= read -r ALIAS; do
    ALIAS_COMMAND=$(jq -r ".$ALIAS" $ALIAS_FILE)
    alias "$ALIAS=$ALIAS_COMMAND" || ali_func_trace "Failed to create alias '$ALIAS' for command '$ALIAS_COMMAND'"
  done < <(jq -r 'keys[]' "$ALIAS_FILE")
}

# Function for managing aliases
aliaser() {
  local subcommand=$1
  # local
  case $subcommand in
    # Set|Add|Create new alias
    set|add|create)
      ali_set "$2" "$3"
      ;;

    # Get existing alias
    get)
      ali_get "$2"
      ;;

    # Initialize alias directory
    init)
      ali_init "${2:-$PWD}"
      ;;

    # List all aliases
    ls|list)
      ali_list
      ;;

    # Remove an alias
    rm|remove)
      ali_remove "$2"
      ;;

    # Display help
    help|--help)
      ali_help
      ;;

    *)
      [[ -z $subcommand ]] && log_err "No subcommand supplied." || log_err "Unknown command: $subcommand"
      ali_help
      return 1
      ;;
  esac
}

# Function for setting an alias
ali_set() {
  local alias_name=$1
  local command=$2

  if jq -e ".$alias_name" "$ALIAS_FILE" >/dev/null; then
    log_warn "Alias '$alias_name' already exists. It will be overwritten."
  fi

  if [ ! -s "$ALIAS_FILE" ]; then
    log_info "Creating new alias file at $ALIAS_FILE."
    echo '{}' > "$ALIAS_FILE"
  fi

  jq ". + {\"$alias_name\": \"$command\"}" "$ALIAS_FILE" > temp.json &&
    mv temp.json "$ALIAS_FILE" \
    && log_info "Alias '$alias_name' created for command '$command'."
  reload_aliases
}

# Function for getting an alias
ali_get() {
  local alias_name=$1

  ALIAS_COMMAND=$(jq -r ".$alias_name" "$ALIAS_FILE")
  if [ "$ALIAS_COMMAND" == "null" ]; then
    log_err "Alias '$alias_name' does not exist."
  else
    log_info "Alias '$alias_name' is for command '$ALIAS_COMMAND'."
  fi
}

# Function for initializing alias directory
ali_init() {
  local directory="${1:-$PWD}"
  mkdir -p "$directory"
  echo '{}' > "$ALIAS_FILE"
  log_info "Alias directory initialized at $directory."
}

# Function for listing all aliases
ali_list() {
  ALIAS_KEYS=$(jq keys "$ALIAS_FILE")
  log_info "Existing aliases: $ALIAS_KEYS"
}

# Function for removing an alias
ali_remove() {
  local alias_name=$1

  if jq -e ".$alias_name" "$ALIAS_FILE" >/dev/null; then
    jq "del(.$alias_name)" "$ALIAS_FILE" > temp.json && mv temp.json "$ALIAS_FILE"
    log_info "Alias '$alias_name' has been removed."
    reload_aliases
  else
    log_err "Alias '$alias_name' does not exist."
  fi
}

# Function for displaying help
ali_help() {
  echo -e "${ALI_GREEN}Usage:${ALI_NC}"
  echo -e " aliaser set|add|create <alias> <command>    # Add new alias"
  echo -e " aliaser get <alias>                         # Get the command for an alias"
  echo -e " aliaser init [path to data dir|CWD if empty]# Initialize alias directory"
  echo -e " aliaser ls|list                             # List all aliases"
  echo -e " aliaser rm|remove <alias>                   # Remove an alias"
  echo -e " aliaser help|--help                         # Display this help message"
}

# Create aliases for multiple case conditions
alias ali_set=ali_set
alias ali_add=ali_set
alias ali_create=ali_set
alias ali_get=ali_get
alias ali_init=ali_init
alias ali_ls=ali_list
alias ali_list=ali_list
alias ali_rm=ali_remove
alias ali_remove=ali_remove
alias ali_help=ali_help

# Load all aliases
reload_aliases

# Create `ali` alias for `aliaser`
alias ali='aliaser'
