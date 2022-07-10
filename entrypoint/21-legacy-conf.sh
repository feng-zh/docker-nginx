#!/bin/sh

set -eu

ME=$( basename "$0" )

[ "${NGINX_CONFIG_MODE:-}" = "legacy" ] || exit 0

touch /etc/nginx/nginx.conf 2>/dev/null || { echo >&2 "$ME: error: can not modify /etc/nginx/nginx.conf (read-only file system?)"; exit 0; }

cat <<"EOF" > /etc/nginx/nginx.conf
user  nobody;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] [$http_host-$server_port] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" $request_time ';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
EOF

if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    echo "$ME: info: use legacy nginx config /etc/nginx/nginx.conf (due to NGINX_CONFIG_MODE=legacy)"
fi

exit 0
