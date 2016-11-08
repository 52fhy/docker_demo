#!/bin/bash
tar zcvf banyar.tar.gz \
 --exclude=/App/banyar/Data \
 --exclude=/App/banyar/Runtime \
 --exclude=/App/banyar/Logs \
 --exclude=/App/banyar/.git  \
 --exclude=/App/banyar/swoole/LogServer/logs \
 --exclude=/App/banyar/swoole/data/log \
 /App/banyar
