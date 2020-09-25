######
# See: https://hub.docker.com/_/php/
######

FROM php:7.2-fpm
MAINTAINER lip <13015531717@163.com>

########  set time

RUN rm -rf /etc/localtime \
&& ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \

######
# change sources.list
######
&& mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
echo \
deb https://mirrors.aliyun.com/debian buster main \
deb https://mirrors.aliyun.com/debian-security buster/updates main \
deb https://mirrors.aliyun.com/debian buster-updates main > /etc/apt/sources.list
######

RUN apt-get update && apt-get install -y \
rinetd \
apt-utils \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
wget \
git \
vim \
zip \
unzip

# You can install php extensions using docker-php-ext-install
######
RUN docker-php-ext-install -j$(nproc) pcntl zip pdo_mysql bcmath sockets \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& pecl install xdebug \
&& pecl install swoole \
&& docker-php-ext-enable swoole xdebug 

# Install redis extension
RUN wget http://pecl.php.net/get/redis-5.3.1.tgz -O /tmp/redis.tar.tgz \
    && pecl install /tmp/redis.tar.tgz \
    && docker-php-ext-enable redis

##安装lib kafuka
RUN wget https://github.com/edenhill/librdkafka/archive/v1.5.0.tar.gz -O /tmp/librdkafka.tar.gz \
&& mkdir /tmp/librdkafka && tar -zxvf /tmp/librdkafka.tar.gz -C /tmp/librdkafka --strip-components=1 \
&& cd /tmp/librdkafka \
&& ./configure \
&& make && make install

RUN wget https://github.com/arnaud-lb/php-rdkafka/archive/3.0.4.tar.gz -O /tmp/php-rdkafka.tar.gz \
&& mkdir /tmp/php-rdkafka && tar -zxvf /tmp/php-rdkafka.tar.gz -C /tmp/php-rdkafka --strip-components=1 \
&& cd /tmp/php-rdkafka \
&& phpize \
&& ./configure --with-php-config=/usr/local/bin/php-config \
&& make && make install \
&& docker-php-ext-enable rdkafka \

&& rm -rf /tmp


#RUN git clone https://github.com/arnaud-lb/php-rdkafka.git \
#&& cd php-rdkafka \
#&& git checkout 3.0.4 \
#&& phpize \
#&& ./configure --with-php-config=/usr/local/bin/php-config \
#&& make && make install \

#RUN pecl install rdkafka \

##rinetd 端口映射 解决php连接127.0.0.1:redis
##/etc/rinetd.conf
RUN echo '0.0.0.0 6379 docker-redis 6379\n0.0.0.0 80 docker-nginx 80' >> /etc/rinetd.conf

## 安装composer php
Run wget https://mirrors.aliyun.com/composer/composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && chmod u+x /usr/local/bin/composer \
    && composer self-update --clean-backups

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# 设置 ENTRYPOINT
ENTRYPOINT /entrypoint.sh




##########.bashrc 宿主机调用容器php命令
##php () {
##        app_dir=$(basename `pwd`)
##        tty=
##        tty -s && tty=--tty
##        docker exec \
##        $tty \
##        --interactive \
##        --workdir /usr/share/nginx/html/$app_dir \
##        docker-php php "$@"
##}


##composer () {
##        app_dir=$(basename `pwd`)
##        tty=
##        tty -s && tty=--tty
##        docker exec \
##        $tty \
##        --interactive \
##        --workdir /usr/share/nginx/html/$app_dir \
##        docker-php composer "$@"
##}
