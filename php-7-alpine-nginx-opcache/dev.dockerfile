FROM php:7.4-fpm-alpine AS base

ENV PROJECT_ROOT /var/www/html
WORKDIR $PROJECT_ROOT

RUN apk update
RUN apk upgrade

RUN set -eux; apk add nginx

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

RUN set -eux; \
        apk add --no-cache --virtual .build-deps \
            autoconf \
            g++ \
            make
RUN pecl install xdebug-3.1.6; \
    docker-php-ext-enable xdebug; \
    apk del --no-network .build-deps;

COPY default.conf /etc/nginx/http.d/
COPY zz-docker.conf /usr/local/etc/php-fpm.d/
COPY *.ini $PHP_INI_DIR/conf.d/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


EXPOSE 80

# RUN echo "0       22       *       *       *       cd $PROJECT_ROOT; php artisan earning_rule:create" >> /etc/crontabs/root
# RUN echo "0       17       *       *       *       cd $PROJECT_ROOT; php artisan strava_data:update" >> /etc/crontabs/root
# RUN echo "*       *       *       *       *       cd $PROJECT_ROOT; /usr/local/bin/php artisan schedule:run" >> /etc/crontabs/root

# CMD crond; php-fpm -D; nginx -g 'daemon off;'
CMD php-fpm -D; nginx -g 'daemon off;'
