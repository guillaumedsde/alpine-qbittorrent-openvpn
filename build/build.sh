#!/bin/sh

# login to dockerhub registry
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

TAG="${TRAVIS_TAG:-latest}"
docker buildx build \
    --progress plain \
    --platform=linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le \
    -t ${DOCKER_USERNAME}/alpine-qbittorrent-openvpn:${TAG} \
    --push \
    .

curl --verbose -X POST -u "${DOCKER_USERNAME}:${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Content-Type: application/json" \
    https://api.github.com/repos/${DOCKER_USERNAME}/alpine-qbittorrent-openvpn/dispatches \
    --data '{"event_type": "html.preview"}'
