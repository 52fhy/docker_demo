# Fig 应用编排

Fig是Docker的应用编排工具，主要用来跟 Docker 一起来构建基于 Docker 的复杂应用，Fig 通过一个配置文件来管理多个Docker容器，非常适合组合使用多个容器进行开发的场景。

说明：目前Fig已经升级并更名为[Compose](https://docs.docker.com/compose/)。Compose向下兼容Fig。 所以学完fig再去看compose也是可以的。   

应用编排工具使得Docker应用管理更为方便快捷。 Fig网站：http://www.fig.sh/   

安装Fig:
```
# 方法一：
curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-`uname 
-s`-`uname -m` > /usr/local/bin/fig; chmod +x /usr/local/bin/fig

# Linux下等效于
curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-Linux-x86_64 > /usr/local/bin/fig; chmod +x /usr/local/bin/fig

# 方法二：
yum install python-pip python-dev
pip install -U fig
```

安装完成后可以查看版本：
```
# fig --version
fig 1.0.1
```

## 入门示例

准备工作：提前下载好镜像：
```
docker pull mysql
docker pull wordpress
```

需要新建一个空白目录，例如figtest。新建一个fig.yml
```
wordpress: 
  image: wordpress:latest 
  links: 
    - db:mysql 
  ports: 
    - "8002:80" 
db: 
  image: mysql 
  environment: 
    - MYSQL_ROOT_PASSWORD=123456
```

以上命令的意思是新建db和wordpress容器。等同于：  
```
$ docker run --name db -e MYSQL_ROOT_PASSWORD=123456 -d mysql
$ docker run --name some-wordpress --link db:mysql -p 8002:80 -d wordpress
```

好，我们启动应用：
```
# fig up
Creating figtest_db_1...
Creating figtest_wordpress_1...
Attaching to figtest_db_1, figtest_wordpress_1
wordpress_1 | Complete! WordPress has been successfully copied to /var/www/html
```

就成功了。浏览器访问 http://localhost:8002（或 http://host-ip:8002）即可。  

默认是前台运行并打印日志到控制台。如果想后台运行，可以：
```
fig up -d
```

应用后台后，可以使用下列命令查看状态：  
```
# fig ps
       Name                      Command               State          Ports         
-----------------------------------------------------------------------------------
figtest_db_1          docker-entrypoint.sh mysqld      Up      3306/tcp             
figtest_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8002->80/tcp 

# fig logs
Attaching to figtest_wordpress_1, figtest_db_1
db_1        | 2016-10-14T14:38:46.498030Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
db_1        | 2016-10-14T14:38:46.499974Z 0 [Note] mysqld (mysqld 5.7.15) starting as process 1 ...
db_1        | 2016-10-14T14:38:46.727191Z 0 [Note] InnoDB: PUNCH HOLE support available


```

停止应用：
```
# fig stop
Stopping figtest_wordpress_1...
Stopping figtest_db_1...
```

重新启动应用：
```
fig restart
```

## scale
该命令可以设置一次性启动的容器数目：  

fig.yml  
```
wordpress: 
  image: daocloud.io/daocloud/dao-wordpress:latest 
  environment: 
    - WORDPRESS_DB_HOST=119.119.112.246
    - WORDPRESS_DB_USER=root
    - WORDPRESS_DB_PASSWORD=123456
  ports: 
    - "80" 
```
注意端口ports不要指定本机的。  

然后：
```
fig scale wordpress=2
```
将启动两个容器：
```
Starting wordpresstest2_wordpress_1...
Starting wordpresstest2_wordpress_2...

fig ps
           Name                         Command               State           Ports         
-------------------------------------------------------------------------------------------
wordpresstest2_wordpress_1   /opt/adapter.sh /entrypoin ...   Up      0.0.0.0:32768->80/tcp 
wordpresstest2_wordpress_2   /opt/adapter.sh /entrypoin ...   Up      0.0.0.0:32769->80/tcp 
```

## fig.yml参考
每个fig.yml必须定义`image`或者`build`中的一个，其它的是可选的。
### image
指定镜像tag或者ID。示例：
```
image: ubuntu
image: orchardup/postgresql
image: a4bc65fd
```

### build
用来指定一个包含`Dockerfile`文件的路径。一般是当前目录`.`。Fig将build并生成一个随机命名的镜像。


### command
用来覆盖缺省命令。示例：
```
command: python app.py
```

### links
用于链接另一容器服务，如需要使用到另一容器的mysql服务。可以给出服务名和别名；也可以仅给出服务名，这样别名将和服务名相同。同`docker run --link`。示例：
```
links:
 - db
 - db:mysql
 - redis
```

使用了别名将自动会在容器的`/etc/hosts`文件里创建相应记录：
```
172.17.2.186  db
172.17.2.186  mysql
172.17.2.187  redis
```
所以我们在容器里就可以直接使用别名作为服务的主机名。

### ports
用于暴露端口。同`docker run -p`。示例：
```
ports:
 - "3000"
 - "8000:8000"
 - "49100:22"
 - "127.0.0.1:8001:8001"
```

### expose
expose提供container之间的端口访问，不会暴露给主机使用。同`docker run --expose`。
```
expose:
 - "3000"
 - "8000"
```

### volumes
挂载数据卷。同`docker run -v`。示例：
```
volumes:
 - /var/lib/mysql
 - cache/:/tmp/cache
 - ~/configs:/etc/configs/:ro
```

### volumes_from
挂载数据卷容器，挂载是容器。同`docker run --volumes-from`。示例：
```
volumes:
volumes_from:
 - service_name
 - container_name
```

### environment
添加环境变量。同`docker run -e`。可以是数组或者字典格式：
```
environment:
  RACK_ENV: development
  SESSION_SECRET:

environment:
  - RACK_ENV=development
  - SESSION_SECRET
```

### net
设置网络模式。同docker的`--net`参数。
```
net: "bridge"
net: "none"
net: "container:[name or id]"
net: "host"
```

### dns
自定义dns服务器。
```
dns: 8.8.8.8
dns:
  - 8.8.8.8
  - 9.9.9.9
```

### working_dir, entrypoint, user, hostname, domainname, mem_limit, privileged
这些命令都是单个值，含义请参考[docker run](Docker run reference - Docker
https://docs.docker.com/engine/reference/run/)。
```
working_dir: /code
entrypoint: /code/entrypoint.sh
user: postgresql

hostname: foo
domainname: foo.com

mem_limit: 1000000000
privileged: true
```

关于mem_limit实际测试发现无效果，升级到docker-compose才可以。

## 命令行参考
``` shell
$ fig
Fast, isolated development environments using Docker.

Usage:
  fig [options] [COMMAND] [ARGS...]
  fig -h|--help

Options:
  --verbose                 Show more output
  --version                 Print version and exit
  -f, --file FILE           Specify an alternate fig file (default: fig.yml)
  -p, --project-name NAME   Specify an alternate project name (default: directory name)

Commands:
  build     Build or rebuild services
  help      Get help on a command
  kill      Kill containers
  logs      View output from containers
  port      Print the public port for a port binding
  ps        List containers
  pull      Pulls service images
  rm        Remove stopped containers
  run       Run a one-off command
  scale     Set number of containers for a service
  start     Start services
  stop      Stop services
  restart   Restart services
  up        Create and start containers
```

## 批处理脚本
```
# 关闭所有正在运行容器
docker ps | awk  '{print $1}' | xargs docker stop

# 删除所有容器应用
docker ps -a | awk  '{print $1}' | xargs docker rm
# 或者
docker rm $(docker ps -a -q)
```

> 参考：  
1、Fig | Fast, isolated development environments using Docker  
http://www.fig.sh  
2、library/mysql - Docker Hub  
https://hub.docker.com/_/mysql/  
3、library/wordpress - Docker Hub  
https://hub.docker.com/_/wordpress/  