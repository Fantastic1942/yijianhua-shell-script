#!/bin/bash

# 查询系统基本信息
query_system_info() {
    echo "========= 系统信息 ========="
 
# 检查是否安装了 bc，如果没有，则尝试安装
if ! command -v bc &> /dev/null; then
    echo "安装 bc 工具..."
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y bc
    elif [[ -f /etc/redhat-release ]]; then
        sudo yum install -y bc
    else
        echo "无法确定系统发行版，无法安装 bc。请手动安装 bc 后再运行脚本。"
        exit 1
    fi
fi

# 获取主机名
hostname=$(hostname)

# 获取系统版本信息
os_version=$(cat /etc/*release | grep "PRETTY_NAME" | cut -d "=" -f 2 | tr -d '"')

# 获取 Linux 内核版本
linux_version=$(uname -r)

# 获取 CPU 架构
cpu_architecture=$(uname -m)

# 获取 CPU 型号和核心数
cpu_model=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ":" -f 2 | tr -s ' ')
cpu_cores=$(grep -c '^processor' /proc/cpuinfo)

# 获取 CPU 占用情况
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# 获取物理内存和虚拟内存
physical_memory=$(free -h | awk '/^Mem:/{print $2}')
swap_memory=$(free -h | awk '/^Swap:/{print $2}')

# 获取硬盘占用和总容量
disk_usage=$(df -h / | awk 'NR==2{print "已用: " $3 ", 总容量: " $2}')

# 获取总接收流量和总发送流量（转换为 GB）
network_rx=$(cat /proc/net/dev | awk '/eth0/{print $2/1024/1024/1024}')
network_tx=$(cat /proc/net/dev | awk '/eth0/{print $10/1024/1024/1024}')

# 获取网络拥堵算法
congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)

# 获取公网 IPv4 地址（需要有网络连接）
ipv4_address=$(curl -s https://ipv4.icanhazip.com)

# 获取公网 IPv6 地址（需要有网络连接）
ipv6_address=$(curl -s https://ipv6.icanhazip.com)

# 获取系统时间和系统运行时长
system_time=$(date)
uptime=$(uptime)

# 显示所有信息
echo "主机名: $hostname"
echo "系统版本: $os_version"
echo "Linux 内核版本: $linux_version"
echo "CPU 架构: $cpu_architecture"
echo "CPU 型号: $cpu_model"
echo "CPU 核心数: $cpu_cores"
echo "CPU 占用: $cpu_usage"
echo "物理内存: $physical_memory"
echo "虚拟内存: $swap_memory"
echo "硬盘占用和总容量: $disk_usage"
echo "总接收流量: $(printf "%.2f" "$network_rx") GB"
echo "总发送流量: $(printf "%.2f" "$network_tx") GB"
echo "网络拥堵算法: $congestion_algorithm"
echo "公网 IPv4 地址: $ipv4_address"
echo "公网 IPv6 地址: $ipv6_address"
echo "系统时间: $system_time"
echo "系统运行时长: $uptime"
    echo "============================"
}

# 更新 Ubuntu 系统
update_ubuntu() {
    echo "开始更新 Ubuntu 系统..."
    sudo apt update && sudo apt upgrade -y
    echo "Ubuntu 系统更新完成！"
}

# 更新 CentOS 系统
update_centos() {
    echo "开始更新 CentOS 系统..."
    sudo yum update -y
    echo "CentOS 系统更新完成！"
}

# 更新 Alpine 系统
update_alpine() {
    echo "开始更新 Alpine 系统..."
    sudo apk update && sudo apk upgrade
    echo "Alpine 系统更新完成！"
}

# 更新 Debian 系统
update_debian() {
    echo "开始更新 Debian 系统..."
    sudo apt update && sudo apt upgrade -y
    echo "Debian 系统更新完成！"
}

# 清理系统
clean_system() {
    echo "开始清理系统..."
    if command -v apt &>/dev/null; then
        sudo apt clean    # 清理APT缓存（仅适用于Debian/Ubuntu）
    fi
    if command -v yum &>/dev/null; then
        sudo yum clean all    # 清理Yum缓存（仅适用于CentOS/RHEL）
    fi
    if command -v apk &>/dev/null; then
        sudo apk cache clean    # 清理APK缓存（仅适用于Alpine）
    fi
    echo "系统清理完成！"
}

# 更新系统
update_system() {
    # 询问是否查询系统信息
    echo -n "是否查询系统信息？(y/n): "
    read choice
    if [[ $choice == [yY] ]]; then
        query_system_info
    fi

    # 询问是否继续更新系统
    echo -n "是否继续更新系统？(y/n): "
    read choice
    if [[ $choice == [yY] ]]; then
        if [ -f /etc/os-release ]; then
            source /etc/os-release
            case "$ID" in
                ubuntu)
                    update_ubuntu
                    ;;
                centos)
                    update_centos
                    ;;
                alpine)
                    update_alpine
                    ;;
                debian)
                    update_debian
                    ;;
                *)
                    echo "未知的 Linux 发行版。"
                    ;;
            esac
        else
            echo "无法识别的 Linux 发行版。"
        fi
    fi

    # 询问是否清理系统
    echo -n "是否清理系统？(y/n): "
    read choice
    if [[ $choice == [yY] ]]; then
        clean_system
    fi
}

# 显示菜单选项
show_menu() {
    echo "========== 菜单 =========="
    echo "1. 更新系统"
    echo "0. 退出脚本"
    echo "=========================="
    echo -n "请选择操作 [0-1]: "
}

# 主程序
while true; do
    show_menu
    read choice
    case $choice in
        1)
            update_system
            ;;
        0)
            echo "已退出脚本，感谢您的使用。"
            break
            ;;
        *)
            echo "无效的选项，请重新选择。"
            ;;
    esac
done
