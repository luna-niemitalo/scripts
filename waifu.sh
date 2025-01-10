#!/bin/bash
if [ -z "$1" ]; then
	printf "Usage: waifu <Path to image>"
	exit 1
fi

path="$1"
copymode="false"
if [ "$path" == "-c" ]; then
    copymode="true"
    path="$2"
fi



~/waifu2x-ncnn-vulkan/src/build/waifu2x-ncnn-vulkan -i "$PWD/$path" -o "$PWD/$path _x2.png"

if [ $copymode == "true" ]; then
  cp "$path" ~/Pictures/old/
  else
  mv "$path" ~/Pictures/old/
fi
