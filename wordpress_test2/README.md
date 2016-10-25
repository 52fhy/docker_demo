### 使用外网
```
wordpress:
  image: daocloud.io/daocloud/dao-wordpress:latest
  environment:
    - WORDPRESS_DB_HOST=119.119.192.246:3306
    - WORDPRESS_DB_USER=root
    - WORDPRESS_DB_PASSWORD=123456
  ports:
    - "80"
```   

Fig命令：  
```
# 停止
fig stop

# 查看日志
fig logs 

# 查看端口 
fig port

# 卸载Fig:
pip uninstall fig

# version:
fig --version
```