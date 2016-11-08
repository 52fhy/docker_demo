# c7-systemd-php7-swoole 
FROM c7-systemd-php7

MAINTAINER yjc@52fhy.com

ENV SWOOLE_VER 1.8.13
ENV PHP_INI_FILE="/usr/local/php/etc/php.ini"

COPY swoole-src-${SWOOLE_VER}-stable.tar.gz /${SWOOLE_VER}-stable.tar.gz
COPY redis-3.2.0.tar.gz /redis-3.2.0.tar.gz
COPY phpredis-3.0.0.tar.gz /phpredis-3.0.0.tar.gz

#RUN wget https://github.com/swoole/swoole-src/archive/swoole-src-${SWOOLE_VER}-stable.tar.gz \
RUN echo 'install swoole' \
    && tar xzf /${SWOOLE_VER}-stable.tar.gz && cd swoole-src-${SWOOLE_VER}-stable \
	&& ln -s /usr/local/php/bin/php /usr/bin/php \
	&& ln -s /usr/local/php/bin/phpize /usr/bin/phpize \
	&& ln -s /usr/local/php/bin/php-config /usr/bin/php-config \
	&& phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=swoole.so" >> "$PHP_INI_FILE" \
    && cd ../ && rm -rf swoole-src-${SWOOLE_VER}-stable	
	
#RUN wget https://codeload.github.com/phpredis/phpredis/tar.gz/3.0.0.tar.gz\
RUN echo 'install phpredis' \
    && tar xzf /phpredis-3.0.0.tar.gz && cd phpredis-3.0.0/ \
	&& phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=redis.so" >> "$PHP_INI_FILE" \
    && cd ../ && rm -rf phpredis-3.0.0
	
#RUN wget http://download.redis.io/releases/redis-3.2.0.tar.gz \
RUN echo 'install redis' \
    && tar xzf /redis-3.2.0.tar.gz && cd redis-3.2.0 \
    && make \
	&& mkdir /usr/local/redis \
	&& cp redis.conf /usr/local/redis/ \
	&& cd src && cp  redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis \
    && cd ../ && rm -rf redis-3.2.0
	

CMD ["/usr/sbin/init"]
