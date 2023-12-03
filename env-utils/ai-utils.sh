export AI=/home/dawson/code/projects/ai
export OOB=$AI/oobabooga/oobabooga_linux
export SD=$AI/stable-diffusion/stable-diffusion-webui-aug
export AI_MODELS=$AI/models

alias cdai="cd $AI"
alias cdoob="cd $OOB"
alias cdsd="cd $SD"
alias cdmodels="cd $AI_MODELS"

# LD_LIBRARY_PATH="/usr/local/cuda-12.3/lib64:$LD_LIBRARY_PATH"
# PATH="/usr/local/cuda-12.3/lib64:$PATH"

add-ai-model() {
    mv "$1" $AI/models/
}

link_models() {
    [[ $1 =~ sd ]] && echo linking SD models &&
      ln -sv $AI/models/ \
        stable-diffusion $AI/stable-diffusion/stable-diffusion-webui-aug/models &&
        return
    echo linking Oobabooga models
    ln -sv $AI/models $AI/oobabooga/oobabooga_linux/text-generation-webui/models
}

cuda_test() {
    echo 'CUDA available: ' 
    python -c 'import torch; print(torch.cuda.is_available())'
    echo
    echo "(Ran from ~/dotfiles/env-utils/utils.sh)"
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
    cd $AI/SillyTavern-extras 
    ./start.sh "$@"; 
}

ststart() { conda activate stx && cd $AI/SillyTavern && ./start.sh "$@"; }
oconda() { $OOB/installer_files/conda/bin/conda "$@"; }
unalias oac 2> /dev/null
oac() { . $OOB/installer_files/conda/bin/activate; }

# alias oacn="conda activate textgen-new"
# alias oac=". $OOB/installer_files/conda/bin/activate"


unalias oacn 2> /dev/null
oacn() {
    conda activate "${1:-textgen-new}"
}

ooba-start() { 
    cd $OOB
    conda activate textgen-new
    eval . $OOB/start.sh -d "$@"
}
unalias ostart 2> /dev/null
ostart() { oacn && . $OOB/start.sh "$@"; }
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
    conda activate sd 
    cd $SD_HOME 
    vactivate 
    local autolaunch=--autolaunch
    [[ $1 == - ]] && shift && autolaunch=
    ./webui.sh --port 7860 $autolaunch --api "$@"
    }

case $1 in
    o) ostart "$@" ;;
    sd) sdstart "$@" ;;
    stx) stxstart "$@" ;;
    st) ststart "$@" ;;
esac
