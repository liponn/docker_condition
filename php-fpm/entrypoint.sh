#!/bin/bash

/usr/sbin/rinetd -f -c /etc/rinetd.conf &

docker-php-entrypoint php-fpm
