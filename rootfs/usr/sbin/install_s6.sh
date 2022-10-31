#!/bin/sh
set -x
ARCH="$(uname -m)"
S6_VERSION="v2.2.0.3"


if [ "${ARCH}" = "x86_64" ]; then
    S6_ARCH=amd64
elif [ "${ARCH}" = "i386" ]; then
    S6_ARCH=X86
elif echo "${ARCH}" | grep -E -q "armv6|armv7"; then
    S6_ARCH=arm
elif echo "${ARCH}" | grep -E -q "aarch64_be|aarch64|armv8b|armv8l|arm64"; then
    S6_ARCH=aarch64
else
    S6_ARCH="${ARCH}"
fi

echo "Platform: ${ARCH}"
echo "S6_ARCH: ${S6_ARCH}"
echo "S6_VERSION: ${S6_VERSION}"

echo "using architecture ${S6_ARCH} for S6 Overlay"
wget "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz"
tar xzf "s6-overlay-${S6_ARCH}.tar.gz" -C /
rm "s6-overlay-${S6_ARCH}.tar.gz"