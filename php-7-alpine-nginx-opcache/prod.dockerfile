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

COPY default.conf /etc/nginx/http.d/
COPY zz-docker.conf /usr/local/etc/php-fpm.d/
COPY docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# build
FROM base AS builder

COPY ./ $PROJECT_ROOT
RUN chmod -R 777 $PROJECT_ROOT/public/

RUN composer install

FROM base AS release

COPY --from=builder --chown=root:www-data --chmod=775 $PROJECT_ROOT $PROJECT_ROOT

EXPOSE 80

# RUN echo "0       22       *       *       *       cd $PROJECT_ROOT; php artisan earning_rule:create" >> /etc/crontabs/root
# RUN echo "0       17       *       *       *       cd $PROJECT_ROOT; php artisan strava_data:update" >> /etc/crontabs/root
# RUN echo "*       *       *       *       *       cd $PROJECT_ROOT; /usr/local/bin/php artisan schedule:run" >> /etc/crontabs/root

# CMD crond; php-fpm -D; nginx -g 'daemon off;'
CMD php-fpm -D; nginx -g 'daemon off;'
