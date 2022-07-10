#!/bin/sh

set -eu

ME=$( basename "$0" )

[ "$NGINX_LOAD_MODULES" != "" ] || exit 0

LOAD_MODULES_LINES=""

for module in $NGINX_LOAD_MODULES; do
  if [ -x /etc/nginx/modules/${module}.so ]; then
    line="load_module modules/${module}.so;"
    grep -q "$line" /etc/nginx/nginx.conf || LOAD_MODULES_LINES="$LOAD_MODULES_LINES $line"
  else
    echo >&2 "$ME: warn: ignore non-existing $module"
  fi
done

if [ "$LOAD_MODULES_LINES" != "" ]; then
  touch /etc/nginx/nginx.conf 2>/dev/null || { echo >&2 "$ME: error: can not modify /etc/nginx/nginx.conf (read-only file system?)"; exit 0; }
  _TMP_FILE=$(mktemp)
  cat /etc/nginx/nginx.conf > ${_TMP_FILE}
  ( echo $LOAD_MODULES_LINES | xargs -n 2 echo; cat ${_TMP_FILE} ) > /etc/nginx/nginx.conf
  rm ${_TMP_FILE}
fi

