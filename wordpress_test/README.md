# 使用Docker安装wordpress

docker镜像仓库：  
官方：https://hub.docker.com  
DaoCloud：https://hub.daocloud.io/  
网易蜂巢镜像中心：https://c.163.com/hub#/m/home/  


## 安装mysql容器

下载mysql镜像：  
```
docker pull mysql
```

创建mysql容器并后台运行，指定数据库密码是123456。`-e`指定环境变量。  
```
docker run --name mysql_db -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```


## 使用官方的wordpress

wordpress镜像daocloud.io：  
```
docker pull daocloud.io/daocloud/dao-wordpress:latest
```
拉取镜像前请先登录: `docker login daocloud.io`(请使用用户名进行 login)。  

或者使用wordpress官方镜像：  
```
docker pull wordpress
```

创建wordpress容器应用并后台运行：
```
docker run --name some-wordpress --link mysql_db:mysql -p 8001:80 -d daocloud.io/daocloud/dao-wordpress
```

然后就可以在浏览器通过 http://localhost:8001（或 http://host-ip:8001） 访问站点了。  

如果想使用外部数据库的话，可以通过上述环境变量设置对应数据库的连接方式：
```
$ docker run --name some-wordpress -e WORDPRESS_DB_HOST=10.1.2.3:3306 \
    -e WORDPRESS_DB_USER=... -e WORDPRESS_DB_PASSWORD=... -d wordpress
```	

更多环境变量：  
> `WORDPRESS_DB_HOST` 数据库主机地址（默认为与其 link 的 mysql 容器的 IP 和 3306 端口：<mysql-ip>:3306）
`WORDPRESS_DB_USER` 数据库用户名（默认为 root）
`WORDPRESS_DB_PASSWORD` 数据库密码（默认为与其 link 的 mysql 容器提供的 MYSQL_ROOT_PASSWORD 变量的值）
`WORDPRESS_DB_NAME` 数据库名（默认为 wordpress）
`WORDPRESS_TABLE_PREFIX` 数据库表名前缀（默认为空，您可以从该变量覆盖 wp-config.php 中的配置）
安全相关（默认为随机的 SHA1 值）
`WORDPRESS_AUTH_KEY`
`WORDPRESS_SECURE_AUTH_KEY`
`WORDPRESS_LOGGED_IN_KEY`
`WORDPRESS_NONCE_KEY`
`WORDPRESS_AUTH_SALT`
`WORDPRESS_SECURE_AUTH_SALT`
`WORDPRESS_LOGGED_IN_SALT`
`WORDPRESS_NONCE_SALT`

如果 `WORDPRESS_DB_NAME` 变量指定的数据库不存在时，那么 `wordpress `容器在启动时就会自动尝试创建该数据库，但是由 `WORDPRESS_DB_USER `变量指定的用户需要有创建数据库的权限。  

Dockerfile仓库：https://github.com/docker-library/wordpress
	
	
## 使用Fig编排

安装Fig:
```
# 方法一：
curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-`uname 
-s`-`uname -m` > /usr/local/bin/fig; chmod +x /usr/local/bin/fig

# 方法二：
yum install python-pip python-dev
pip install -U fig
```

编写fig.yml：
```
wordpress:
  image: daocloud.io/daocloud/dao-wordpress:latest
  links:
    - db:mysql
  ports:
    - "8002:80"
db:
  image: mysql
  environment:
    - MYSQL_ROOT_PASSWORD=123456
```

部署应用：
```
fig up

# 启动并后台运行
fig up -d
```

然后就可以在浏览器通过 http://localhost:8002（或 http://host-ip:8002） 访问站点了。  


## 批处理
```
# 关闭所有正在运行容器
docker ps | awk  '{print $1}' | xargs docker stop
```