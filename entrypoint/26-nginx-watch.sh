#!/bin/sh

[ -n "${NGINX_WATCH_INTERVAL:-}" ] || exit 0

# NGINX WATCH DAEMON
#
# Author: Devonte
#
# https://stackoverflow.com/a/35421503
#
# Place file in root of nginx folder: /etc/nginx
# This will test your nginx config on any change and
# if there are no problems it will reload your configuration

# Set NGINX directory
# tar command already has the leading /
dir='etc/nginx'

# Get initial checksum values
# Use fixed time to workaround glusterfs time change issue
# Use fixed sorting to workaround changes in glusterfs
checksum_initial=$(tar --mtime='1970-01-01' --strip-components=2 --sort=name --warning=none -C / -cf - $dir | md5sum | awk '{print $1}')
checksum_now=$checksum_initial

# Daemon that checks the md5 sum of the directory
# ff the sums are different ( a file changed / added / deleted)
# the nginx configuration is tested and reloaded on success
nginx_watching() {
    while true
    do
        checksum_now=$(tar --mtime='1970-01-01' --strip-components=2 --sort=name --warning=none -C / -cf - $dir | md5sum | awk '{print $1}')

        if [ $checksum_initial != $checksum_now ]; then
            echo '[ NGINX ] A configuration file changed. Reloading...' 1>&2
            nginx -t && nginx -s reload;
        fi

        checksum_initial=$checksum_now

        sleep $NGINX_WATCH_INTERVAL
    done
}

nginx_watching &

exit 0
