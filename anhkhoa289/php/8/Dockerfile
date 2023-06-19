FROM php:8-fpm-alpine AS base

ENV PROJECT_ROOT /var/www/html
WORKDIR $PROJECT_ROOT

RUN apk update
RUN apk upgrade

RUN apk add nginx

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

COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/
COPY custom.ini $PHP_INI_DIR/conf.d/

COPY default.conf /etc/nginx/http.d/default.conf


EXPOSE 80

CMD php-fpm -D; nginx -g 'daemon off;'
