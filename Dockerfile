FROM alpine:3.5
LABEL maintainer "Carl Mercier <foss@carlmercier.com>"
LABEL caddy_version="0.9.5" architecture="amd64"

ARG plugins=awslambda,cors,expires,filemanager,filter,git,hugo,ipfilter,jsonp,jwt,locale,mailout,minify,multipass,prometheus,ratelimit,realip,search,upload
ARG dns=cloudflare,digitalocean,dnsimple,dyn,gandi,googlecloud,linode,namecheap,ovh,rfc2136,route53,vultr

RUN apk add --no-cache openssh-client git tar curl ca-certificates && update-ca-certificates

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${plugins},${dns}" \
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
