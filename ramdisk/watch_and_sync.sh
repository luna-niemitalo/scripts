#!/bin/bash

# Directory to watch and backup
WATCH_DIR="/mnt/ramdisk"
BACKUP_DIR="/home/luna/.cache/ramdisk"

# Threshold for changes before syncing
THRESHOLD=10

# Temp file to track changes
CHANGE_COUNT_FILE="/tmp/ramdisk_change_count"

# Ensure the WATCH_DIR exists
if [ ! -d "$WATCH_DIR" ]; then
    echo "Error: $WATCH_DIR does not exist. Exiting."
    exit 1
fi

# Initialize change count
echo 0 > "$CHANGE_COUNT_FILE"

# Start monitoring
inotifywait -m -r -e modify,create,delete,move "$WATCH_DIR" --format "%e %w%f" | while read event file; do
    # Increment change count
    change_count=$(($(cat "$CHANGE_COUNT_FILE") + 1))
    echo "$change_count" > "$CHANGE_COUNT_FILE"

    # Check if the threshold is reached
    if [ "$change_count" -ge "$THRESHOLD" ]; then
        echo "Syncing changes to backup..."
        rsync -a --delete "$WATCH_DIR/" "$BACKUP_DIR/"
        echo 0 > "$CHANGE_COUNT_FILE" # Reset change count
    fi
done
