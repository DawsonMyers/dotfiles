#!/bin/bash
#Aliaser v2
# Global constant variables for color sequences
ALI_RED='\033[0;31m'
ALI_GREEN='\033[0;32m'
ALI_YELLOW='\033[1;33m'
ALI_CYAN='\033[0;36m'
ALI_NC='\033[0m' # No color

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

ali_log_verb() {
  echo -e "${ALI_CYAN}VERBOSE:${ALI_NC} $1"
}

# Function for managing aliases
aliaser() {
  local subcommand=$1
  ali_log_info "Running aliaser with subcommand '$subcommand'..."
  case $subcommand in
    # Set|Add|Create new alias
    set|add|create)
      (
         cd ~/.local/share/aliaser/
         ali_log_info "Adding new alias '$2' with command '$3'..."
         jq ". + {\"$2\": \"$3\"}" ~/.local/share/aliaser/aliases.json > temp.json && mv temp.json ~/.local/share/aliaser/aliases.json
      )
      
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
      (
         cd ~/.local/share/aliaser/
        jq "del(.$2)" ~/.local/share/aliaser/aliases.json > temp.json && mv temp.json ~/.local/share/aliaser/aliases.json
      )
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
      [[ -z $subcommand ]] && ali_log_err "No subcommand supplied." || ali_log_err "Unknown command: $subcommand"
      ali help
      return 1
      ;;
  esac
}

ali() { aliaser "$@"; }

# Load all aliases
while IFS= read -r alias_name; do
  ALIAS_COMMAND=$(jq -r ".$alias_name" ~/.local/share/aliaser/aliases.json)
  alias "$alias_name=$ALIAS_COMMAND"
done < <(jq -r 'keys[]' ~/.local/share/aliaser/aliases.json)

# Create `ali` alias for `aliaser`
alias ali='aliaser'


if [[ $BASH_SOURCE =~ local/bin/aliaser ]]; then
  aliaser "$@"
fi