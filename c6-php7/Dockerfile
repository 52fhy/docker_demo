# centos6 php7 nginx1.11
FROM centos:centos6.8

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

#   RUN wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz \
COPY libmcrypt-2.5.8.tar.gz /libmcrypt-2.5.8.tar.gz
COPY mcrypt-2.6.8.tar.gz /mcrypt-2.6.8.tar.gz
COPY mhash-0.9.9.9.tar.gz /mhash-0.9.9.9.tar.gz

RUN tar zxvf /libmcrypt-2.5.8.tar.gz \
    && cd /libmcrypt-2.5.8 && ./configure && make && make install && cd - / && rm -rf /libmcrypt* \
    && tar zxvf /mhash-0.9.9.9.tar.gz && cd mhash-0.9.9.9 && ./configure && make && make install && cd - / && rm -rf /mhash* \
    && tar zxvf /mcrypt-2.6.8.tar.gz && cd mcrypt-2.6.8 && LD_LIBRARY_PATH=/usr/local/lib ./configure && make && make install && cd - / && rm -rf /mcrypt* 
	
RUN wget http://cn2.php.net/distributions/php-7.0.7.tar.bz2 \
    && tar jxvf php-7.0.7.tar.bz2 && cd php-7.0.7 \
    && ./configure --prefix=/usr/local/php --with-config-file-scan-dir=/usr/local/php/etc/ --enable-inline-optimization --enable-opcache --enable-session --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --with-sqlite3 --with-gettext --enable-mbregex --enable-mbstring --enable-xml --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-xmlrpc --with-libxml-dir --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-curlwrappers --with-zlib --enable-zip --with-bz2 --with-gd --enable-gd-native-ttf --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-readline \
    && make && make install \
    && cp php.ini-production php.ini \
    && cp php.ini* /usr/local/php/etc/ \
    && cp /usr/local/php/etc/php-fpm.conf.default  /usr/local/php/etc/php-fpm.conf \
    && make clean && yum clean all && cd ../
	
RUN yum -y install pcre-devel && yum clean all
RUN wget http://nginx.org/download/nginx-1.11.1.tar.gz \
    && tar zxvf nginx-1.11.1.tar.gz && cd nginx-1.11.1 \
    && ./configure \
    --prefix=/usr/local/nginx \
    --with-http_stub_status_module  \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_sub_module \
    --with-http_gzip_static_module \
    --with-pcre \
    && make && make install \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/bin  \
    && make clean && yum clean all \
    && cd ../ && rm -rf php-7.0.7* && rm -rf nginx-1.11.1* \

EXPOSE 80
CMD ["/bin/bash"]
