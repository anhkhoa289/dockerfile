FROM php:7.4.33-fpm-alpine AS base

ENV PROJECT_ROOT /var/www/html
WORKDIR $PROJECT_ROOT

RUN apk update
RUN apk upgrade

RUN set -eux; \
        apk add --update --no-cache \
            build-base \
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
            sockets \
        ; \
        docker-php-ext-enable \
            pdo_mysql \
        ;

COPY zz-docker.conf /usr/local/etc/php-fpm.d/
COPY docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/

RUN set -eux; apk add nginx
COPY default.conf /etc/nginx/http.d/

EXPOSE 80

CMD php-fpm -D; nginx -g 'daemon off;'
