FROM nginx:1.18-alpine

ENV UPSTREAM_HOST localhost
ENV UPSTREAM_PORT 9000

COPY laravel.conf.template /etc/nginx/templates/default.conf.template

WORKDIR /var/www
