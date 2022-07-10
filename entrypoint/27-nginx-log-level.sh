#!/bin/sh

set -eu

ME=$( basename "$0" )

[ -n "${NGINX_LOG_LEVEL:-}" ] || exit 0

touch /etc/nginx/nginx.conf 2>/dev/null || { echo >&2 "$ME: error: can not modify /etc/nginx/nginx.conf (read-only file system?)"; exit 0; }

sed -i -r 's/^(error_log)(\s[^\s]*\s)(debug|info|notice|warn|error|crit|alert|emerg);/\1\2'"$NGINX_LOG_LEVEL"';/' /etc/nginx/nginx.conf

exit 0
