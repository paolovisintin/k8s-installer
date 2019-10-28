#!/bin/bash

set -e
cd /tmp/
rm -rf rtpengine
mkdir -p rtpengine
cd rtpengine
wget https://github.com/paolovisintin/k8s-installer/raw/master/rtpengine/rtpengine.zip
cd ..
apt-get -qq install debhelper -t bionic-backports \
 && apt-get -qq --no-install-recommends install \
    build-essential \
    net-tools \
    netcat \
    curl \
    jq \
    iptables \
    unzip \
 && rm -Rf /src/rtpengine.zip \
 && rm -Rf /src/rtpengine \
 && mkdir -p /src \
 && unzip rtpengine/rtpengine.zip -d /src/ \
 && mv /src/rtpengine-master/ /src/rtpengine/ \
 && apt-get -qq --no-install-recommends install \
    dkms \
    lsb-release \
    libmysqlclient-dev \
    iptables-dev \
    libavcodec-dev \
    libavcodec-extra \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libcurl4-gnutls-dev \
    libevent-dev \
    libglib2.0-dev \
    libhiredis-dev \
    libjson-glib-dev \
    libiptcdata0-dev \
    libpcap0.8-dev \
    libpcre3-dev \
    libssl-dev \
    libswresample-dev \
    libxmlrpc-core-c3-dev \
    markdown \
    zlib1g-dev \
    libb-hooks-op-check-perl \
    libbencode-perl \
    libcrypt-rijndael-perl \
    libdigest-hmac-perl \
    libexporter-tidy-perl \
    libio-socket-inet6-perl \
    libsocket6-perl \
    module-assistant \
    libsystemd-dev \
    gperf \
    linux-headers-`uname -r` \
 && cd /src/rtpengine/ \
 && perl -p -i -e 's/default-libmysqlclient-dev/libmysqlclient-dev/g' debian/control \
 && perl -p -i -e 's/libiptc-dev/libiptcdata0-dev/g' debian/control \
 && dpkg-buildpackage -uc -us \
 && cd /src \
 && dpkg -i ngcp-rtpengine-daemon_7.1.0.0+0~mr7.1.0.0_amd64.deb \
    ngcp-rtpengine-iptables_7.1.0.0+0~mr7.1.0.0_amd64.deb \
    ngcp-rtpengine-kernel-dkms_7.1.0.0+0~mr7.1.0.0_all.deb

modprobe xt_RTPENGINE || echo "FAILURE"