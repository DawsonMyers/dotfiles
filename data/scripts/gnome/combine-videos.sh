#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    notify-send "Error" "ffmpeg is not installed. Please install ffmpeg first."
    exit 1
fi

# Get the directory of the first selected file to save the output there
OUTPUT_DIR=$(dirname "${1}")
OUTPUT="$OUTPUT_DIR/combined_output.mp4"

# Prepare a temporary file to list inputs for ffmpeg
TEMPFILE=$(mktemp)
for FILE in "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[@]}"; do
# for FILE in "$@"; do
    echo "file '$FILE'" >> "$TEMPFILE"
done

# Use ffmpeg to concatenate the video files
ffmpeg -f concat -safe 0 -i "$TEMPFILE" -c copy "$OUTPUT" 2>&1 | zenity --progress --pulsate --auto-close --title "Combining Videos"

# Check if the ffmpeg command was successful
if [ $? -eq 0 ]; then
    notify-send "Success" "Videos have been combined into $OUTPUT"
else
    notify-send "Error" "Failed to combine videos"
fi

# Clean up
rm "$TEMPFILE"