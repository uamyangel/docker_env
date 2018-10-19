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

## 直接pull

```sh
docker pull chenchenchen/alpine3.8_php72_fpm:v2
docker pull chenchenchen/nginx1.14:v2
```

## 流程

### Nginx构建

直接构建nginx目录下的 nginx_apline 即可

```sh
docker build -f ./nginx/nginx_alpine
```

### PHP构建

1）修改php72.dockerfile相关配置（包版本号等）

2）执行docker build -f php72.dockerfile . ，创建基础镜像

## 关于DEMO

env文件夹下面是运行的demo，请注意修改镜像的名称，以及请根据需要加载需要的配置文件