FROM php:8.0-fpm-alpine

ENV COMPOSER_VERSION 2.2.7
ENV COMPOSER_ALLOW_SUPERUSER 1

# ping workaround for docker DNS issues
RUN until curl getcomposer.org --output /dev/null --silent; do echo 'Failed to curl getcomposer.org...' && sleep 1; done && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    until curl composer.github.io --output /dev/null --silent; do echo 'Failed to curl composer.github.io...' && sleep 1; done && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && \
    php -r "unlink('composer-setup.php');" && \
    composer --ansi --version --no-interaction && \
    apk add --no-cache \
        shadow \
        su-exec \
        git \
        openssh \
        bash \
        make \
        zip \
        unzip \
        nodejs \
        npm \
        yarn \
        php8-bcmath \
        php8-ctype \
        php8-curl \
        php8-fileinfo \
        php8-gd \
        php8-imap \
        php8-intl \
        php8-json \
        php8-ldap \
        php8-mbstring \
        php8-openssl \
        php8-pdo_mysql \
        php8-pecl-igbinary \
        php8-pecl-msgpack \
        php8-redis \
        php8-tokenizer \
        php8-xml \
        php8-zip \
        php8-zlib \
        libcurl \
        freetype \
        libjpeg-turbo \
        libpng && \
    apk upgrade curl && \
    apk add --no-cache --virtual .build-deps \
      autoconf g++ \
      make \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      icu-dev \
      zlib-dev \
      libzip-dev \
      libxml2-dev \
      curl-dev && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-enable gd && \
    until curl pecl.php.net --output /dev/null --silent; do echo 'Failed to curl pecl.php.net...' && sleep 1; done && \
    pecl channel-update pecl.php.net && \
    pecl install redis && \
    docker-php-ext-install pdo pdo_mysql intl && \
    docker-php-ext-enable pdo_mysql redis intl && \
    docker-php-ext-install curl && \
    docker-php-ext-install zip && \
    docker-php-ext-install xml && \
    apk del .build-deps && \
    cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

RUN echo 'variables_order = "EGPCS"' >> /usr/local/etc/php/conf.d/variables-order.ini

ARG WEB_ROOT=/var/www

COPY ./ $WEB_ROOT
COPY .docker/php-fpm/surf-entrypoint.sh /usr/local/bin/surf-entrypoint.sh
RUN chmod +x /usr/local/bin/surf-entrypoint.sh

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

WORKDIR $WEB_ROOT

RUN --mount=type=ssh if [[ -f 'composer.json' ]] ; then \
      composer install --no-dev --no-progress && composer clear-cache ; \
    else \
      echo 'composer.json not found' ; \
    fi

RUN if [[  -f 'package.json' ]] ; then \
     yarn && yarn run prod && rm -rf node_modules ; \
   else \
     echo 'package.json not found' ; \
   fi

RUN if [[ -d 'storage' ]] && [[ -d 'bootstrap/cache' ]]; then \
     chown -R www-data storage bootstrap/cache ; \
   else \
     echo 'laravel application not found' ; \
   fi

ENTRYPOINT [ "surf-entrypoint.sh" ]
