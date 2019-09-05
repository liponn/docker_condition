######
# See: https://hub.docker.com/_/php/
######

FROM php:7.1-fpm
MAINTAINER lip <13015531717@163.com>

######
# change sources.list
######
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
echo \
deb https://mirrors.aliyun.com/debian buster main \
deb https://mirrors.aliyun.com/debian-security buster/updates main \
deb https://mirrors.aliyun.com/debian buster-updates main > /etc/apt/sources.list && \
######
######
# You can install php extensions using docker-php-ext-install
######
apt-get update && apt-get install -y \
telnet \
apt-utils \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
git \
vim \
zip \
unzip \
&& docker-php-ext-install -j$(nproc) mcrypt pcntl zip pdo_mysql \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& pecl install redis \
&& pecl install xdebug \
&& pecl install swoole \
&& docker-php-ext-enable redis swoole xdebug 
## 安装composer php
RUN curl -sS https://getcomposer.org/installer | php \
&& mv composer.phar /usr/local/bin/composer
