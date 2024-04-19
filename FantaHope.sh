#!/bin/bash

get_linux_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ -n "$ID" ]; then
            echo "$ID"
            return
        fi
    fi

    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        if [ -n "$DISTRIB_ID" ]; then
            echo "$DISTRIB_ID"
            return
        fi
    fi

    echo "unknown"
}

while true; do
    clear
    echo "系统基本信息菜单"
    echo "1. 更新系统并显示详细信息"
    echo "0. 退出"

    read -p "请选择操作: " choice

    case $choice in
        1)
            # 获取系统信息
            linux_distribution=$(get_linux_distribution)

            echo "系统信息："
            echo "系统版本："
            case $linux_distribution in
                debian)
                    cat /etc/debian_version
                    ;;
                ubuntu)
                    lsb_release -a
                    ;;
                centos)
                    cat /etc/redhat-release
                    ;;
                alpine)
                    cat /etc/alpine-release
                    ;;
                *)
                    echo "$linux_distribution"
                    ;;
            esac
            
            echo "主机名: $(hostname)"
            echo "内核版本: $(uname -r)"
            echo "处理器信息: $(cat /proc/cpuinfo | grep 'model name' | uniq | awk -F: '{print $2}' | sed 's/^[ \t]*//')"
            echo "物理内存: $(free -h | awk '/^Mem/ {print $2}')"
            echo "虚拟内存: $(free -h | awk '/^Swap/ {print $2}')"
            echo "磁盘空间: $(df -h | grep '/dev/sda1' | awk '{print "总容量: " $2 ", 已用: " $3 ", 可用: " $4}')"
            echo "正在更新系统..."
            
            case $linux_distribution in
                debian|ubuntu)
                    sudo apt update && sudo apt upgrade -y
                    ;;
                centos)
                    sudo yum update -y
                    ;;
                alpine)
                    sudo apk update && sudo apk upgrade
                    ;;
                *)
                    echo "未知的Linux发行版，无法自动更新。"
                    ;;
            esac

            read -p "按任意键继续..." key
            ;;
        0)
            echo "谢谢使用，再见！"
            exit 0
            ;;
        *)
            echo "无效的选择，请重新选择。"
            ;;
    esac
done
