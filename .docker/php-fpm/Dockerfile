FROM php:8.1-fpm-alpine

ENV COMPOSER_VERSION 2.5.4
ENV COMPOSER_ALLOW_SUPERUSER 1

ARG WEB_ROOT=/var/www

COPY ./ $WEB_ROOT
WORKDIR $WEB_ROOT

RUN until curl getcomposer.org --output /dev/null --silent; do echo 'Failed to curl getcomposer.org...' && sleep 1; done && \
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
            until curl composer.github.io --output /dev/null --silent; do echo 'Failed to curl composer.github.io...' && sleep 1; done && \
            php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
            php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && \
            php -r "unlink('composer-setup.php');" && \
            composer --ansi --version --no-interaction && \
    apk add --no-cache shadow su-exec git openssh bash make zip unzip nodejs npm yarn && \
    apk upgrade curl && \
    cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini && \
    curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
          bcmath ctype curl fileinfo gd imap intl json ldap mbstring openssl pdo_mysql igbinary msgpack redis tokenizer xml zip zlib

RUN echo 'variables_order = "EGPCS"' >> /usr/local/etc/php/conf.d/variables-order.ini

RUN --mount=type=ssh if [[ -f 'composer.json' ]] ; then \
      composer install --no-dev --no-progress && composer clear-cache ; \
    else \
      echo 'composer.json not found' ; \
    fi

RUN if [[  -f 'package.json' ]] ; then \
      apk add --no-cache nodejs npm yarn && yarn --frozen-lockfile && yarn run prod && rm -rf node_modules ; \
    else \
      echo 'package.json not found' ; \
    fi && \
    rm -rf .env

RUN if [[ -d 'storage' ]] && [[ -d 'bootstrap/cache' ]]; then \
     chown -R www-data storage bootstrap/cache ; \
   else \
     echo 'laravel application not found' ; \
   fi

COPY .docker/php-fpm/surf-entrypoint.sh /usr/local/bin/surf-entrypoint.sh
RUN chmod +x /usr/local/bin/surf-entrypoint.sh

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENTRYPOINT [ "surf-entrypoint.sh" ]
