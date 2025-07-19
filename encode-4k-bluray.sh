#!/usr/bin/env bash
# encode-4k-bluray.sh (AMD Radeon VII, VAAPI decode, libx265 encode)

INPUT="$1"         # e.g. /path/to/BDMV/STREAM/00001.m2ts
OUTPUT="$2"        # e.g. movie.4k.mkv
FFMPEG="${FFMPEG:-$HOME/ffmpeg_sources/ffmpeg/ffmpeg}"
# 1. VAAPI decode
# 2. Software deinterlace
# 3. 4K HEVC encode, tuned for film, CRF 18, slow preset
# 4. Preserve audio/subs streams
FILTER="yadif,format=yuv420p"

COMMON_VIDEO_OPTIONS="-vf $FILTER \
-c:v libx265 \
-preset slower \
-g 48 -keyint_min 48 -sc_threshold 0 -bf 3 \
-crf 18 -b:v 0 \
-loglevel warning \
-threads 16 \
-progress pipe:1 \
-x265-params psy-rd=2.0:aq-mode=3"

$FFMPEG -hide_banner -y -i "$INPUT" \
$COMMON_VIDEO_OPTIONS \
-pass 1 -an -f null /dev/null

$FFMPEG -hide_banner -y -i "$INPUT" \
$COMMON_VIDEO_OPTIONS \
-pass 2 \
-c:a copy -c:s copy -map 0 "$OUTPUT"


#$FFMPEG" -hide_banner -y \
#  -vaapi_device /dev/dri/renderD128 \
# -hwaccel vaapi -hwaccel_output_format vaapi \
# -i "$INPUT" \
# -vf 'deinterlace_vaapi,hwdownload,format=yuv420p' \
# -c:v libx265 -preset slow -tune film -crf 18 \
# -c:a copy -c:s copy \
# -map 0 \
# "$OUTPUT"