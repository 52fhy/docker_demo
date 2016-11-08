#!/bin/sh


# tar
chmod -R 777 /App/banyar
mkdir -p /App/banyar/Logs

#cp /App/php-fpm.conf /usr/local/php/etc/php-fpm.conf
#cp /App/www.conf /usr/local/php/etc/php-fpm.d/www.conf
/usr/local/php/sbin/php-fpm  -t
/usr/local/php/sbin/php-fpm         # php-fpm启动

# 启动nginx
#cp /App/nginx.conf /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx

#ln -s /App/banyar/ /data/www/

# 启动日志服务
cd /App/banyar/swoole/server/
/usr/local/php/bin/php logServer.php
/usr/local/php/bin/php reportServer.php
/usr/local/php/bin/php workOrderServer.php
/usr/local/php/bin/php /App/banyar/swoole/server/asynServer.php
cd -

# 启动web服务
/usr/local/php/bin/php /App/banyar/swoole/server/banyarWebServer.php

tail -f /App/banyar/Logs/swoole/$(date +%y-%m)/$(date +%d)/webServer.log
tail -f /var/log/nginx/error.log
