#!/bin/sh

if [ "${CI_COMMIT_REF_NAME}" = "master" ]; then
    VERSION="$(git rev-parse --short HEAD)"
    # build python version
    docker buildx build . \
        --platform="${BUILDX_PLATFORM}" \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --build-arg VERSION="python" \
        --build-arg BASE_IMAGE="python:3-alpine3.12" \
        -t "${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:python" \
        --push
    TAGS=" -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${VERSION} -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:latest "
else
    # cleanup branch name
    BRANCH="$(echo "${CI_COMMIT_REF_NAME}" | tr / _)"
    VERSION="${BRANCH}"
    # tag image with branch name
    TAGS="-t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${BRANCH}"
fi

docker buildx build . \
    --platform="${BUILDX_PLATFORM}" \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    --build-arg VERSION="${VERSION}" \
    ${TAGS} \
    --push
