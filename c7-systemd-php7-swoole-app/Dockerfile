# centos6 php7 swoole
FROM c7-systemd-php7-swoole:latest

MAINTAINER yjc@52fhy.com

#Create web folder
VOLUME ["/App/", "/usr/share/nginx", "/etc/nginx/conf.d", "/var/log/nginx", "/usr/local/nginx/conf/vhost", "/usr/local/php/etc/php.d"]

COPY php-fpm.conf /usr/local/php/etc/php-fpm.conf
COPY www.conf /usr/local/php/etc/php-fpm.d/www.conf

COPY nginx.conf /usr/local/nginx/conf/nginx.conf
ADD banyar.tar.gz /


#CMD ["/bin/bash"]

COPY run.sh /
RUN chmod +x /run.sh

#Set port
EXPOSE 9443 9505 9902 9903 9905 9906

#Start it
CMD ["/bin/bash", "/run.sh"]
