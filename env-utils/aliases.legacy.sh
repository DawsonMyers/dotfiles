export EDITOR='code -nw '

# Shortcuts

alias reload="source ~/.bash_profile"
alias _="sudo"
alias g="git"
alias rr="rm -rf"

# Default options

alias rsync="rsync -vh"
alias json="json -c"
alias psgrep="psgrep -i"

# Global aliases
is-supported() {
    type "$1" &> /dev/null
}
if $(is-supported "alias -g"); then
  alias -g G="| grep -i"
  alias -g H="| head"
  alias -g T="| tail"
  alias -g L="| less"
fi

# List declared aliases, functions, paths

alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

# Directory listing/traversal

LS_COLORS=$(is-supported "ls --color" --color -G)
LS_TIMESTYLEISO=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
LS_GROUPDIRSFIRST=$(is-supported "ls --group-directories-first" --group-directories-first)

alias l="ls -lahA $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
alias ll="ls -lA $LS_COLORS"
alias lt="ls -lhAtr $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
alias ld="ls -ld $LS_COLORS */"
alias lp="stat -c '%a %n' *"

unset LS_COLORS LS_TIMESTYLEISO LS_GROUPDIRSFIRST

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# npm

alias ni="npm install"
alias nu="npm uninstall"
alias nri="rm -r node_modules && npm install"
alias ncd="npm-check -su"

# Network

alias ip="curl -s ipinfo.io | jq -r '.ip'"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Miscellaneous

alias hosts="sudo $EDITOR /etc/hosts"
alias quit="exit"
alias week="date +%V"
alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"
alias grip="grip --browser --user=webpro --pass=$GITHUB_TOKEN"

# =====================

export EDITOR='code -nw '

update_title_with_directory() {
    'echo -ne "\033]0;$(basename ${PWD})\007"'
}

set-title() {
    echo -ne "\033]0;$*\007"
}
alias st=set-title

# Network
alias n="netstat -np tcp"
alias mtr="mtr -t"
alias nmap="nmap -v -v -T5"
alias nmapp="nmap -P0 -A --osscan_limit"
alias pktstat="sudo pktstat -tBFT"
# List listening ports
alias lports="sudo lsof -i -P -n | grep LISTEN"

# Copy to clipboard.
alias setclip="xclip -selection c"
# Paste from clipboard.
alias getclip="xclip -selection c -o"

######################
# CUSTOM STARTS HERE #
######################

# Define a few Colours
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'

PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m' # No Color
BBLUE="\033[1;34m"

###########
# Aliases #
###########

# ls 
alias ls='ls --color=auto -a'
alias ll='ls -lha' # long format (l) and human readable file sizes (h)
alias la='ls -Alah'
alias l='ls -CFa'

# Dir 
alias home='cd'
alias documents='cd ~/documents'
alias downloads='cd ~/downloads'
alias linuxdoc='cd ~/linuxdoc'
alias music='cd ~/music'
alias pix='cd ~/pictures'
alias root='sudo -i'

# Sudo
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias purge='sudo apt-get remove --purge'
alias update='sudo apt-get update'
alias clean='sudo apt-get autoclean && sudo apt-get autoremove'
alias sources='(gksudo code /etc/apt/sources.list &)'

# chmod and permissions commands
alias mx='chmod a+x'
alias 000='chmod 000'
alias 644='chmod 644'
alias 755='chmod 755'

# Misc
# alias a='alias'
alias c='clear'
alias h='htop'
alias x='exit'
alias bg='code ~/.bashrc'
alias pci='lspci'
alias ksf='killall swiftfox-bin'
alias del='rm --target-directory=$HOME/.Trash/'
alias font='fc-cache -v -f'

# Custom Oracle related
alias root='/usr/local/packages/aime/ias/run_as_root "su root"'

#Automatically do an ls after each cd
#cd() {
#  if [ -n "$1" ]; then
#    builtin cd "$@" && ll
#  else
#    builtin cd ~ && ll
#  fi
#}

##################
# WELCOME SCREEN #
##################

#clear
#echo -ne "Hello, $USER. today is, "; date
#export PS1="\[\e]2;\u@\H \w\a\e[30;1m\]>\[\e[0m\] "
#export PS1="\[\e]2;\u@\H \w\a\n----\nPath:\w (bash)\n----\n\u@\H $> \]"



## Applications
alias cal="cal -m -3"
# Copy to clipboard.
alias xclips="xclip -selection c"

## Git
alias git="nice git"
alias gst="git stash"
alias gsta="git status --short --branch"
#alias gsu="git submodule update --recursive --merge"
alias gdf="git diff"
alias gdt="git difftool"
alias glo="git log"
alias gps="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gci="git commit"
alias gad="git add"
alias grm="git rm"
alias gmv="git mv"
alias gtg="git tag"
alias gbr="git branch"
alias gs="git svn"

# Mine
alias gsu="git submodule update"
alias gsui="git submodule update --init"
alias gsur="git submodule update --recursive"
alias gsuir="git submodule update --init --recursive"
alias gsure="git submodule update --remote"
alias gpr="git pull --rebase origin"
alias gprm="git pull --rebase origin main"
alias gcb="git checkout -b"
alias gpsf="git push -f"
alias gmc='git merge --continue'
alias gma='git merge --abort'
alias gms='git merge --skip'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grs='git rebase --skip'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcps='git cherry-pick --skip'
alias gca='/*000git commit --amend --no-edit'
alias gcln='git clean -xfd'
alias gcl='git clone '
# Shows the number of files changed and number of lines added/removed since the last commit.
alias gdiff='git diff --shortstat HEAD'
alias glog='git log --graph --oneline --decorate'


# Shows the number of of changes between head and n commits back
gdiffn() {
    local n=$1
    echo "git diff --shortstat HEAD~${n} HEAD"
    git diff --shortstat HEAD~${n} HEAD
}
gdiffhash() {
    local n=$1
    echo "git diff --shortstat $n HEAD"
    git diff --shortstat $n HEAD
}
gdiffo() {
    # Gets the diff between local and remote branch.
    local cur_branch=$(git rev-parse --abbrev-ref HEAD)
    git diff --shortstat origin/$cur_branch HEAD
}