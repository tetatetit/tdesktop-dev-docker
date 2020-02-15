#!/bin/bash
set -eu

git clone --recursive https://github.com/telegramdesktop/tdesktop.git

mkdir Libraries
cd Libraries

git clone https://github.com/Kitware/CMake cmake
cd cmake
git checkout v3.16.0
./bootstrap
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://github.com/desktop-app/patches.git
cd patches
git checkout 395b620
cd ../
git clone --branch 0.10.0 https://github.com/ericniebler/range-v3

git clone https://github.com/xiph/opus
cd opus
git checkout v1.3
./autogen.sh
./configure
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://github.com/01org/libva.git
cd libva
./autogen.sh --enable-static
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone git://anongit.freedesktop.org/vdpau/libvdpau
cd libvdpau
git checkout libvdpau-1.2
./autogen.sh --enable-static
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
git checkout release/3.4

./configure --prefix=/usr/local \
--enable-protocol=file --enable-libopus \
--disable-programs \
--disable-doc \
--disable-network \
--disable-everything \
--enable-hwaccel=h264_vaapi \
--enable-hwaccel=h264_vdpau \
--enable-hwaccel=mpeg4_vaapi \
--enable-hwaccel=mpeg4_vdpau \
--enable-decoder=aac \
--enable-decoder=aac_at \
--enable-decoder=aac_fixed \
--enable-decoder=aac_latm \
--enable-decoder=aasc \
--enable-decoder=alac \
--enable-decoder=alac_at \
--enable-decoder=flac \
--enable-decoder=gif \
--enable-decoder=h264 \
--enable-decoder=h264_vdpau \
--enable-decoder=hevc \
--enable-decoder=mp1 \
--enable-decoder=mp1float \
--enable-decoder=mp2 \
--enable-decoder=mp2float \
--enable-decoder=mp3 \
--enable-decoder=mp3adu \
--enable-decoder=mp3adufloat \
--enable-decoder=mp3float \
--enable-decoder=mp3on4 \
--enable-decoder=mp3on4float \
--enable-decoder=mpeg4 \
--enable-decoder=mpeg4_vdpau \
--enable-decoder=msmpeg4v2 \
--enable-decoder=msmpeg4v3 \
--enable-decoder=opus \
--enable-decoder=pcm_alaw \
--enable-decoder=pcm_alaw_at \
--enable-decoder=pcm_f32be \
--enable-decoder=pcm_f32le \
--enable-decoder=pcm_f64be \
--enable-decoder=pcm_f64le \
--enable-decoder=pcm_lxf \
--enable-decoder=pcm_mulaw \
--enable-decoder=pcm_mulaw_at \
--enable-decoder=pcm_s16be \
--enable-decoder=pcm_s16be_planar \
--enable-decoder=pcm_s16le \
--enable-decoder=pcm_s16le_planar \
--enable-decoder=pcm_s24be \
--enable-decoder=pcm_s24daud \
--enable-decoder=pcm_s24le \
--enable-decoder=pcm_s24le_planar \
--enable-decoder=pcm_s32be \
--enable-decoder=pcm_s32le \
--enable-decoder=pcm_s32le_planar \
--enable-decoder=pcm_s64be \
--enable-decoder=pcm_s64le \
--enable-decoder=pcm_s8 \
--enable-decoder=pcm_s8_planar \
--enable-decoder=pcm_u16be \
--enable-decoder=pcm_u16le \
--enable-decoder=pcm_u24be \
--enable-decoder=pcm_u24le \
--enable-decoder=pcm_u32be \
--enable-decoder=pcm_u32le \
--enable-decoder=pcm_u8 \
--enable-decoder=pcm_zork \
--enable-decoder=vorbis \
--enable-decoder=wavpack \
--enable-decoder=wmalossless \
--enable-decoder=wmapro \
--enable-decoder=wmav1 \
--enable-decoder=wmav2 \
--enable-decoder=wmavoice \
--enable-encoder=libopus \
--enable-parser=aac \
--enable-parser=aac_latm \
--enable-parser=flac \
--enable-parser=h264 \
--enable-parser=hevc \
--enable-parser=mpeg4video \
--enable-parser=mpegaudio \
--enable-parser=opus \
--enable-parser=vorbis \
--enable-demuxer=aac \
--enable-demuxer=flac \
--enable-demuxer=gif \
--enable-demuxer=h264 \
--enable-demuxer=hevc \
--enable-demuxer=m4v \
--enable-demuxer=mov \
--enable-demuxer=mp3 \
--enable-demuxer=ogg \
--enable-demuxer=wav \
--enable-muxer=ogg \
--enable-muxer=opus

make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://git.assembla.com/portaudio.git
cd portaudio
git checkout 396fe4b669
./configure
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone git://repo.or.cz/openal-soft.git
cd openal-soft
git checkout openal-soft-1.19.1
cd build
if [ `uname -p` == "i686" ]; then
cmake -D LIBTYPE:STRING=STATIC -D ALSOFT_UTILS:BOOL=OFF ..
else
cmake -D LIBTYPE:STRING=STATIC ..
fi
make $MAKE_THREADS_CNT
sudo make install
cd ../..

git clone https://github.com/openssl/openssl openssl_1_1_1
cd openssl_1_1_1
git checkout OpenSSL_1_1_1-stable
./config --prefix=/usr/local/desktop-app/openssl-1.1.1
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://github.com/xkbcommon/libxkbcommon.git
cd libxkbcommon
git checkout xkbcommon-0.8.4
./autogen.sh
make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone git://code.qt.io/qt/qt5.git qt_5_12_5
cd qt_5_12_5
perl init-repository --module-subset=qtbase,qtimageformats,qtsvg
git checkout v5.12.5
git submodule update qtbase
git submodule update qtimageformats
git submodule update qtsvg
cd qtbase
git apply ../../patches/qtbase_5_12_5.diff
cd src/plugins/platforminputcontexts
git clone https://github.com/desktop-app/fcitx.git
git clone https://github.com/desktop-app/hime.git
git clone https://github.com/desktop-app/nimf.git
cd ../../../..

OPENSSL_DIR=/usr/local/desktop-app/openssl-1.1.1
./configure -prefix "/usr/local/desktop-app/Qt-5.12.5" \
-release \
-force-debug-info \
-opensource \
-confirm-license \
-qt-zlib \
-qt-libpng \
-qt-libjpeg \
-qt-harfbuzz \
-qt-pcre \
-qt-xcb \
-system-freetype \
-fontconfig \
-no-opengl \
-no-gtk \
-static \
-openssl-linked \
-I "$OPENSSL_DIR/include" OPENSSL_LIBS="$OPENSSL_DIR/lib/libssl.a $OPENSSL_DIR/lib/libcrypto.a -ldl -lpthread" \
-nomake examples \
-nomake tests

make $MAKE_THREADS_CNT
sudo make install
cd ..

git clone https://chromium.googlesource.com/external/gyp
cd gyp
git checkout 9f2a7bb1
git apply ../patches/gyp.diff
cd ..

git clone https://chromium.googlesource.com/breakpad/breakpad
cd breakpad
git checkout bc8fb886
git clone https://chromium.googlesource.com/linux-syscall-support src/third_party/lss
cd src/third_party/lss
git checkout a91633d1
cd ../../..
./configure
make $MAKE_THREADS_CNT
sudo make install
cd src
rm -r testing
git clone https://github.com/google/googletest testing
cd tools
sed -i 's/minidump_upload.m/minidump_upload.cc/' linux/tools_linux.gypi
../../../gyp/gyp  --depth=. --generator-output=.. -Goutput_dir=../out tools.gyp --format=cmake
cd ../../out/Default
cmake .
make $MAKE_THREADS_CNT dump_syms
cd ../../..
