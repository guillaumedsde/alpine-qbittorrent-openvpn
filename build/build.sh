#!/bin/sh

if [ "${CI_COMMIT_REF_NAME}" = "master" ]; then
    VERSION="$(git rev-parse --short HEAD)"
    TAGS="-t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${VERSION} -t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:latest"
else
    # cleanup branch name
    BRANCH="$(echo "${CI_COMMIT_REF_NAME}" | tr / _)"
    VERSION="${BRANCH}"
    # tag image with branch name
    TAGS="-t ${CI_REGISTRY_USER}/alpine-qbittorrent-openvpn:${BRANCH}"
fi

# shellcheck disable=SC2086
docker buildx build . \
    --platform="${BUILDX_PLATFORM}" \
    --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
    --build-arg VERSION="${VERSION}" \
    ${TAGS} \
    --push
