shopt -s dotglob;

# for file in ~/dotfiles/configs/*; do
#     . "$file"
# done

function source_dir() {
    for file in ~/dotfiles/$1/*; do
        . "$file"
    done
}

source_dir configs
source_dir env-utils