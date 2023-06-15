FROM php:8-fpm-alpine AS base

ENV PROJECT_ROOT /var/www/html
WORKDIR $PROJECT_ROOT

RUN apk update
RUN apk upgrade

RUN apk add caddy

RUN set -eux; \
        apk add --no-cache \
            libpng \
            zip \
            libzip-dev \
            freetype-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            libwebp-dev \
        ; \
        docker-php-ext-configure \
            gd \
                --with-freetype \
                --with-jpeg \
                --with-webp \
        ; \
        docker-php-ext-install \
            gd \
            mysqli \
            pdo \
            pdo_mysql \
            zip \
        ; \
        docker-php-ext-enable \
            pdo_mysql \
        ;

RUN set -eux; \
        apk add --no-cache --virtual .build-deps \
            autoconf \
            g++ \
            make \
        ; \
        pecl install xdebug && docker-php-ext-enable xdebug; \
        apk del --no-network .build-deps;

RUN set -eux; apk add --update nodejs npm yarn

COPY Caddyfile /etc/caddy/Caddyfile
COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY *.ini $PHP_INI_DIR/conf.d/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


EXPOSE 80

# CMD caddy start --config /etc/caddy/Caddyfile --adapter caddyfile; php-fpm
CMD php-fpm -D; caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
