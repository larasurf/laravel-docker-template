#!/usr/bin/env bash

if [ ! -z "${SURF_USER_ID}" ]; then
    usermod -u ${SURF_USER_ID} www-data
fi

if [ $# -gt 0 ];then
    su-exec www-data "$@"
else
    php-fpm
fi
