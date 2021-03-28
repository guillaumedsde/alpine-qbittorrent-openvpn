#!/bin/sh
set -x
ARCH="$(uname -m)"
echo "building for ${ARCH}"

QBT_VERSION=4.3.4.1
QBT_RELEASE=r1

if [ "${ARCH}" = "x86_64" ]; then
    qbit_arch="amd64"
elif echo "${ARCH}" | grep -E -q "aarch64_be|aarch64|armv8b|armv8l|arm64"; then
    qbit_arch="arm64"
elif echo "${ARCH}" | grep -E -q "s390|s390x"; then
    qbit_arch="s390x"
fi

if [ -n "$qbit_arch" ]; then
    wget "https://github.com/guillaumedsde/qbittorrent-nox-static/releases/download/${QBT_VERSION}-${QBT_RELEASE}/qbittorrent-nox-v${QBT_VERSION}-static-${qbit_arch}" -O /usr/bin/qbittorrent-nox
    chmod +x /usr/bin/qbittorrent-nox
else
    apk add --no-cache -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing" qbittorrent-nox
fi
