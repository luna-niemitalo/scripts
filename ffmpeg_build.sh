#!/usr/bin/env bash
set -euo pipefail

cd ~/ffmpeg_sources
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
rm -rf ffmpeg
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg

export PATH="$HOME/bin:$PATH"
export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export CC="ccache gcc"
export CXX="ccache g++"
export LD="mold"
export LDFLAGS="-fuse-ld=mold"

./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags=" -march=znver2 -mtune=znver2 -O3 -pipe -fPIC -I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib -fuse-ld=mold" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
    --arch=amd64 \
    --enable-gpl \
    --enable-nonfree \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libdav1d \
    --enable-libx265 \
    --enable-libsvtav1 \
    --enable-libdrm \
    --enable-vaapi \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --disable-stripping \
    --disable-omx

make -j$(nproc)
make install
hash -r
