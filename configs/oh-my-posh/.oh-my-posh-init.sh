export MY_POSH_DIR="$(dirname $(realpath $BASH_SOURCE))"
export POSH_THEME='blueish' # Very good.
export POSH_THEME_PATH=$MY_POSH_DIR/base.yml
export POSH_CONFIG="$POSH_THEME_PATH"
# export POSH_THEME='atomicBit'
# export POSH_THEME='atomic'
# export POSH_THEME='powerlevel10k_classic'
# export POSH_THEME='emodipt-extend'
export POSH_SHELL_VERSION=$BASH_VERSION
export POWERLINE_COMMAND="oh-my-posh"
export POSH_PID=$$
export CONDA_PROMPT_MODIFIER=true
omp_start_time=""

# start timer on command start
PS0='${omp_start_time:0:$((omp_start_time="$(_omp_start_timer)",0))}$(_omp_ftcs_command_start)'
# set secondary prompt
PS2="$(/usr/local/bin/oh-my-posh print secondary --config="$POSH_CONFIG" --shell=bash --shell-version="$BASH_VERSION")"

function _set_posh_cursor_position() {
      # not supported in Midnight Commander
    # see https://github.com/JanDeDobbeleer/oh-my-posh/issues/3415
    # if [[ "false" != "true" ]] || [[ -v MC_SID ]]; then
    #     return
    # fi

    local oldstty=$(stty -g)
    stty raw -echo min 0

    local COL
    local ROW
    IFS=';' read -sdR -p $'\E[6n' ROW COL

    stty $oldstty

    export POSH_CURSOR_LINE=${ROW#*[}
    export POSH_CURSOR_COLUMN=${COL}
}

function _omp_start_timer() {
    /usr/local/bin/oh-my-posh get millis
}

function _omp_ftcs_command_start() {
    if [ "false" == "true" ]; then
        printf "\e]133;C\a"
    fi
}

# template function for context loading
function set_poshcontext() {
    return
}

function _omp_hook() {
    local ret=$?
    local omp_stack_count=$((${#DIRSTACK[@]} - 1))
    local omp_elapsed=-1
    local no_exit_code="true"
    if [[ -n "$omp_start_time" ]]; then
        local omp_now=$(/usr/local/bin/oh-my-posh get millis --shell=bash)
        omp_elapsed=$((omp_now-omp_start_time))
        omp_start_time=""
        no_exit_code="false"
    fi
    set_poshcontext
    _set_posh_cursor_position
    PS1="$(/usr/local/bin/oh-my-posh print primary --config="$POSH_CONFIG" --shell=bash --shell-version="$BASH_VERSION" --error="$ret" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --no-exit-code="$no_exit_code" | tr -d '\0')"
    return $ret
}

if [ "$TERM" != "linux" ] && [ -x "$(command -v /usr/local/bin/oh-my-posh)" ] && ! [[ "$PROMPT_COMMAND" =~ "_omp_hook" ]]; then
    PROMPT_COMMAND="_omp_hook; $PROMPT_COMMAND"
fi

if [ "false" == "true" ]; then
    echo ""
fi


eval $(oh-my-posh init bash --config $POSH_CONFIG)

# eval $(oh-my-posh init bash --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$POSH_CONFIG.omp.json")


function _set_posh_cursor_position() {
      # not supported in Midnight Commander
    # see https://github.com/JanDeDobbeleer/oh-my-posh/issues/3415
    # if [[ "false" != "true" ]] || [[ -v MC_SID ]]; then
    #     return
    # fi

    local oldstty=$(stty -g)
    stty raw -echo min 0

    local COL
    local ROW
    IFS=';' read -sdR -p $'\E[6n' ROW COL

    stty $oldstty

    export POSH_CURSOR_LINE=${ROW#*[}
    export POSH_CURSOR_COLUMN=${COL}
}

# function _omp_start_timer() {
#     /usr/local/bin/oh-my-posh get millis
# }

# function _omp_ftcs_command_start() {
#     if [ "false" == "true" ]; then
#         printf "\e]133;C\a"
#     fi
# }

# # template function for context loading
# function set_poshcontext() {
#     return
# }

# function _omp_hook() {
#     local ret=$?
#     local omp_stack_count=$((${#DIRSTACK[@]} - 1))
#     local omp_elapsed=-1
#     local no_exit_code="true"
#     if [[ -n "$omp_start_time" ]]; then
#         local omp_now=$(/usr/local/bin/oh-my-posh get millis --shell=bash)
#         omp_elapsed=$((omp_now-omp_start_time))
#         omp_start_time=""
#         no_exit_code="false"
#     fi
#     set_poshcontext
#     _set_posh_cursor_position
#     PS1="$(/usr/local/bin/oh-my-posh print primary --config="$POSH_CONFIG" --shell=bash --shell-version="$BASH_VERSION" --error="$ret" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --no-exit-code="$no_exit_code" | tr -d '\0')"
#     return $ret
# }

# if [ "$TERM" != "linux" ] && [ -x "$(command -v /usr/local/bin/oh-my-posh)" ] && ! [[ "$PROMPT_COMMAND" =~ "_omp_hook" ]]; then
#     PROMPT_COMMAND="_omp_hook; $PROMPT_COMMAND"
# fi

# if [ "false" == "true" ]; then
#     echo ""
# fi

