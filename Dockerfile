FROM alpine:edge
RUN \
apk add --no-cache --update \
bash \
curl \
git \
ca-certificates \
openssl \
wget \
zip \
unzip \
xz \
tar \
nginx-mod-dynamic-healthcheck nginx-mod-http-headers-more nginx-mod-stream nginx-mod-dynamic-upstream iproute2 psmisc socat jq && \
ln -sf /dev/stdout /var/log/nginx/access.log && \
ln -sf /dev/stderr /var/log/nginx/error.log && \
rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /
# COPY 10-listen-on-ipv6-by-default.sh /docker-entrypoint.d
# COPY 15-local-resolvers.envsh /docker-entrypoint.d
# COPY 20-envsubst-on-templates.sh /docker-entrypoint.d
# COPY 30-tune-worker-processes.sh /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]