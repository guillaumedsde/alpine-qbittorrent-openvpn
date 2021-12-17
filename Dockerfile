ARG BASE_IMAGE="alpine:3.14"
# uncomment below to enable qbittorrent search engine
# ARG BASE_IMAGE="python:3-alpine3.14"

# hadolint ignore=DL3006
FROM ${BASE_IMAGE}

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="alpine-qbittorrent-openvpn" \
    org.label-schema.description="qBittorrent docker container with OpenVPN client running as unprivileged user on alpine linux" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/alpine-qbittorrent-openvpn/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/alpine-qbittorrent-openvpn" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

COPY rootfs /

# hadolint ignore=DL3018
RUN addgroup -S openvpn \
    && adduser -SD \
    -s /sbin/nologin \
    -g openvpn \
    -G openvpn \
    openvpn \
    && apk add --no-cache \
    bash \
    openvpn \
    curl \
    iptables \
    libcap \
    sudo \
    subversion \
    jq \
    && apk add --no-cache s6-overlay \
    && setcap cap_net_admin+ep "$(which openvpn)" \
    && apk del libcap --purge \
    && echo "openvpn ALL=(ALL)  NOPASSWD: /sbin/ip" >> /etc/sudoers \
    && /bin/sh /usr/sbin/install_qbittorrent.sh \
    && chmod +x /usr/sbin/healthcheck.sh

ENV CONFIG_DIR=/config \
    SCRIPTS_DIR=/config/scripts \
    QBT_SAVE_PATH=/downloads \
    QBT_WEBUI_PORT=8080 \
    TUN=/dev/net/tun \
    LAN=192.168.0.0/24 \
    DOCKER_CIDR=172.17.0.0/16 \
    DNS=1.1.1.1 \
    PUID=1000 \
    PGID=1000 \
    OPENVPN_CONFIG_FILE=/config/openvpn/config.ovpn \
    CREDENTIALS_FILE=/config/openvpn/openvpn-credentials.txt \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

HEALTHCHECK --interval=1s --start-period=10s CMD healthcheck.sh

EXPOSE 8080

ENTRYPOINT ["/init"]
