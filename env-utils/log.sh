#!/bin/bash
# v3
# Global constant variables for color sequences
export DF_RED='\033[0;31m'
export DF_GREEN='\033[0;32m'
export DF_YELLOW='\033[1;33m'
export DF_CYAN='\033[0;36m'
export DF_NC='\033[0m' # No color
export DF_HOME=~/dotfiles
export DF_LOG=~/dotfiles/env-utils/log.sh
# Functions for log helpers
log_info() {
    echo -e "${DF_GREEN}INFO:${DF_NC} $1"
}
log_warn() {
    echo -e "${DF_YELLOW}WARN:${DF_NC} $1"
}
log_error() {
    echo -e "${DF_RED}ERROR:${DF_NC} $1"
}
alias log_err=log_error
log_verb() {
    echo -e "${DF_CYAN}VERB:${DF_NC} $1"
}