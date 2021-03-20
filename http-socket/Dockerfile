FROM alpine

RUN apk add --no-cache \
        socat \
        tini

EXPOSE 80

ENTRYPOINT ["tini", "--", "socat", "TCP-LISTEN:80,reuseaddr,fork,su=nobody", "UNIX-CLIENT:/var/run/nginx.sock"]
