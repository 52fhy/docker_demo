# centos6 php7 swoole
FROM c6-php7:latest

MAINTAINER yjc@52fhy.com

RUN echo -e '\nexport PATH=/usr/local/php/bin:/usr/local/php/sbin:$PATH\n' >> /etc/profile && source /etc/profile
RUN wget https://github.com/swoole/swoole-src/archive/1.8.12-stable.zip \
    && unzip 1.8.12-stable.zip && cd swoole-src-1.8.12-stable \
	&& /usr/local/php/bin/phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config \
    && make && make install \
	&& echo "extension=swoole.so" > /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf swoole-src-1.8.12-stable
	
RUN wget http://download.redis.io/releases/redis-3.2.0.tar.gz \
    && tar xzf redis-3.2.0.tar.gz && cd redis-3.2.0 \
    && make \
	&& mkdir /usr/local/redis \
	&& cp redis.conf /usr/local/redis/ \
	&& cd src && cp  redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis \
	&& echo "extension=swoole.so" > /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf swoole-src-1.8.12-stable
	
RUN wget https://github.com/phpredis/phpredis/archive/3.0.0-rc1.zip \
    && unzip 3.0.0-rc1 && cd phpredis-3.0.0-rc1/ \
	&& /usr/local/php/bin/phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config \
    && make && make install \
	&& echo "extension=redis.so" > /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf phpredis-3.0.0-rc1

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD /run.sh
