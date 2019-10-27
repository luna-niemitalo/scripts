#!/bin/bash

if ! [ -x "$(command -v wal)" ]; then
    echo "Requires WAL. Install from: https://github.com/dylanaraps/pywal"
    exit 1
fi

if ! [ -x "$(command -v feh)" ]; then
    echo "Requires FEH. Install: sudo apt install feh"
    exit 1
fi

if [$1 = ""]
then
	printf "Usage: wallpaper <Path to image> <int color override for cava>\n       Cava input variable defaults to 5. \n       You can see all available colors from wallpaper by running the script once amd get the index by counting from left to right"
	exit 1
fi
wal -i "$1"

row=$2
color=`sed ${row:-5}'q;d' ~/.cache/wal/colors`
#echo $color
pkill cava
sed -i "s/foreground.*/foreground = '${color}'/" ~/.config/cava/config
sleep 1
nohup tilda &
