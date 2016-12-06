#!/bin/bash

#echo 1 > /proc/sys/vm/overcommit_memory
#echo 511 > /proc/sys/net/core/somaxconn

# mkdir
mkdir -p /data/log/redis/
chmod -R 777 /data/log/redis

# 启动
/usr/local/redis/bin/redis-server /usr/local/redis/redis.conf

# 打印日志确保容器一直运行
tail -f /data/log/redis/redis.log