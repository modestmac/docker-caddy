FROM alpine:3.7
LABEL maintainer "Stacy Suarez <s.suarez@me.com>"
LABEL caddy_version="1.0.0" architecture="amd64"

ARG plugins=docker,dyndns,http.cache,http.cgi,http.cors,http.forwardproxy,http.git,http.gopkg,http.grpc,http.ipfilter,http.login,http.nobots,http.realip,http.reauth,http.restic,http.s3browser,http.webdav,net

ARG dns=tls.dns.azure,tls.dns.cloudflare,tls.dns.duckdns,tls.dns.dyn,tls.dns.godaddy,tls.dns.googlecloud,tls.dns.rfc2136

RUN apk add --no-cache openssh-client git tar curl ca-certificates bash && update-ca-certificates

RUN curl --silent https://getcaddy.com | /bin/bash -s personal $plugins,$dns

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
