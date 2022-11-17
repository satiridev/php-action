# php environment to run the unit test
FROM nginx/unit:1.20.0-php7.3 as nginx-unit-php-base

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app/guruland
USER root

## Install package dependencies required at runtime.
RUN apt-get update \
    && apt-get -y install apt-utils \
    && apt-get -y install \
    php-apcu php-apcu-bc php-gd php-curl php-gettext \
    php-ldap php-msgpack php-soap php-wddx \
    php-zip php-imagick \
    php-bcmath php-mbstring php-mysql php-xml \
    php-redis php-memcached php-memcache php-intl \
    && apt-get clean

RUN apt-get -y install git procps make build-essential && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.23

RUN composer global require hirak/prestissimo --no-plugins --no-scripts --prefer-dist --no-progress --optimize-autoloader

## Build artifacts for sf2-common and sf2-listing-internal
ARG PG_ENV=integration
ENV SHELL=/bin/bash

## Default timezone to be overwritten by environment variable
ENV TZ=Asia/Singapore
ENV DEBIAN_FRONTEND=noninteractive

## @TODO: replace this entrypoint with phpunit test or make test_unit
## @TODO: how to work inside workspace
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]
