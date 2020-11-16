#!/usr/bin/with-contenv sh
# shellcheck shell=sh
#
# Fetch forwarded port from PrivateVPN API
#

# Get the port
tun_ip=$(ip address show dev tun0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1)
pvpn_get_port_url="https://xu515.pvdatanet.com/v3/mac/port?ip%5B%5D=$tun_ip"
pvpn_response=$(curl -s -f "$pvpn_get_port_url")
pvpn_curl_exit_code=$?

if [ -z "$pvpn_response" ]; then
    echo "PrivateVPN port forward API returned a bad response"
fi

# Check for curl error (curl will fail on HTTP errors with -f flag)
if [ ${pvpn_curl_exit_code} -ne 0 ]; then
    echo "curl encountered an error looking up forwarded port: $pvpn_curl_exit_code"
    exit
fi

# Check for errors in curl response
error=$(echo "$pvpn_response" | grep -o "\"Not supported\"")
if [ -n "$error" ]; then
    echo "PrivateVPN API returned an error: $error - not all PrivateVPN servers support port forwarding. Try 'SE Stockholm'."
    exit
fi

# Get new port, check if empty
new_port=$(echo "$pvpn_response" | grep -oe 'Port [0-9]*' | awk '{print $2}' | cut -d/ -f1)
if [ -z "$new_port" ]; then
    echo "Could not find new port from PrivateVPN API"
    exit
fi
echo "Got new port $new_port from PrivateVPN API"

/usr/sbin/set_qbittorrent_port_forwarding.sh "${new_port}"
