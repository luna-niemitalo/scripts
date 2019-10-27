#!/bin/bash
if [ -z "$1" ]
then
	printf "Usage: waifu <Path to image>"
	exit 1
fi
waifu2x-converter-cpp -i "$PWD/$1" -o "$PWD/$1 _x2.png" -p 0
mv "$1" ~/Pictures/old/
