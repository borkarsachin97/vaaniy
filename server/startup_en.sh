#!/bin/bash
# Unified Bash script for Vaaniy to start the server and monitor files

# Paths to Piper and Voice Model
PIPER_PATH=~/applications/vaaniy/tts/piper
MODEL_PATH=~/applications/vaaniy/tts/voices/en_US-hfc_female-medium.onnx
SAMPLE_RATE=23400
LENGHT_SCALE=0.8

# Paths for named pipe and source/destination files
PIPE_PATH="/tmp/vaaniy_english"
SOURCE_FILE=~/applications/vaaniy/www/vaaniy.com/vaaniy_speech_input
DEST_FILE="$PIPE_PATH"

# Create a named pipe for communication
if [[ ! -p "$PIPE_PATH" ]]; then
    mkfifo "$PIPE_PATH"
fi

# Function to start the Piper server
start_piper() {
    echo "Starting Piper TTS server..."
    tail -F "$PIPE_PATH" 2> /dev/null | "$PIPER_PATH" -q --model "$MODEL_PATH" --length_scale "$LENGHT_SCALE" --stdin --output_raw | pw-play --rate "$SAMPLE_RATE" --channel-map LE -
}

# Function to monitor the source file for changes and copy to named pipe
monitor_file() {
    echo "Starting file monitoring..."
    last_modified_time=$(stat -c '%Y' "$SOURCE_FILE")

    inotifywait -mr --timefmt '%d/%m/%Y %H:%M:%S' --format '%T %w%f' -e modify "$SOURCE_FILE" | while read -r line; do
        current_modified_time=$(stat -c '%Y' "$SOURCE_FILE")

        # Check if the modification time has actually changed
        if [[ "$last_modified_time" != "$current_modified_time" ]]; then
            echo "File modified: $line"
            cp -f "$SOURCE_FILE" "$DEST_FILE"
            last_modified_time="$current_modified_time"
        fi
    done
}

# Run both functions concurrently
start_piper &
monitor_file &

# Wait for both background processes to finish
wait

