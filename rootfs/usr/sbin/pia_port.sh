#!/usr/bin/with-contenv sh
# shellcheck shell=sh


###### PIA Variables ######
curl_max_time=15
curl_retry=5
curl_retry_delay=15
user=$(sed -n 1p /config/openvpn/openvpn-credentials.txt)
pass=$(sed -n 2p /config/openvpn/openvpn-credentials.txt)
pf_host=$(ip route | grep tun | grep -v src | head -1 | awk '{ print $3 }')
###### Nextgen PIA port forwarding      ##################
   
get_auth_token () {
            tok=$(curl --insecure --silent --show-error --request POST --max-time $curl_max_time \
                 --header "Content-Type: application/json" \
                 --data "{\"username\":\"$user\",\"password\":\"$pass\"}" \
                "https://www.privateinternetaccess.com/api/client/v2/token" | jq -r '.token')
            [ $? -ne 0 ] && echo "Failed to acquire new auth token" && exit 1
            #echo "$tok"
    }

get_auth_token

yes '' | sed 3q

get_sig () {
  pf_getsig=$(curl --insecure --get --silent --show-error \
    --retry $curl_retry --retry-delay $curl_retry_delay --max-time $curl_max_time \
    --data-urlencode "token=$tok" \
    "$verify" \
    "https://$pf_host:19999/getSignature")
  if [ "$(echo $pf_getsig | jq -r .status)" != "OK" ]; then
    echo "$(date): getSignature error"
    echo $pf_getsig
    echo "the has been a fatal_error"
  fi
  pf_payload=$(echo $pf_getsig | jq -r .payload)
  pf_getsignature=$(echo $pf_getsig | jq -r .signature)
  pf_port=$(echo $pf_payload | base64 -d | jq -r .port)
  pf_token_expiry_raw=$(echo $pf_payload | base64 -d | jq -r .expires_at)
  if date --help 2>&1 /dev/null | grep -i 'busybox' > /dev/null; then
    pf_token_expiry=$(date -D %Y-%m-%dT%H:%M:%S --date="$pf_token_expiry_raw" +%s)
  else
    pf_token_expiry=$(date --date="$pf_token_expiry_raw" +%s)
  fi
}

bind_port () {
  pf_bind=$(curl --insecure --get --silent --show-error \
      --retry $curl_retry --retry-delay $curl_retry_delay --max-time $curl_max_time \
      --data-urlencode "payload=$pf_payload" \
      --data-urlencode "signature=$pf_getsignature" \
      "$verify" \
      "https://$pf_host:19999/bindPort")
  if [ "$(echo $pf_bind | jq -r .status)" = "OK" ]; then
    echo "the port has been bound to $pf_port  $(date)"		
  else  
    echo "$(date): bindPort error"
    echo $pf_bind
    echo "the has been a fatal_error"
  fi
}

get_sig

#echo "sig is $pf_getsig"
echo "port is $pf_port"

bind_port
# Get new port, check if empty
new_port="$pf_port"
if [ -z "$new_port" ]; then
    echo "Could not find new port from PIA"
    exit
fi
echo "Got new port $new_port from PIA"

/usr/sbin/set_qbittorrent_port_forwarding.sh "${new_port}"
