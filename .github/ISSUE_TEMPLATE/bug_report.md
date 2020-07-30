## Information

_describe the issue_

## Current setup

_information about your current setup_

| docker image tag (ex: `python`, `latest`, `32242d1` ...) |     |
| -------------------------------------------------------- | --- |
| docker image hash (ex: `603b78e07727`)                   |     |

## `docker-compose.yml` file or `docker run` command

_how did you start the container?_ (don't forget to use backticks for creating a proper code block)

```yaml
version: "3.3"
services:
  alpine-qbittorrent-openvpn:
    volumes:
      - "/your/storage/path/:/downloads"
      - "/path/to/config/directory:/config"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - OPENVPN_PROVIDER=PIA
      - OPENVPN_CONFIG=CA\
      - OPENVPN_USERNAME=user
      - OPENVPN_PASSWORD=pass
      - PUID=1000
      - PGID=1000
      - LAN=192.168.0.0/16
    ports:
      - "8080:8080"
    cap_add:
      - NET_ADMIN
    image: guillaumedsde/alpine-qbittorrent-openvpn:latest
```

## Attempted Fix(es)

_What you have tried in order to fix the issue_ (if anything)
