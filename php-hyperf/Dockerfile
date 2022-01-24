FROM hyperf/hyperf:7.4-alpine-v3.12-swoole-v4.6.7
LABEL maintainer="LuoHui <mylhmail@163.com>" version="1.0" license="MIT" app.name="Hyperf"

ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"} \
    APP_ENV=online \
    SCAN_CACHEABLE=(true)

RUN set -ex \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

COPY docker-php-entrypoint /usr/local/bin/

RUN set -eux \
    # php extension:deps
    && apk update \
    && apk add --no-cache --virtual .php-exts \
        'php7-redis=5.3.2-r3' \
        'php7-amqp=1.10.2-r1' \
        'php7-ftp=7.4.21-r1' \
        'php7-memcached=3.1.5-r1' \
        'php7-mongodb=1.9.0-r1' \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        librdkafka-dev \
        zlib-dev \
    && ln -s /usr/bin/phpize7 /usr/local/bin/phpize \
    && ln -s /usr/bin/php-config7 /usr/local/bin/php-config \
    # php extension:build
    && pecl channel-update pecl.php.net \
    && pecl install rdkafka-3.1.3 \
    && pecl install xlswriter-1.3.7 \
    && chmod +x /usr/lib/php7/modules/rdkafka.so \
    && chmod +x /usr/lib/php7/modules/xlswriter.so \
    # php extension:config
    && { \
        echo "date.timezone=${TIMEZONE}"; \
        echo "memory_limit=1G"; \
        echo "upload_max_filesize=128M"; \
        echo "post_max_size=128M"; \
        echo ""; \
        echo "extension=rdkafka"; \
        echo "extension=xlswriter"; \
    } | tee /etc/php7/conf.d/99_overrides.ini \
    # ---------- clear works ----------
    && apk del --no-network .build-deps \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/lib/php7/modules \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache $runDeps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 /usr/local/bin/php* \
    && echo -e "\033[42;37m Build PHP Extentions Completed :).\033[0m\n"




