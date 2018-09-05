# 用docker搭建统一的开发环境

## 下载docker

省略....

## 环境说明

Linux + Nginx + PHP + Redis + Mysql

暂时先分为两个镜像

1）Linux + Nginx

2）Linux + PHP （xdebug , Phalcon , Redis 等扩展） + Composer

Linux为：alpine v3.8

PHP：7.2.9

Nginx：1.14

## 流程

### Nginx构建

直接构建nginx目录下的 nginx_apline 即可

```sh
docker build -f ./nginx/nginx_alpine
```

### PHP构建

1）更新dockerfile，获取最新的官方的dockerfile  （https://hub.docker.com/_/php/ 选择相应的版本： 7.2.9-fpm-alpine3.8 ），clone下来，先构建基础的php镜像

2）下载相关软件包，并修改php7.2_alpine中的路径，以及alpine_php_ext.sh中的版本号

3）执行docker build -f Dockerfile . ，创建基础镜像

4）执行php7.2_alpine，复制相关的软件包，注意修改 3）产生镜像名称

## 关于DEMO

env文件夹下面是运行的demo，请注意修改镜像的名称，以及请根据需要加载需要的配置文件