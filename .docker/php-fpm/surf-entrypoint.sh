#!/usr/bin/env bash

if [ ! -z "${SURF_USER_ID}" ] && [ ! -z "${SURF_GROUP_ID}" ]; then
    usermod -u ${SURF_USER_ID} www-data
    groupmod -g ${SURF_GROUP_ID} www-data
fi

if [ -d "/home/www-data/.composer" ]; then
  chmod -R ugo+rw /home/www-data/.composer
fi

if [ $# -gt 0 ];then
    su-exec www-data "$@"
else
    php-fpm
fi
