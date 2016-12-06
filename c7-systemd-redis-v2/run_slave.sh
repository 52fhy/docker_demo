#!/bin/bash
docker run -d -p 6301:6379 -v $(pwd)/redis_slave.conf:/usr/local/redis/redis.conf --name redis_dev_slave1 c7-systemd-redis:v2