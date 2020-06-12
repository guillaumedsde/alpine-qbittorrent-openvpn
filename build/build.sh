#!/bin/sh
docker buildx build \
    --platform=${BUILDX_PLATFORM} \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    --build-arg VERSION=$(git describe --abbrev=0)
-t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:latest --push .
