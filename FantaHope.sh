#!/bin/bash


# 显示系统更新菜单
echo "系统更新菜单："
echo "1. 更新 Ubuntu/Debian 系统"
echo "2. 更新 CentOS 系统"
echo "3. 更新 Alpine 系统"
echo "0. 退出"

# 提示用户输入序号
read -p "请选择序号以执行相应的系统更新命令： " choice

# 根据用户选择执行相应的更新命令
case $choice in
    1)
        echo "更新 Ubuntu/Debian 系统..."
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
        sudo apt autoclean
        ;;
    2)
        echo "更新 CentOS 系统..."
        sudo yum update -y
        ;;
    3)
        echo "更新 Alpine 系统..."
        sudo apk update
        sudo apk upgrade
        ;;
    0)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效的选择"
        ;;
esac

echo "系统更新完成。"
