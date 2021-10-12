#!/usr/bin/env bash

if [ ! -z "${SURF_USER_ID}" ]; then
    usermod -u ${SURF_USER_ID} www-data
fi

chmod -R ugo+rw /home/www-data/.composer

if [ $# -gt 0 ];then
    su-exec www-data "$@"
else
    php-fpm
fi
