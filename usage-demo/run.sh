#!/bin/bash


for num in {1..3}; do
    name="w${num}"
    port=$((6680+num-1))
    docker rm -f "${name}" &>/dev/null || true ;
    docker run -d --name "${name}" --restart always -p "${port}":80 containous/whoami:latest;
done

cat > stream.conf <<EOF
stream {
    upstream backends_stream {
        zone zone_for_backends_stream 1m;
        server host.docker.internal:6680 down max_fails=1 fail_timeout=2s;
        server host.docker.internal:6681 down max_fails=1 fail_timeout=2s;
        server host.docker.internal:6682 down max_fails=1 fail_timeout=2s;
        check fall=1 rise=1 timeout=3 interval=1;
    }

    server {
        listen 6001;
        proxy_pass backends_stream;
    }
}
EOF


docker rm -f local-nginx
docker run \
-p 9970:80 \
-p 9971:6001 \
-d \
--name local-nginx \
--add-host=host.docker.internal:host-gateway \
-v ./stream.conf:/etc/nginx/conf.d/stream.conf \
dyrnq/nginx-proxy


docker rm -f local-haproxy
docker run \
-d \
--name local-haproxy \
--add-host=host.docker.internal:host-gateway \
-p 9972:6001 \
--env "PORT=6001" \
--env "BACKEND_SERVER=host.docker.internal:6680 check,host.docker.internal:6681 check,host.docker.internal:6682" \
dyrnq/local-haproxy:latest