#!/bin/sh
set -u
adduser -D -u $PUID deluge
chown deluge:deluge /download/ /config/
exec tini -- runsvdir /etc/service/
