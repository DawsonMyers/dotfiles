#!/bin/bash

# Global constant variables for color sequences
ALI_RED='\033[0;31m'
ALI_GREEN='\033[0;32m'
ALI_YELLOW='\033[1;33m'
ALI_CYAN='\033[0;36m'
ALI_NC='\033[0m' # No color

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

log_verb() {
  echo -e "${ALI_CYAN}VERBOSE:${ALI_NC} $1"
}

# Function for managing aliases
aliaser() {
  local subcommand=$1

  case $subcommand in
    # Set|Add|Create new alias
    set|add|create)
      jq ". + {\"$2\": \"$3\"}" ~/.local/share/aliaser/aliases.json > temp.json && mv temp.json ~/.local/share/aliaser/aliases.json
      ;;

    # Get existing alias
    get)
      jq -r ".$2" ~/.local/share/aliaser/aliases.json
      ;;

    # Initialize alias directory
    init)
      mkdir -p "${2:-$PWD}"
      echo '{}' > ~/.local/share/aliaser/aliases.json
      ;;

    # List all aliases
    ls|list)
      jq keys ~/.local/share/aliaser/aliases.json
      ;;

    # Remove an alias
    rm|remove)
      jq "del(.$2)" ~/.local/share/aliaser/aliases.json > temp.json && mv temp.json ~/.local/share/aliaser/aliases.json
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
while IFS= read -r alias; do
  ALIAS_COMMAND=$(jq -r ".$alias" ~/.local/share/aliaser/aliases.json)
  alias "$alias=$ALIAS_COMMAND"
done < <(jq -r 'keys[]' ~/.local/share/aliaser/aliases.json)

# Create `ali` alias for `aliaser`
alias ali='aliaser'
