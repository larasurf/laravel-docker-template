FROM php:8.0-fpm-alpine

ENV COMPOSER_VERSION 2.0.13
ENV COMPOSER_ALLOW_SUPERUSER 1

# ping workaround for docker DNS issues
RUN until ping -c1 getcomposer.org > /dev/null 2>&1; do :; done && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    until ping -c1 composer.github.io > /dev/null 2>&1; do :; done && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && \
    php -r "unlink('composer-setup.php');" && \
    composer --ansi --version --no-interaction && \
    apk add --no-cache \
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
        php8-iconv \
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
        icu-dev \
        libcurl \
        curl-dev \
        freetype \
        libjpeg-turbo \
        libpng \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    apk upgrade curl && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-enable gd && \
    apk del --no-cache freetype-dev libjpeg-turbo-dev libpng-dev && \
    apk add --no-cache --virtual .build-deps autoconf g++ make zlib-dev && \
    until ping -c1 pecl.php.net > /dev/null 2>&1; do :; done && \
    pecl channel-update pecl.php.net && \
    pecl install redis && \
    docker-php-ext-install pdo pdo_mysql iconv intl && \
    docker-php-ext-enable pdo_mysql redis iconv intl && \
    apk del .build-deps && \
    cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

ARG WEB_ROOT=/var/www

COPY ./ $WEB_ROOT

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

WORKDIR $WEB_ROOT

RUN --mount=type=ssh if [[ -f 'composer.json' ]] ; then \
      composer install --no-dev --no-progress && composer clear-cache ; \
    else \
      echo 'composer.json not found' ; \
    fi

RUN if [[  -f 'package.json' ]] ; then \
     yarn && yarn run prod ; \
   else \
     echo 'package.json not found' ; \
   fi

RUN if [[ -d 'storage' ]] && [[ -d 'bootstrap/cache' ]]; then \
     chown -R www-data storage bootstrap/cache ; \
   else \
     echo 'laravel application not found' ; \
   fi
