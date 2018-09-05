#/usr/bin

# phalcon自动的install脚本是bash写的

#    && wget -c "https://codeload.github.com/phalcon/cphalcon/zip/v${phalconVer}" -O v${phalconVer}.zip -t 3 -T 3 \
#    && ls \

#   && wget -c "https://pecl.php.net/get/${igbVersion}.tgz" -t 3 -T 3 \

#    wget https://getcomposer.org/installer -t 3 -T 3\
#   && if [ ! -f installer ];then
#            echo "composer download fail"
#        else
#            php installer --install-dir=/usr/bin --filename=composer
#    fi \

#    && wget -c "https://pecl.php.net/get/${redisVersion}.tgz" -t 3 -T 3 \
#    && wget "https://pecl.php.net/get/${xdebugVersion}.tgz" -t 3 -T 3 \
#       && cp ${srcDir}/php.ini /usr/local/etc/php/ \

#    && cd $srcDir \
#    && tar xf ${memcachedVersion}.tgz \
#    && cd ${memcachedVersion} \
#    && phpize && ./configure && make && make install \
#


apk update \
    && apk add --no-cache --virtual .build-deps bash autoconf gcc libc-dev make re2c libpng libpng-dev freetype freetype-dev file \
    && srcDir="/opt/src" && phalconVer="3.4.x" && igbVersion="igbinary-2.0.7" && redisVersion="redis-4.1.1" && xdebugVersion="xdebug-2.6.1" && memcachedVersion="memcached-3.0.4" \
    &&  if [ ! -d $srcDir ]; then
        mkdir $srcDir
    fi  \
    && cd $srcDir \
    \
    && unzip v${phalconVer}.zip \
    && cd ./cphalcon-${phalconVer}/build/php7/64bits/ \
    && phpize \
    && ./configure \
    && make && make install \
    && echo "phalcon installed" && sleep 5s \
    && cd $srcDir \
    \
    && tar xf ${igbVersion}.tgz \
    && cd ${igbVersion} \
    && phpize \
    && ./configure \
    && make && make install \
    && cd $srcDir \
    && tar xf ${redisVersion}.tgz \
    && cd ${redisVersion} \
    && phpize \
    && ./configure --enable-redis-igbinary=yes --enable-redis-lzf=yes \
    && make && make install \
    && cd $srcDir \
    && tar xf ${xdebugVersion}.tgz \
    && cd ${xdebugVersion} \
    && phpize \
    && ./configure \
    && make && make install \
    && cd $srcDir \
    \
    && echo "to install composer" \
    && php installer --install-dir=/usr/bin --filename=composer && sleep 5s \
    \
    && echo "to install ext" \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable phalcon pdo pdo_mysql igbinary redis \
    && echo "ext-enable" && sleep 5s \
    && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /usr/local/etc/php-fpm.conf \
    && echo "sed" \
    && find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true \
    && echo "strip" \
    && docker-php-source delete \
    && echo "delete" \
    && runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --no-cache --virtual .php-rundeps $runDeps \
	&& apk del .build-deps \
    \
	&& rm -rf /tmp/pear ~/.pearrc \
    && apk del bash autoconf gcc libc-dev make re2c \
    && rm -rf /opt/*

#   && pecl update-channels \
#   && echo "pecl" \
#
#sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf
#sed -i -e "s/www-data/www/g" /usr/local/etc/php-fpm.d/www.conf