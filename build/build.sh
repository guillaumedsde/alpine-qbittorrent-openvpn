#!/bin/sh

if [[ "${TRAVIS_CPU_ARCH}" == arm64 ]]; then
    BUILD_ARGS="--build-arg aarch64"
else
    BUILD_ARGS="--build-arg ${TRAVIS_CPU_ARCH}"
fi

docker build -t ${DOCKER_USERNAME}/alpine-qbittorrent-openvpn:latest .
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push ${DOCKER_USERNAME}/alpine-qbittorrent-openvpn
