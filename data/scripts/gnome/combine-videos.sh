#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    notify-send "Error" "ffmpeg is not installed. Please install ffmpeg first."
    exit 1
fi

# Get the directory of the first selected file to save the output there
OUTPUT_DIR=$(dirname "${1}")
OUTPUT="$OUTPUT_DIR/${1%.*}combined_output.mp4"

# Prepare a temporary file to list inputs for ffmpeg
TEMPFILE=$(mktemp)
iter=0
for FILE in ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[@]}; do
# for FILE in "$@"; do
    ((iter++))
    echo "file '$FILE'" >> "$TEMPFILE"
done
cat "$TEMPFILE" > "$OUTPUT_DIR/combined_output.txt"
echo "[iter=$iter] $*" > "$OUTPUT_DIR/args-$(timestamp).txt"
echo ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[*]} > "$OUTPUT_DIR/NAUTILUS_SCRIPT_SELECTED_FILE_PATHS-$(timestamp).txt"
# echo $PWD > "$OUTPUT_DIR/PWD-$(timestamp).txt"
# Use ffmpeg to concatenate the video files
ifs="$IFS"
export IFS=$'|'
echo "ffmpeg -i \"concat:$(echo ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[*]} | tr '\n' '|'|sed 's/||//g')\" -c copy \"$OUTPUT\" 2>&1 | zenity --progress --pulsate --auto-close --title \"Combining Videos\"" > "$OUTPUT_DIR/ffmpeg-command-$(timestamp).txt"
ffmpeg -i "concat:$(echo ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS[*]} | tr '\n' '|'|sed 's/||//g')" -c:v copy -c:a aac -b:a 128k  "$OUTPUT" 2>&1 | zenity --progress --pulsate --auto-close --title "Combining Videos"
export IFS="$ifs"
# ffmpeg -f concat -safe 0 -i "$TEMPFILE" -c copy "$OUTPUT" 2>&1 | zenity --progress --pulsate --auto-close --title "Combining Videos"

# ffmpeg -i "concat:/mnt/4FEBC5482E67569D/Videos/OF/Anastasia/cam/May17/33.dat|/mnt/4FEBC5482E67569D/Videos/OF/Anastasia/cam/May17/34.dat" -c:v copy -c:a aac -b:a 128k "./combined_output.mp4"


# Check if the ffmpeg command was successful
if [ $? -eq 0 ]; then
    notify-send "Success" "Videos have been combined into $OUTPUT"
else
    notify-send "Error" "Failed to combine videos"
fi

# Clean up
rm "$TEMPFILE"