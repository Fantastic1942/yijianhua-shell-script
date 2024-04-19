#!/bin/sh

# 获取系统信息
distro=$(grep '^NAME=' /etc/os-release | sed 's/NAME=//; s/"//g')
version=$(grep '^VERSION_ID=' /etc/os-release | sed 's/VERSION_ID=//; s/"//g')
echo "Detected Linux distribution: $distro"
echo "Version: $version"

# 根据系统信息执行更新命令
case $distro in
    "Ubuntu")
        echo "Updating Ubuntu system..."
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
        sudo apt autoclean
        ;;
    "CentOS Linux")
        echo "Updating CentOS system..."
        sudo yum update -y
        ;;
    "Alpine Linux")
        echo "Updating Alpine system..."
        sudo apk update
        sudo apk upgrade
        ;;
    *)
        echo "Unsupported Linux distribution: $distro"
        exit 1
        ;;
esac

echo "System update completed."

