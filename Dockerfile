FROM ubuntu:14.04

RUN sudo apt-get update && apt-get install software-properties-common -y && \
    sudo apt-get install git libexif-dev liblzma-dev libz-dev libssl-dev \
    libgtk2.0-dev libice-dev libsm-dev libicu-dev libdrm-dev dh-autoreconf \
    autoconf automake build-essential libass-dev libfreetype6-dev \
    libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev \
    libvorbis-dev libenchant-dev libxcb1-dev libxcb-image0-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libatspi2.0-dev \
    libxcb-render-util0-dev libxcb-util0-dev libxcb-xkb-dev libxrender-dev \
    libasound-dev libpulse-dev libxcb-sync0-dev libxcb-randr0-dev bison \
    libx11-xcb-dev libffi-dev libncurses5-dev pkg-config texi2html yasm \
    zlib1g-dev xutils-dev python-xcbgen chrpath gperf -y --force-yes && \
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    sudo apt-get update && \
    sudo apt-get install gcc-8 g++-8 -y && \
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 && \
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 60 && \
    sudo update-alternatives --config gcc && \
    sudo add-apt-repository --remove ppa:ubuntu-toolchain-r/test -y

ENV MAKE_THREADS_CNT -j8

RUN mkdir -p /src/TBuild

WORKDIR /src/TBuild
COPY third-party-deps.sh .
RUN ./third-party-deps.sh && \
    find \( \
         -name "*.o" -o \
         -name "*.a" -o \
         -name "*.so" -o \
         -name "*.so.*" \
        \) \
            -exec rm {} \;
