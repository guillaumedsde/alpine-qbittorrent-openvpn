#!/bin/sh
set -x
ARCH="$(uname -m)"
echo "building for ${ARCH}"

QBITTORRENT_VERSION=4.3.5
LIBTORRENT_VERSION=v2.0.3

if [ "${ARCH}" = "x86_64" ]; then
    qbit_arch="x86_64"
elif echo "${ARCH}" | grep -E -q "aarch64_be|aarch64|armv8b|armv8l|arm64"; then
    qbit_arch="aarch64"
fi

if [ -n "$qbit_arch" ]; then
    wget "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_${LIBTORRENT_VERSION}/qbittorrent-nox-${qbit_arch}" -O /usr/bin/qbittorrent-nox
    chmod +x /usr/bin/qbittorrent-nox
else
    apk add --no-cache -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing" qbittorrent-nox
fi
