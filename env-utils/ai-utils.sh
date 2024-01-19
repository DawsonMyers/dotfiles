export AI=/home/dawson/code/projects/ai
export OOB=$AI/oobabooga/text-generation-webui
# export OOB=$AI/oobabooga/oobabooga_linux
export SD=$AI/stable-diffusion/stable-diffusion-webui-aug
export ST=$AI/SillyTavern/SillyTavern
export STX=$AI/SillyTavern/SillyTavern-extras
export AI_MODELS=$AI/models
export CONDA_PATH="$HOME/anaconda3"

alias cdai="cd $AI"
alias cdoob="cd $OOB"
alias cdsd="cd $SD"
alias cd{mo,mod,odels}="cd $AI_MODELS"

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
    python -c 'import torch; print(torch.cuda.is_available())'
    echo
    echo "(Ran from $DOTFILES_DIR/env-utils/utils.sh)"
}
alias ct=cuda_test


ttstart() {
    conda activate stx
    tts-server --model_name tts_models/en/vctk/vits
    # p316 is a girl. Try with this (in conda env stx):
    # tts --text 'fuck me' --model_name tts_models/en/vctk/vits --speaker_id p316  --out_path o.wav && aplay o.wav
}
ttsx() {
    conda activate stx
    tts --text "$1" --model_name ${2:-'tts_models/en/vctk/vits'} --speaker_id p316 --out_path ~/test/tts/o.wav && aplay ~/test/tts/o.wav
}
alias replay='aplay ~/test/tts/o.wav'

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
    [[ $1 == ---fix-deps ]] && pip install -r requirements.txt --upgrade-strategy=only-if-needed
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
    local x_deepspeed= 
    local deep_opt=
    [[ $1 == -d ]] && x_deepspeed=deepspeed && deep_opt=--deepspeed && shift
    # vactivate 
    local autolaunch=--autolaunch
    [[ $1 == - ]] && shift && autolaunch=
    $x_deepspeed ./webui.sh $deep_opt --port 7860 $autolaunch --api --listen --cors-allow-origins=* "$@"
    }

case $1 in
    o) ostart "$@" ;;
    sd) sdstart "$@" ;;
    stx) stxstart "$@" ;;
    st) ststart "$@" ;;
esac
