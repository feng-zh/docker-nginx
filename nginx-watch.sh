#!/bin/bash

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
checksum_initial=$(tar --strip-components=2 --warning=none -C / -cf - $dir | md5sum | awk '{print $1}')
checksum_now=$checksum_initial

# Daemon that checks the md5 sum of the directory
# ff the sums are different ( a file changed / added / deleted)
# the nginx configuration is tested and reloaded on success
while true
do
    checksum_now=$(tar --strip-components=2 --warning=none -C / -cf - $dir | md5sum | awk '{print $1}')

    if [ $checksum_initial != $checksum_now ]; then
        echo '[ NGINX ] A configuration file changed. Reloading...' 1>&2
        nginx -t && nginx -s reload;
    fi

    checksum_initial=$checksum_now

    sleep 10
done




