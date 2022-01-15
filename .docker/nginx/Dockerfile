FROM nginx:1.21.4-alpine

ENV UPSTREAM_HOST localhost
ENV UPSTREAM_PORT 9000

ARG NGINX_CONFIG_TEMPLATE=.docker/nginx/laravel.conf.template

COPY $NGINX_CONFIG_TEMPLATE /etc/nginx/templates/default.conf.template

COPY public /var/www/public

WORKDIR /var/www/public
