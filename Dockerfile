FROM alpine:latest

ARG S6_VERSION=v2.0.0.1

RUN addgroup -S openvpn \
    && adduser -SD \
    -s /sbin/nologin \
    -h /var/lib/openvpn \
    -g openvpn \
    -G openvpn \
    openvpn \
    && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing qbittorrent-nox \
    && apk add --no-cache \
    openvpn \
    iptables \
    libcap \
    sudo \
    && setcap cap_net_admin+ep $(which openvpn) \
    && apk del libcap --purge \
    && echo "openvpn ALL=(ALL)  NOPASSWD: /sbin/ip" >> /etc/sudoers \
    && ARCH=$(uname -m) \
    && echo building for ${ARCH} \
    && if [ "${ARCH}" == x86_64 ]; then S6_ARCH=amd64; elif [ "${ARCH}" == i386 ]; then S6_ARCH=X86; elif echo "$ARCH" | grep -E -q "armv6|armv7"; then S6_ARCH=arm; else S6_ARCH=${ARCH}; fi \
    && echo using architecture ${S6_ARCH} for S6 Overlay \
    && wget https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz \
    && tar xzf s6-overlay-${S6_ARCH}.tar.gz -C / \ 
    && rm s6-overlay-${S6_ARCH}.tar.gz

COPY rootfs /

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