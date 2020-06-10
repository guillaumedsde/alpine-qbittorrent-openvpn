#!/bin/sh

AVAILABLE_RAM="$(free -m | awk '/^Mem/ {print $7}')"
RAM_FOR_BUILD=$((${AVAILABLE_RAM} - ${AVAILABLE_RAM} / 15))

docker buildx build \
    --platform=${BUILDX_PLATFORM} \
    --memory=${RAM_FOR_BUILD}M
-t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${CI_COMMIT_REF_SLUG} \
    -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:latest \
    --push \
    .
