#!/bin/bash


clear


# Green, Yellow & Red Messages.
green_msg() {
    tput setaf 2
    echo "[*] ----- $1"
    tput sgr0
}

yellow_msg() {
    tput setaf 3
    echo "[*] ----- $1"
    tput sgr0
}

red_msg() {
    tput setaf 1
    echo "[*] ----- $1"
    tput sgr0
}


# Paths
HOST_PATH="/etc/hosts"
DNS_PATH="/etc/resolv.conf"


# Intro
echo 
green_msg '================================================================='
green_msg 'This script will automatically Optimize your Linux Server.'
green_msg 'Tested on: Ubuntu 16+, Debian 11+, CentOS 8+, Fedora 37+'
green_msg 'Root access is required.' 
green_msg 'Source is @ https://github.com/hawshemi/linux-optimizer' 
green_msg '================================================================='
echo 


# Root
check_if_running_as_root() {
    # If you want to run as another user, please modify $EUID to be owned by this user
    if [[ "$EUID" -ne '0' ]]; then
      echo 
      red_msg 'Error: You must run this script as root!'
      echo 
      sleep 0.5
      exit 1
    fi
}


# Check Root
check_if_running_as_root
sleep 0.5


fix_etc_hosts(){ 
  echo 
  yellow_msg "Fixing Hosts file."
  echo 
  sleep 0.5

  echo 
  cp $HOST_PATH /etc/hosts.bak
  yellow_msg "Default hosts file saved. Directory: /etc/hosts.bak"
  echo 
  sleep 0.5

  if ! grep -q $(hostname) $HOST_PATH; then
    echo "127.0.1.1 $(hostname)" | sudo tee -a $HOST_PATH > /dev/null
    echo 
    green_msg "Hosts Fixed."
    echo 
    sleep 0.5
  else
    echo 
    green_msg "Hosts OK. No changes made."
    echo 
    sleep 0.5
  fi
}


# Fix DNS
fix_dns(){
    echo 
    yellow_msg "Fixing DNS Temporarily."
    echo 
    sleep 0.5

    echo 
    cp $DNS_PATH /etc/resolv.conf.bak
    yellow_msg "Default resolv.conf file saved. Directory: /etc/resolv.conf.bak"
    echo 
    sleep 0.5

    sed -i '/nameserver/d' $DNS_PATH

    echo "nameserver 1.1.1.1" >> $DNS_PATH
    echo "nameserver 1.0.0.1" >> $DNS_PATH
    echo "nameserver 8.8.8.8" >> $DNS_PATH
    echo "nameserver 8.8.4.4" >> $DNS_PATH

    echo 
    green_msg "DNS Fixed Temporarily."
    echo 
    sleep 0.5
}


# Run
fix_etc_hosts
fix_dns


# OS Detection
if [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Ubuntu" ]]; then
    OS="ubuntu"
    echo 
    sleep 0.5
    yellow_msg "OS: Ubuntu"
    echo 
    sleep 1
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Debian GNU/Linux" ]]; then
    OS="debian"
    echo 
    sleep 0.5
    yellow_msg "OS: Debian"
    echo 
    sleep 1
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "CentOS Stream" ]]; then
    OS="centos"
    echo 
    sleep 0.5
    yellow_msg "OS: Centos"
    echo 
    sleep 1
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Fedora Linux" ]]; then
    OS="fedora"
    echo 
    sleep 0.5
    yellow_msg "OS: Fedora"
    echo 
    sleep 1
else
    echo 
    sleep 0.5
    red_msg "Unknwon OS, Create an issue here: https://github.com/hawshemi/Linux-Optimizer"
    OS="unknown"
    echo 
    sleep 2
fi


# Run Script based on Distros
case $OS in
ubuntu)
    # Ubuntu
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/ubuntu-optimizer.sh" -q -O ubuntu-optimizer.sh && chmod +x ubuntu-optimizer.sh && bash ubuntu-optimizer.sh 
    ;;
debian)
    # Debian
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/debian-optimizer.sh" -q -O debian-optimizer.sh && chmod +x debian-optimizer.sh && bash debian-optimizer.sh 
    ;;
centos)
    # CentOS
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/centos-optimizer.sh" -q -O centos-optimizer.sh && chmod +x centos-optimizer.sh && bash centos-optimizer.sh 
    ;;
fedora)
    # Fedora
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/fedora-optimizer.sh" -q -O fedora-optimizer.sh && chmod +x fedora-optimizer.sh && bash fedora-optimizer.sh 
    ;;
unknown)
    # Unknown
    exit 
    ;;
esac
