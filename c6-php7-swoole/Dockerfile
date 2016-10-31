# centos6 php7 nginx1.11 swoole1.8.12
FROM c6-php7:latest

MAINTAINER yjc@52fhy.com

COPY 1.8.12-stable.zip /1.8.12-stable.zip
COPY redis-3.2.0.tar.gz /redis-3.2.0.tar.gz
COPY 3.0.0-rc1.zip /3.0.0-rc1.zip

#RUN wget https://github.com/swoole/swoole-src/archive/1.8.12-stable.zip \
RUN echo 'install swoole' \
    && unzip /1.8.12-stable.zip && cd swoole-src-1.8.12-stable \
	&& ln -s /usr/local/php/bin/php /usr/bin/php \
	&& ln -s /usr/local/php/bin/phpize /usr/bin/phpize \
	&& ln -s /usr/local/php/bin/php-config /usr/bin/php-config \
	&& /usr/local/php/bin/phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=swoole.so" >> /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf swoole-src-1.8.12-stable
	
#RUN wget http://download.redis.io/releases/redis-3.2.0.tar.gz \
RUN echo 'install redis' \
    && tar xzf /redis-3.2.0.tar.gz && cd redis-3.2.0 \
    && make \
	&& mkdir /usr/local/redis \
	&& cp redis.conf /usr/local/redis/ \
	&& cd src && cp  redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis \
    && cd ../ && rm -rf redis-3.2.0
	
#RUN wget https://github.com/phpredis/phpredis/archive/3.0.0-rc1.zip \
RUN echo 'install phpredis' \
    && unzip /3.0.0-rc1.zip && cd phpredis-3.0.0-rc1/ \
	&& /usr/local/php/bin/phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=redis.so" >> /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf phpredis-3.0.0-rc1

CMD ["/bin/bash"]
