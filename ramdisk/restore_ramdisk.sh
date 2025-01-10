#!/bin/bash

# Directory to restore
WATCH_DIR="/mnt/ramdisk"
BACKUP_DIR="/home/luna/.cache/ramdisk"

# Create the ramdisk
mount -o size=10G -t tmpfs none "$WATCH_DIR"

# Restore files from backup
rsync -a "$BACKUP_DIR/" "$WATCH_DIR/"
