#!/bin/bash
# conda activate tts

timestamp () 
{ 
    # [[ $1 == *-h* ]] && echo '~/dotfiles/env-utils/utils.sh';
    date +"%Y-%m-%d_%H-%M-%S"
}

last_tts=
ttsx() {
    (
        mkdir -p ~/tts/keybind
        cd ~/tts
        conda activate tts
        last_tts=$(timestamp)
        echo "Audio file: ~/tts/$last_tts"
        echo "$last_tts" > ~/tts/keybind/last
        tts --text "$1" --model_name ${2:-'tts_models/en/vctk/vits'} --speaker_id p316 --out_path $last_tts && aplay $last_tts
        while read -p 'Repeat?' ; do 
            aplay $last_tts
        done
    )
}

# Get selected text (if any)
selected_text=$(xsel -o)
if [[ -n $1 ]]; then
    ttsx "$1"

# Check if selected text is not empty
elif [ -n "$selected_text" ]; then
    # Use espeak to read the selected text aloud
   # echo "$selected_text" | espeak
	ttsx "$selected_text"
else
    # Get text from clipboard
    clipboard_text=$(xclip -selection clipboard -o)

    # Check if clipboard text is not empty
    if [ -n "$clipboard_text" ]; then
        # Use espeak to read the text from clipboard aloud
#        echo "$clipboard_text" | espeak
	ttsx "clipboard_text"
    else
        echo "No text selected or in clipboard!"
    fi
fi
