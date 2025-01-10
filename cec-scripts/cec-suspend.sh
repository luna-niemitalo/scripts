#!/bin/bash
# place in /usr/local/bin/scripts
# Put the display to standby
sudo cec-ctl -d/dev/cec0 --playback --standby --to 0
sleep 1
exit 0
