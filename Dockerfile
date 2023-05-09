FROM php:8-alpine

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/marji/ci-php"

ENV COMPOSER_VERSION=2.5.5 \
  COMPOSER_HASH_SHA256=566a6d1cf4be1cc3ac882d2a2a13817ffae54e60f5aa7c9137434810a5809ffc

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
