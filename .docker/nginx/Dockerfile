FROM nginx:1.21.4-alpine

ENV UPSTREAM_HOST localhost
ENV UPSTREAM_PORT 9000

COPY .docker/nginx/laravel.conf.template /etc/nginx/templates/default.conf.template

COPY public /var/www/public

WORKDIR /var/www/public
