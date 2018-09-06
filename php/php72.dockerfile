FROM php:7.2.9-fpm-alpine3.8

ENV TIMEZONE Asia/Shanghai
ENV SOFTDIR /opt/src

COPY \
    ./v3.4.x.zip \
	./igbinary-2.0.7.tgz \
	./redis-4.1.1.tgz \
	./xdebug-2.6.1.tgz \
	./php.ini \
	./installer \
	${SOFTDIR}/

RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.8/main" > /etc/apk/repositories && \
    apk update && \
    apk add tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apk add \
    --no-cache --virtual .build-deps wget bash autoconf gcc libc-dev make re2c libbz2 zlib-dev libpng libpng-dev freetype freetype-dev file && \
    phalconVer="3.4.x" && igbVersion="igbinary-2.0.7" && redisVersion="redis-4.1.1" && xdebugVersion="xdebug-2.6.1" && \
    \
    cd ${SOFTDIR} && unzip v${phalconVer}.zip && cd ./cphalcon-${phalconVer}/build/php7/64bits/ && phpize && ./configure && make && make install && \
    cd ${SOFTDIR} && tar xf ${igbVersion}.tgz && cd ${igbVersion} && phpize && ./configure && make && make install && \
    cd ${SOFTDIR} && tar xf ${redisVersion}.tgz && cd ${redisVersion} && phpize && ./configure --enable-redis-igbinary=yes --enable-redis-lzf=yes && make && make install && \
    cd ${SOFTDIR} && tar xf ${xdebugVersion}.tgz && cd ${xdebugVersion} && phpize && ./configure && make && make install && \
    cd ${SOFTDIR} && \
    php installer --install-dir=/usr/bin --filename=composer && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    echo "gd installed" && sleep 5s && \
    docker-php-ext-install pdo pdo_mysql && \
    docker-php-ext-enable gd phalcon pdo pdo_mysql igbinary redis xdebug && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /usr/local/etc/php-fpm.conf && \
    find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true && \
    docker-php-source delete && \
    runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" && \
	apk add --no-cache --virtual $runDeps && \
	rm -rf /tmp/pear ~/.pearrc && \
    apk del .build-deps bash autoconf gcc libc-dev make re2c && \
    rm -rf /opt/* && \
    rm -rf /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/php.ini && \
    rm -rf /usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/zz-docker.conf && \
    apk add libpng-dev freetype-dev

COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./zz-docker.conf \
    ./www.conf \
    /usr/local/etc/php-fpm.d/

EXPOSE 9000
ENTRYPOINT ["php-fpm"]