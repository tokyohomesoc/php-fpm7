FROM php:7.0.10-fpm-alpine

MAINTAINER Foxboxsnet

# Environment variable
ENV MYSQL_VERSION 10.1.14-r3
ENV APCU_VERSION 5.1.5
ENV APCU_BC_VERSION 1.0.3


RUN apk update \
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
	&& apk del .build-php


COPY files/*.ini /usr/local/etc/php/conf.d/
RUN mkdir -p /etc/php.d/ \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY files/opcache*.blacklist /etc/php.d/