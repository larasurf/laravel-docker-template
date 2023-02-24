FROM nginx:1.23.3-alpine

ENV UPSTREAM_HOST localhost
ENV UPSTREAM_PORT 9000
ENV CORS_ORIGIN http://localhost

ARG NGINX_CONFIG_TEMPLATE=.docker/nginx/laravel.conf.template

COPY $NGINX_CONFIG_TEMPLATE /etc/nginx/templates/default.conf.template

COPY public /var/www/public

WORKDIR /var/www/public
