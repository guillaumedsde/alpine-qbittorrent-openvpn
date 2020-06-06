FROM alpine:latest

ARG S6_VERSION=v1.21.8.0
ARG ARCH=amd64

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing qbittorrent-nox \
    && apk add --no-cache \
    openvpn \
    iptables \
    && wget https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${ARCH}.tar.gz \
    && tar xzf s6-overlay-${ARCH}.tar.gz -C / \ 
    && rm s6-overlay-${ARCH}.tar.gz

COPY /etc /etc

ENV QBT_PROFILE=/config \
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


ENTRYPOINT ["/init"]