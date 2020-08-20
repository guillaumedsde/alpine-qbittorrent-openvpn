#!/bin/sh
ARCH="$(uname -m)"
echo "building for ${ARCH}"

QBT_VERSION=4.2.5
QBT_RELEASE=r0

if [ "${ARCH}" = "x86_64" ]; then
    S6_ARCH=amd64
    qbit_arch="${S6_ARCH}"
elif [ "${ARCH}" = "i386" ]; then
    S6_ARCH=X86
elif echo "${ARCH}" | grep -E -q "armv6|armv7"; then
    S6_ARCH=arm
    qbit_arch="${S6_ARCH}"
elif echo "${ARCH}" | grep -E -q "aarch64_be|aarch64|armv8b|armv8l|arm64"; then
    S6_ARCH=aarch64
    qbit_arch=arm64
else
    S6_ARCH="${ARCH}"
fi

echo "using architecture ${S6_ARCH} for S6 Overlay"
wget "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz"
tar xzf "s6-overlay-${S6_ARCH}.tar.gz" -C /
rm "s6-overlay-${S6_ARCH}.tar.gz"

if [ -n "$qbit_arch" ]; then
    wget "https://github.com/guillaumedsde/qbittorrent-nox-static/releases/download/${QBT_VERSION}-${QBT_RELEASE}/qbittorrent-nox-v${QBT_VERSION}-static-${qbit_arch}" -O /usr/bin/qbittorrent-nox
    chmod +x /usr/bin/qbittorrent-nox
else
    apk add --no-cache -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing" qbittorrent-nox
fi
