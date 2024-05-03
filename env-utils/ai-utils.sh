export AI_UTILS='/home/dawson/dotfiles/env-utils/ai-utils.sh'
export AI=/home/dawson/code/projects/ai
export OOB=$AI/oobabooga/text-generation-webui
export OOB1=$AI/oobabooga/tg
# export OOB=$AI/oobabooga/oobabooga_linux
export SD=$AI/stable-diffusion/stable-diffusion-webui-aug
export ST=$AI/SillyTavern/SillyTavern
export STX=$AI/SillyTavern/SillyTavern-extras
export AI_MODELS=$AI/models
export CONDA_PATH="$HOME/anaconda3"

export CUDA_VISIBLE_DEVICES=1

alias eai="code $AI_UTILS"
alias cdai="cd $AI"
alias cdoob="cd $OOB"
alias cdsd="cd $SD"
alias cd{mo,mod,odels}="cd $AI_MODELS"

alias eai='code /home/dawson/dotfiles/env-utils/ai-utils.sh'

# LD_LIBRARY_PATH="/usr/local/cuda-12.3/lib64:$LD_LIBRARY_PATH"
# PATH="/usr/local/cuda-12.3/lib64:$PATH"

retry() {
    local n=5
    local max=5
    local delay=5s

    if [[ $1 =~ -f|--forever ]]; then
        shift
        while true; do
            "$@" && log_green "retry(ai-utils.sh): command ran successfully" || log_error "retry(ai-utils.sh): command returned non-zero exit code" 
            log_green "retry(ai-utils.sh): Retry #$n"
            log_info "retry(ai-utils.sh): waiting $delay before next attempt..."
            sleep $delay;
        done
        return
    fi

    while true; do        
        "$@" || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "Command failed. Attempt $n/$max:"
            fi
        }
            log_green "retry(ai-utils.sh): Retry #$n starting in $delay..."
            sleep $delay;
    done
}

add-ai-model() {
    mv "$1" $AI/models/
}

link_models() {
    [[ $1 =~ sd ]] && echo linking SD models &&
      ln -sv $AI/models \
        stable-diffusion $AI/stable-diffusion/stable-diffusion-webui-aug/models &&
        return
    echo linking Oobabooga models
    ln -sv $AI/models $OOB/
    ln -sv $AI/models/.characters $OOB/characters
    # ln -sv $AI/models $AI/oobabooga/oobabooga_linux/text-generation-webui/models
}

cuda_test() {
    echo 'CUDA available: ' 
    python3 -c 'import torch; print(torch.cuda.is_available())'
    echo
    echo "(Ran from $DOTFILES_DIR/env-utils/utils.sh)"
}
alias ct=cuda_test


ttstart() {
    conda activate tts
    tts-server --model_name tts_models/en/vctk/vits 
    # p316 is a girl. Try with this (in conda env stx):
    # tts --text 'fuck me' --model_name tts_models/en/vctk/vits --speaker_id p316  --out_path o.wav && aplay o.wav
}

timestamp () 
{ 
    # [[ $1 == *-h* ]] && echo '~/dotfiles/env-utils/utils.sh';
    date +"%Y-%m-%d_%H-%M-%S"
}

last_tts=
ttsx() {
    conda activate tts
    mkdir -p ~/tts/keybind
    last_tts=$(timestamp)
    echo "$last_tts" > ~/tts/keybind/last
    tts --text "$1" --model_name ${2:-'tts_models/en/vctk/vits'} --speaker_id p316 --out_path $last_tts && aplay $last_tts
}
alias replay="aplay $(cat ~/tts/keybind/last)"

# ststart() { cd $AI/SillyTavern && ./start.sh; }
stxstart() { 
    conda activate stx 
    cd $AI/SillyTavern/SillyTavern-extras 
    ./start.sh "$@"; 
}

ststart() { conda activate stx && cd $AI/SillyTavern/SillyTavern && ./start.sh "$@"; }
oconda() { $OOB/installer_files/conda/bin/conda "$@"; }
unalias oac 2> /dev/null
oac() { 
    # . $OOB/installer_files/conda/bin/activate;
    conda activate tg
}

# alias oacn="conda activate textgen-new"
# alias oac=". $OOB/installer_files/conda/bin/activate"

pipifix() {
    pip install -r requirements.txt --upgrade-strategy=only-if-needed
}
unalias oacn 2> /dev/null
oacn() {
    conda activate "${1:-tg}"
}

ooba-start() { 
    cd "$OOB"
    conda activate textgen-new
    eval . "$OOB"/start.sh -d "$@"
}
unalias ostart 2> /dev/null
ostart() { 
    cd $OOB
    conda activate tg
    export CUDA_VISIBLE_DEVICES=1
    [[ $1 == --fix-deps ]] && pip install -r requirements.txt --upgrade-strategy=only-if-needed
    retry -f bash $OOB/start.sh "$@"; 
}

oostart() {
    ostart --model "dolphin-2.8-mistral-7b-v02-Q8_0.gguf" "$@"
}

ostart1() { 
    cd $OOB
    conda activate tg1
    export CUDA_VISIBLE_DEVICES=1
    [[ $1 == --fix-deps ]] && pip install -r requirements.txt --upgrade-strategy=only-if-needed
    retry -f bash $OOB/start.sh "$@"; 
}

    # oacn && bash $OOB/start.sh "$@"; }
# function ostart() {
#     local env_name
#     [[ $1 =~ -e|--env|-n ]] && env_name="$2" && shift 2
#     oacn "$env_name" && . $OOB/start.sh
# }/
unalias oobs 2> /dev/null
oobs() { . $OOB/start_linux.sh; }


export SD_HOME=$AI/stable-diffusion/stable-diffusion-webui-aug
unalias cdsd 2> /dev/null
cdsd() { cd $SD_HOME; }

unalias sdstart 2> /dev/null
sdstart() { 
    cd $SD_HOME 
    conda activate sd || { log_error "failed to activate env sd"; return 1; }
    [[ $1 == ---fix-deps ]] && shift && pip install -r requirements.txt
    local args=
    [[ $1 == -i ]] && shift && args=--skip-install
    local x_deepspeed= 
    local deep_opt=
    [[ $1 == -d ]] && x_deepspeed=deepspeed && deep_opt=--deepspeed && shift
    # vactivate 
    local autolaunch=--autolaunch
    [[ $1 == - ]] && shift && autolaunch=
    $x_deepspeed ./webui.sh $deep_opt --port 7860 $autolaunch --api --cors-allow-origins='*' --enable-insecure-extension-access $args "$@"
}

unalias lol 2> /dev/null
lol() {
    cd "$AI/lollms"
    conda activate "${1:-lollms}"
    python app.py
}

kobold() {
    cd "$AI/koboldcpp"
    ./koboldcpp --config ./kobold-settings.kcpps "$@"
}
kstart() { kobold "$@"; }

aistart() {
    mux start ai
}

case $1 in
    o) ostart "$@" ;;
    sd) sdstart "$@" ;;
    stx) stxstart "$@" ;;
    st) ststart "$@" ;;
esac

