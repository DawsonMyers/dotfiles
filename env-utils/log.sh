#!/bin/bash
# v3
# Global constant variables for color sequences
export DF_RED='\033[0;31m'
export DF_GREEN='\033[0;32m'
export DF_YELLOW='\033[0;33m'
export DF_CYAN='\033[0;36m'
export DF_BLUE='\033[0;34m'
export DF_PINK='\033[0;35m'
export DF_BRED='\033[1;31m'
export DF_BGREEN='\033[1;32m'
export DF_BYELLOW='\033[1;33m'
export DF_BCYAN='\033[1;36m'
export DF_BBLUE='\033[1;34m'
export DF_BPINK='\033[1;35m'
export DF_NC='\033[0m' # No color
export DF_HOME=~/dotfiles
export DF_LOG=~/dotfiles/env-utils/log.sh
# Functions for log helpers
log_info() {
    echo -e "${DF_GREEN}INFO:${DF_NC} $*"
}
log_warn() {
    echo -e "${DF_YELLOW}WARN:${DF_NC} $*"
}
log_error() {
    echo -e "${DF_RED}ERROR:${DF_NC} $*"
}
alias log_err=log_error
log_verb() {
    echo -e "${DF_CYAN}VERB:${DF_NC} $*"
}
log_blue () 
{ 
    echo -e "${DF_BLUE}$*${NC}"
}
log_yellow () 
{ 
    echo -e "${DF_YELLOW}$*${NC}"
}
log_green () 
{ 
    echo -e "${DF_GREEN}$*${NC}"
}
log_pink () 
{ 
    echo -e "${DF_PINK}$*${NC}"
}

log_debug() {
    echo -e "${DF_PINK}DEBUG:${DF_NC} $*"
}
log_debug_info() {
    echo -e "${DF_PINK}DEBUG:${DF_NC} $*"
}