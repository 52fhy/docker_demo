# centos6 php7 swoole
FROM skiychan/nginx-php7:latest

MAINTAINER yjc@52fhy.com


RUN yum install -y gcc gcc-c++ make cmake bison autoconf wget lrzsz \
    && yum install -y libtool libtool-ltdl-devel \
    && yum install -y freetype-devel libjpeg.x86_64 libjpeg-devel libpng-devel gd-devel \
#    && yum install -y libmcrypt-devel libmhash-devel \
    && yum install -y python-devel  patch  sudo \
    && yum install -y openssl* openssl openssl-devel ncurses-devel \
    && yum install -y bzip* bzip2 unzip zlib-devel \
    && yum install -y --skip-broken libevent* \
    && yum install -y libxml* libxml2-devel \
    && yum install -y libcurl* curl-devel \
    && yum install -y readline-devel \
    && yum clean all

RUN wget https://github.com/swoole/swoole-src/archive/1.8.12-stable.zip \
    && unzip 1.8.12-stable.zip && cd swoole-src-1.8.12-stable \
	&& ln -s /usr/local/php/bin/php /usr/bin/php \
	&& ln -s /usr/local/php/bin/phpize /usr/bin/phpize \
	&& ln -s /usr/local/php/bin/php-config /usr/bin/php-config \
	&& /usr/local/php/bin/phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=swoole.so" >> /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf swoole-src-1.8.12-stable
	
RUN wget http://download.redis.io/releases/redis-3.2.0.tar.gz \
    && tar xzf redis-3.2.0.tar.gz && cd redis-3.2.0 \
    && make \
	&& mkdir /usr/local/redis \
	&& cp redis.conf /usr/local/redis/ \
	&& cd src && cp  redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis \
    && cd ../ && rm -rf redis-3.2.0
	
RUN wget https://github.com/phpredis/phpredis/archive/3.0.0-rc1.zip \
    && unzip 3.0.0-rc1 && cd phpredis-3.0.0-rc1/ \
	&& /usr/local/php/bin/phpize \
    && ./configure \
    && make && make install \
	&& echo "extension=redis.so" >> /usr/local/php/etc/php.ini \
    && cd ../ && rm -rf phpredis-3.0.0-rc1

CMD ["/bin/bash"]
