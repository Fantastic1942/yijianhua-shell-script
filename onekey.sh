#!/bin/sh

 --
 FantaHope
 --
echo "系统信息："
echo "内核名称：" $(uname -s)
echo "主机名：" $(uname -n)
echo "内核版本：" $(uname -r)
echo "操作系统类型：" $(uname -o)
echo "发行版：" $(cat /etc/*-release | grep '^PRETTY_NAME=' | cut -d= -f2 | tr -d '"')
echo "架构：" $(uname -m)
echo "已登录用户：" $(whoami)
echo "当前路径：" $(pwd)

