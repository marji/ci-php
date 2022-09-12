FROM php:8.0.23-fpm-alpine3.15

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/marji/ci-php"

ENV COMPOSER_VERSION=2.4.0 \
  COMPOSER_HASH_SHA256=1cdc74f74965908d0e98d00feeca37c23b86da51170a3a11a1538d89ff44d4dd

RUN apk add --no-cache --update git \
        bash \
        openssh-client \
        mysql-client \
        patch \
        rsync \
        libpng libpng-dev \
    && docker-php-ext-install gd pdo pdo_mysql \
    && apk del libpng-dev \
    && rm -rf /var/cache/apk/* \
    && curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && echo "$COMPOSER_HASH_SHA256  /usr/local/bin/composer" | sha256sum -c \
    && chmod +x /usr/local/bin/composer

# Remove warning about running as root in composer
ENV COMPOSER_ALLOW_SUPERUSER=1
