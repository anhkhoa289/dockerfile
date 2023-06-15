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

COPY Caddyfile /etc/caddy/Caddyfile
COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/
COPY custom.ini $PHP_INI_DIR/conf.d/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

### Build
FROM base AS builder
ENV NODE_OPTIONS --max_old_space_size=4096

RUN set -eux; apk add --update nodejs npm yarn

COPY composer.json composer.lock $PROJECT_ROOT/
RUN composer install --no-scripts

COPY package.json yarn.lock .yarnrc $PROJECT_ROOT/
RUN yarn

COPY ./ $PROJECT_ROOT
RUN composer run post-autoload-dump
RUN yarn prod
RUN rm -rf node_modules




FROM base AS release

COPY --from=builder $PROJECT_ROOT $PROJECT_ROOT
RUN chown -R www-data:www-data $PROJECT_ROOT

EXPOSE 80

# CMD caddy start --config /etc/caddy/Caddyfile --adapter caddyfile; php-fpm
CMD php-fpm -D; caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
