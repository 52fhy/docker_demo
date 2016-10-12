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