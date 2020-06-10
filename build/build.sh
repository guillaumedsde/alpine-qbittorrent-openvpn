#!/bin/sh

docker buildx build \
    --platform=${CI_JOB_NAME} \
    --compress \
    -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${CI_COMMIT_REF_SLUG} \
    -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:latest \
    --push \
    .
