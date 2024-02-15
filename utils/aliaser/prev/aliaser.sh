#!/bin/bash
# v3

# Global constant variables for color sequences
export ALI_RED='\033[0;31m'
export ALI_GREEN='\033[0;32m'
export ALI_YELLOW='\033[1;33m'
export ALI_CYAN='\033[0;36m'
export ALI_NC='\033[0m' # No color

export ALI_HOME='~/dotfiles/utils/aliaser' # No color

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

# Function for reloading aliases
reload_aliases() {
  # Unalias all existing aliases
  while IFS= read -r alias; do
    alias $alias &> /dev/null &&  unalias "$alias"
  done < <(jq -r 'keys[]' "$ALI_HOME"/aliases.json)

  # Load all aliases
  while IFS= read -r alias; do
    ALIAS_COMMAND=$(jq -r ".$alias" "$ALI_HOME"/aliases.json)
    alias "$alias=$ALIAS_COMMAND"
  done < <(jq -r 'keys[]' "$ALI_HOME"/aliases.json)
}

# Function for managing aliases
aliaser() {
  local subcommand=$1
  # local
  case $subcommand in
    # Set|Add|Create new alias
    set|add|create)
      if jq -e ".$2" "$ALI_HOME"/aliases.json >/dev/null; then
        log_warn "Alias '$2' already exists. It will be overwritten."
      fi
      jq ". + {\"$2\": \"$3\"}" "$ALI_HOME"/aliases.json > temp.json &&
           mv temp.json "$ALI_HOME"/aliases.json } \
          && log_info "Alias '$2' created for command '$3'."
      reload_aliases
      ;;

    # Get existing alias
    get)
      ALIAS_COMMAND=$(jq -r ".$2" "$ALI_HOME"/aliases.json)
      if [ "$ALIAS_COMMAND" == "null" ]; then
        log_err "Alias '$2' does not exist."
      else
        log_info "Alias '$2' is for command '$ALIAS_COMMAND'."
      fi
      ;;

    # Initialize alias directory
    init)
      mkdir -p "${2:-$PWD}"
      echo '{}' > "$ALI_HOME"/aliases.json
      log_info "Alias directory initialized at ${2:-$PWD}."
      ;;

    # List all aliases
    ls|list)
      ALIAS_KEYS=$(jq keys "$ALI_HOME"/aliases.json)
      log_info "Existing aliases: $ALIAS_KEYS"
      ;;

    # Remove an alias
    rm|remove)
      if jq -e ".$2" "$ALI_HOME"/aliases.json >/dev/null; then
        jq "del(.$2)" "$ALI_HOME"/aliases.json > temp.json && mv temp.json "$ALI_HOME"/aliases.json
        log_info "Alias '$2' has been removed."
        reload_aliases
      else
        log_err "Alias '$2' does not exist."
      fi
      ;;

    # Display help
    help|--help)
      echo -e "${ALI_GREEN}Usage:${ALI_NC}"
      echo -e " aliaser set|add|create <alias> <command>    # Add new alias"
      echo -e " aliaser get <alias>                        # Get the command for an alias"
      echo -e " aliaser init [path to data dir|CWD if empty]  # Initialize alias directory"
      echo -e " aliaser ls|list                            # List all aliases"
      echo -e " aliaser rm|remove <alias>                   # Remove an alias"
      echo -e " aliaser help|--help                         # Display this help message"
      ;;

    *)
      [[ -z $subcommand ]] && log_err "No subcommand supplied." || log_err "Unknown command: $subcommand"
      ali help
      return 1
      ;;
  esac
}

# Load all aliases
reload_aliases

# Create `ali` alias for `aliaser`
alias ali='aliaser'
