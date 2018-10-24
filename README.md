# 用docker搭建统一的开发环境

## 注：环境会偶尔更新（如：php版本，或需要添加扩展等等），版本号会一直增加，无特殊说明，请使用最新版。

## 下载docker

省略....

## 环境说明

Linux + Nginx + PHP + Redis + Mysql

暂时先分为两个镜像

1）Linux + Nginx

2）Linux + PHP （xdebug , Phalcon , Redis 等扩展） + Composer

3）V3：加上了pcntl和mongodb扩展

4）V4：加上了xxtea扩展

Linux为：alpine v3.8

PHP：7.2.11

Nginx：1.14

## 直接pull

```sh
docker pull chenchenchen/alpine3.8_php72_fpm:v4
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

## 进入运行中的容器

很多时候，需要进入运行中的容器查看或修改相关文件

如：在win下某些模块无法composer install，可使用下面方法

docker exec -it 容器名 /bin/sh

cd 需要加载composer的目录 && composer install