#!/bin/bash
# place in /usr/local/bin/scripts
# Wake up the display
/bin/cec-ctl -d/dev/cec0 --playback --to 0 --image-view-on

sleep 1

# Switch to HDMI output (using physical address 4.0.0.0)
/bin/cec-ctl -d/dev/cec0 --playback --to 0 --active-source phys-addr=4.0.0.0

sleep 1
exit 0
