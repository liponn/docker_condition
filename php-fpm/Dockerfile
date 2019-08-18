######
# See: https://hub.docker.com/_/php/
######

FROM php:7.1-fpm
MAINTAINER lip <13015531717@163.com>

######
# change sources.list
######
   
######
# You can install php extensions using docker-php-ext-install
######

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev \
	git \
	zip \
	unzip \
    && docker-php-ext-install -j$(nproc) iconv mcrypt pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install swoole \
    && docker-php-ext-enable swoole 


## 安装composer php
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
