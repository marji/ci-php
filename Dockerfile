FROM php:8.1.18-fpm-alpine3.17

ARG RUNNER_UID=1001

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/marji/ci-php"

ENV COMPOSER_VERSION=2.5.7 \
  COMPOSER_HASH_SHA256=9256c4c1c803b9d0cb7a66a1ab6c737e48c43cc6df7b8ec9ec2497a724bf44de

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

RUN adduser -D -h /home/runner -u $RUNNER_UID runner

USER runner
