FROM hrak/nginx-ldap:latest

LABEL maintainer "Feng Zhou <feng.zh@gmail.com>"

RUN apk add --update tar && rm -rf /var/lib/apt/lists/* /var/cache/apk/*

ADD nginx.conf /etc/nginx/

RUN sed -i '1 i#!/bin/sh\n/nginx-watch.sh &' /run.sh

CMD ["/run.sh"]
