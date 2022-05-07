#!/usr/bin/with-contenv sh
# shellcheck shell=sh
port="$1"

QBT_CONFIG_FILE="${CONFIG_DIR}/qBittorrent/config/qBittorrent.conf"

if pgrep "qbittorrent-nox" >/dev/null 2>$1; then
        # Check if we need to use HTTPS
        echo "Setting port via WebUI"
        if grep -q 'WebUI\\HTTPS\\Enabled=true' "$QBT_CONFIG_FILE"; then
                echo "Using HTTPS"
                address=https://127.0.0.1:8080/api/v2/app/setPreferences
        else
                address=http://127.0.0.1:8080/api/v2/app/setPreferences
        fi
        curl -k --data 'json={"listen_port": '$port'}' $address
else
        echo "Setting port in config file"
        if [ -f "$QBT_CONFIG_FILE" ]; then
                # if session port line exists
                if grep -q 'Session\\Port' "$QBT_CONFIG_FILE"; then
                        # Set connection interface address to the VPN address
                        sed -i -E 's/^.*\b(Session.*Port)\b.*$/Session\\Port='"$port"'/' "$QBT_CONFIG_FILE"
                else
                        # add the line for configuring interface address to the qBittorrent config file
                        printf 'Session\\Port=%s' "$port" >>"$QBT_CONFIG_FILE"
                fi
        else
                # Ensure config directory is created
                mkdir -p "$(dirname "$QBT_CONFIG_FILE")"
                # Create the configuration file from a template and environment variables
                printf '[BitTorrent]\nSession\\Port=%s\n' "$port" >"$QBT_CONFIG_FILE"
        fi
fi

