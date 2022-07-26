FROM php:8.0-fpm-alpine3.16

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php-8"

ENV COMPOSER_VERSION=2.3.9 \
  COMPOSER_HASH_SHA256=0ec0cd63115cad28307e4b796350712e3cb77db992399aeb4a18a9c0680d7de2

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
