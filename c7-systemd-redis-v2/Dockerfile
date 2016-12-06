# centos7 redis

## 设置daemonize yes且指定日志打印到某文件

FROM local/c7-systemd

MAINTAINER yjc@52fhy.com

ENV REDIS_VERSION 3.2.0

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN yum install -y gcc gcc-c++ wget lrzsz make \
    && yum clean all

COPY redis-${REDIS_VERSION}.tar.gz /redis-${REDIS_VERSION}.tar.gz

#RUN wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
RUN echo 'install redis' \
    && tar xzf /redis-${REDIS_VERSION}.tar.gz && cd redis-${REDIS_VERSION} \
    && make \
	&& make install PREFIX=/usr/local/redis \
	&& cp redis.conf /usr/local/redis/ \
    && cd ../ && rm -rf redis-${REDIS_VERSION}
	
COPY redis.conf /usr/local/redis/redis.conf
VOLUME ["/data"]

COPY run.sh /
RUN chmod +x /run.sh
	
EXPOSE 6379

CMD ["/bin/bash", "/run.sh"]
