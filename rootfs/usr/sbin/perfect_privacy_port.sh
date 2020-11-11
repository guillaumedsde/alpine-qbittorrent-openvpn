#!/usr/bin/with-contenv sh
# shellcheck shell=sh

# Calculate the port

IPADDRESS=$1
echo "ipAddress to calculate port from $IPADDRESS"
oct3=$(echo "${IPADDRESS}" | tr "." " " | awk '{ print $3 }')
oct4=$(echo "${IPADDRESS}" | tr "." " " | awk '{ print $4 }')
oct3binary=$(bc <<<"obase=2;$oct3" | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')
oct4binary=$(bc <<<"obase=2;$oct4" | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')

sum=${oct3binary}${oct4binary}
portPartBinary=${sum:4}
portPartDecimal=$((2#$portPartBinary))
if [ ${#portPartDecimal} -ge 4 ]; then
    new_port="1"${portPartDecimal}
else
    new_port="10"${portPartDecimal}
fi
echo "calculated port $new_port"

/usr/sbin/set_qbittorrent_port_forwarding.sh "${new_port}"
