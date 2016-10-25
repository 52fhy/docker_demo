# Docker实践：运行Python应用

本例将使用fig应用编排实现一个python的计数器，并使用web展示。   

>阅读本文您需要具备以下知识：  
1、了解Python  
2、熟练Docker基础知识（包括Dockerfile语法）  
3、了解Docker应用编排工具Fig或者Compose  

## 编写计数器程序
app.py
``` python
from flask import Flask
from redis import Redis
import os
app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello World! I have been seen %s times.' % redis.get('hits')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

这里面用到了Flask和Redis扩展，后面会下载。  

## 编写Dockerfile
Dockerfile
```
FROM python:2.7
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
```
内容很简单，指定镜像是python:2.7，并复制当前目录到容器的`/code`目录；然后下载需要的扩展（申明在requirements.txt）。

requirements.txt
```
flask
redis
```

## 编写fig.yml
fig.yml
```
web:
  build: .
  command: python app.py
  ports:
   - "5000:5000"
  volumes:
   - .:/code
  links:
   - redis
redis:
  image: microbox/redis
```
该文件指定镜像来源自build后的镜像，挂载数据卷`/code`，端口是`5000:5000`，使用redis服务，最后执行入口命令`python app.py`。这里为了下载更快，使用了精简版的redis镜像（7M）`microbox/redis`，想用官方redis镜像的话也可以使用`redis`。   

最终当前目录文件有：  
```
$ ls
Dockerfile  app.py  fig.yml  requirements.txt
``` 

## 运行
准备工作已经就绪，可以开始了：
```
# fig up
Creating pythontest_web_1...
Building web...
2.7: Pulling from library/python

7b9457ec39de: Pull complete
ff18e19c2db4: Pull complete
6a3d69edbe90: Pull complete
766692404ca7: Pull complete
0ea0cc832151: Pull complete
f80b8049666f: Pull complete
Digest: sha256:624a11f34d0269de3b99290d895155e1af1d63c8561f49f8ab0f14c089ab256f
Status: Downloaded newer image for python:2.7
 ---> f9a9ac5dcfb8
Step 2 : ADD . /code
 ---> 5f9bacbf918b
Removing intermediate container f3cda5964037
Step 3 : WORKDIR /code
 ---> Running in c19d4f36d857
 ---> 8c780267addd
Removing intermediate container c19d4f36d857
Step 4 : RUN pip install -r requirements.txt
 ---> Running in 551a53e46187
Collecting flask (from -r requirements.txt (line 1))
  Downloading Flask-0.11.1-py2.py3-none-any.whl (80kB)
Collecting redis (from -r requirements.txt (line 2))
  Downloading redis-2.10.5-py2.py3-none-any.whl (60kB)
Collecting itsdangerous>=0.21 (from flask->-r requirements.txt (line 1))
  Downloading itsdangerous-0.24.tar.gz (46kB)
Collecting Jinja2>=2.4 (from flask->-r requirements.txt (line 1))
  Downloading Jinja2-2.8-py2.py3-none-any.whl (263kB)
Collecting Werkzeug>=0.7 (from flask->-r requirements.txt (line 1))
  Downloading Werkzeug-0.11.11-py2.py3-none-any.whl (306kB)
Collecting click>=2.0 (from flask->-r requirements.txt (line 1))
  Downloading click-6.6.tar.gz (283kB)
Collecting MarkupSafe (from Jinja2>=2.4->flask->-r requirements.txt (line 1))
  Downloading MarkupSafe-0.23.tar.gz
Building wheels for collected packages: itsdangerous, click, MarkupSafe
  Running setup.py bdist_wheel for itsdangerous: started
  Running setup.py bdist_wheel for itsdangerous: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/fc/a8/66/24d655233c757e178d45dea2de22a04c6d92766abfb741129a
  Running setup.py bdist_wheel for click: started
  Running setup.py bdist_wheel for click: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/b0/6d/8c/cf5ca1146e48bc7914748bfb1dbf3a40a440b8b4f4f0d952dd
  Running setup.py bdist_wheel for MarkupSafe: started
  Running setup.py bdist_wheel for MarkupSafe: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/a3/fa/dc/0198eed9ad95489b8a4f45d14dd5d2aee3f8984e46862c5748
Successfully built itsdangerous click MarkupSafe
Installing collected packages: itsdangerous, MarkupSafe, Jinja2, Werkzeug, click, flask, redis
Successfully installed Jinja2-2.8 MarkupSafe-0.23 Werkzeug-0.11.11 click-6.6 flask-0.11.1 itsdangerous-0.24 redis-2.10.5
 ---> 7e5d8a3390a8
Removing intermediate container 551a53e46187
Successfully built 7e5d8a3390a8
Attaching to pythontest_redis_1, pythontest_web_1
web_1   |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
web_1   |  * Restarting with stat
web_1   |  * Debugger is active!
web_1   |  * Debugger pin code: 385-160-873
web_1   | 124.65.207.211 - - [15/Oct/2016 01:13:18] "GET / HTTP/1.1" 200 -
```
运行中会下载镜像`python:2.7`和扩展`Flask、Redis`，会比较慢。下载扩展如果失败，可以重新再试一次。  

访问http://0.0.0.0:5000/即可看到效果：  
```
Hello World! I have been seen 1 times.
```



