#!/bin/bash

# Directory to sync
WATCH_DIR="/mnt/ramdisk"
BACKUP_DIR="/home/luna/.cache/ramdisk"

# Sync files to backup
rsync -a --delete "$WATCH_DIR/" "$BACKUP_DIR/"
