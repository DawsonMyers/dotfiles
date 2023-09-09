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

