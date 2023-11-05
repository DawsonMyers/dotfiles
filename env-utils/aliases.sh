alias @='echo '

alias sys='sudo systemctl '
alias systatus='sudo systemctl status '
alias sysstart='sudo systemctl start '
alias sysrestart='sudo systemctl restart '
alias sysstop='sudo systemctl stop '
alias sysedit='sudo systemctl --full edit '

alias efstab='sudo nano /etc/fstab'

alias ged='gnome-extensions disable '
alias geh='gnome-extensions --help'
alias gel='gnome-extensions list'
alias geu='gnome-extensions uninstall '
alias src='. ~/.bashrc'
alias ebrc='nano ~/.bashrc'
alias gnome-reset='dconf reset -f /org/gnome/'

alias omp=oh-my-posh

alias aptupd='sudo apt update'
alias aptupg='sudo apt upgrade'
alias apti='sudo apt install '

# export AI=/home/dawson/code/projects/ai
# export OOB=$AI/oobabooga/oobabooga_linux
# export SD=$AI/stable-diffusion/stable-diffusion-webui-aug
# export AI_MODELS=$AI/models

# alias cdai="cd $AI"
# alias cdoob="cd $OOB"
# alias cdsd="cd $SD"
# alias cdmodels="cd $AI_MODELS"

# alias ststart='cd $AI/SillyTavern && ./start.sh'

# alias oconda="$OOB/installer_files/conda/bin/conda "
# alias oac=". $OOB/installer_files/conda/bin/activate"

# alias oacn="conda activate textgen-new"
# # alias oac=". $OOB/installer_files/conda/bin/activate"

# # function oacn() {
# #     conda activate "${1:-textgen-new}"
# # }

# ooba-start() { 
#     cd $OOB
#     conda activate textgen-new
#     eval . $OOB/start.sh "$@"
# }

# alias ostart="oacn && . $OOB/start.sh "
# # function ostart() {
# #     local env_name
# #     [[ $1 =~ -e|--env|-n ]] && env_name="$2" && shift 2
# #     oacn "$env_name" && . $OOB/start.sh
# # }/
# alias oobs=". $OOB/start_linux.sh"


# export SD_HOME=$AI/stable-diffusion/stable-diffusion-webui-aug
# alias cdsd="cd $SD_HOME"
# alias sdstart="conda activate sd && cd $SD_HOME && vactivate && ./webui.sh --autolaunch"

# Python
## conda
alias cls="conda env list"
alias cin="conda install "
alias cinfo="conda info "
alias cinfoe="conda info --env"
alias cenvs="conda info --env"
alias cenv="conda info --env | grep '*' | grep -E '\w+$'"
alias cdac="conda deactivate "
alias cac="conda activate "
export CONDA_HOME=/home/dawson/.local/anaconda3

## pip
alias pipi='pip install '
alias pipif='pip install --force '
alias pipiu='pip install --upgrade '
alias pipiuf='pip install --upgrade --force '
alias pipir='pip install -r requirements.txt '
alias pipiru='pip install -r requirements.txt --upgrade '
# Prints the site-package dir where package are stored.
# - pip -V returns => pip 23.1.2 from /home/dawson/.local/lib/python3.10/site-packages/pip
# - grep extracts '/home/dawson/.local/lib/python3.10/site-packages/pip'
# - sed removes '/pip' returning the just the path to the site-package dir
alias pipdir="pip -V | grep -Eo '/(\w|[-./])+' | sed -e 's_/pip__g'"

alias reinstall-lama='CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install llama-cpp-python --no-cache-dir'
alias ril=reinstall-lama
# AI
alias vcpkg='/home/dawson/code/projects/ai/vcpkg/vcpkg '

# Phone
alias cdsam='cd /run/user/1000/gvfs/mtp:host=SAMSUNG_SAMSUNG_Android_R58M3182R6F'
n=nautilus


# ##########################

alias ged='gnome-extensions disable '
alias geh='gnome-extensions --help'
alias gel='gnome-extensions list'
alias geu='gnome-extensions uninstall '
alias src='. ~/.bashrc'
alias ebrc='nano ~/.bashrc'
alias gnome-reset='dconf reset -f /org/gnome/'

alias omp=oh-my-posh

alias aptupd='sudo apt update'
alias aptupg='sudo apt upgrade'
alias apti='sudo apt install '

# export AI=/home/dawson/code/projects/ai
# export OOB=$AI/oobabooga/oobabooga_linux

# alias cdai="cd $AI"
# alias cdoob="cd $OOB"


# alias oconda=$OOB/installer_files/conda/bin/conda
# alias oac=". $OOB/installer_files/conda/bin/activate"
# alias oacn="conda activate textgen-new"
# # alias oac=". $OOB/installer_files/conda/bin/activate"

# alias ostart="oacn && . $OOB/start.sh"
# # alias ostart=". $OOB/start_linux.sh"
# alias oobs=". $OOB/start_linux.sh"


# export SD_HOME=$AI/stable-diffusion/stable-diffusion-webui-aug
# alias cdsd="cd $SD_HOME"
# alias sdstart="conda activate sd && cd $SD_HOME && vactivate && ./webui.sh --autolaunch"

# Python
## conda
alias cls="conda env list"
alias cin="conda install "
alias cinfo="conda info "
alias cinfoe="conda info --env"
alias cenvs="conda info --env"
alias cenv="conda info --env | grep '*' | grep -E '\w+$'"
alias cdac="conda deactivate "
alias cac="conda activate "
export CONDA_HOME=/home/dawson/.local/anaconda3

## pip
alias pipi='pip install '
alias pipir='pip install -r requirements.txt'
# Prints the site-package dir where package are stored.
# - pip -V returns => pip 23.1.2 from /home/dawson/.local/lib/python3.10/site-packages/pip
# - grep extracts '/home/dawson/.local/lib/python3.10/site-packages/pip'
# - sed removes '/pip' returning the just the path to the site-package dir
alias pipdir="pip -V | grep -Eo '/(\w|[-./])+' | sed -e 's_/pip__g'"


# AI
alias vcpkg='/home/dawson/code/projects/ai/vcpkg/vcpkg '

# Phone
alias cdsam='cd /run/user/1000/gvfs/mtp:host=SAMSUNG_SAMSUNG_Android_R58M3182R6F'
n=nautilus

alias s=sudo

alias gpureload="sudo rmmod -vf nvidia_uvm ; sudo modprobe -v nvidia_uvm"
alias reload-gpu=gpureload