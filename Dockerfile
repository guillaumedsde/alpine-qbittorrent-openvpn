
ARG BASE_IMAGE="alpine:3.12"
# uncomment below to enable qbittorrent search engine
# ARG BASE_IMAGE="python:3-alpine3.12"

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
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    s6-overlay \
    && setcap cap_net_admin+ep "$(which openvpn)" \
    && apk del libcap --purge \
    && echo "openvpn ALL=(ALL)  NOPASSWD: /sbin/ip" >> /etc/sudoers #\
#    && /bin/sh /usr/sbin/install_qbittorrent.sh

# installing deluge per https://git.sbruder.de/docker/deluge/src/commit/b998b9bc3f79b5ca1276aa29cc491d5003f4479c
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache \
        deluge \
        git \
        nginx \
        py3-pip \
        runit \
        su-exec \
        tini
RUN git clone --depth=1 https://github.com/tobbez/deluge_exporter /opt/deluge_exporter \
    && cd /opt/deluge_exporter \
    && pip3 install --no-cache-dir -r requirements.txt

COPY services /etc/service
COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /usr/local/bin/

ENV PER_TORRENT_METRICS 1
ENTRYPOINT ["entrypoint.sh"]

#* need to figuree out what all are needed from below
ENV CONFIG_DIR=/config \
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

HEALTHCHECK --interval=10s CMD chmod +x $(which healthcheck.sh) && healthcheck.sh

EXPOSE 8080

ENTRYPOINT ["/init"]
