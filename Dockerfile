FROM alpine:3.5
LABEL maintainer "someone else"
LABEL caddy_version="0.1" architecture="amd64"

RUN apk add --no-cache openssh-client git tar curl ca-certificates && update-ca-certificates

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=http.awslambda,http.cgi,http.cors,http.expires,http.filemanager,http.filter,http.git,http.hugo,http.ipfilter,http.jwt,http.mailout,http.minify,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.upload,net,tls.dns.cloudflare,tls.dns.dnspod,tls.dns.dyn,tls.dns.googlecloud,tls.dns.namecheap" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

RUN mkdir -p /opt/assets

EXPOSE 80 443 2015

VOLUME /var/www
VOLUME /caddy
WORKDIR /var/www
WORKDIR /caddy

ENV CADDYPATH=/caddy/.caddy
ENV RUN_ARGS=

COPY Caddyfile /caddy/
COPY index.html /var/www/
COPY Caddyfile /opt/assets/
COPY index.html /opt/assets/
COPY start.sh /

ENTRYPOINT ["/start.sh"]
