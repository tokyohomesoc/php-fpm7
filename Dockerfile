FROM php:7.0.10-fpm-alpine

MAINTAINER Foxboxsnet

# Environment variable
ARG MYSQL_VERSION=10.1.14-r3
ARG APCU_VERSION=5.1.5
ARG APCU_BC_VERSION=1.0.3
ARG PHP-FPM_CONF_FILE=/usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 -S nginx \
	&& adduser -u 1000 -D -S -G nginx nginx \
	&& apk update \
	&& apk add --no-cache --virtual .build-php \
		$PHPIZE_DEPS \
		mysql=$MYSQL_VERSION \
		sed \
	&& docker-php-ext-install \
		mysqli \
		mbstring \
		opcache \
	&& pecl install apcu-$APCU_VERSION \
	&& docker-php-ext-enable apcu \
	&& pecl install apcu_bc-$APCU_BC_VERSION \
	&& docker-php-ext-enable apc \
	&& sed -e "s/user = www-data/user = nginx/g" $PHP-FPM_CONF_FILE \
	&& sed -e "s/group = www-data/group = nginx/g" $PHP-FPM_CONF_FILE \
	&& apk del .build-php

COPY files/*.ini /usr/local/etc/php/conf.d/
RUN mkdir -p /etc/php.d/ \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY files/opcache*.blacklist /etc/php.d/