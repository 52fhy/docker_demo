# centos7 redis

## 设置daemonize no且日志打印到标准输出(日志不指定路径)以保证容器一直运行

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

EXPOSE 6379

CMD ["/usr/local/redis/bin/redis-server", "/usr/local/redis/redis.conf"]   
