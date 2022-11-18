#!/bin/bash

set -x
# set -o errexit
# set -o nounset

function on_exit {
    echo 'exiting...'
}

trap 'on_exit' SIGINT SIGTERM

function die {
    echo $1
    exit
}

function install_docker {
apt-get remove -y docker docker-engine docker.io containerd runc

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update
apt-get upgrade -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
apt-get install -y jq
}

function check_running_user {
    uid=`id -u`
    if [ "$uid" != "0" ]; then
        die "run this script with root user"
    fi
}

function check_os_pkg {
    which docker
    if [ $? -ne 0 ]; then
        install_docker
    else
        echo "docker is already installed"
    fi
    docker_version=`docker version -f '{{.Client.Version}}' | awk -F'.' '{print $1}'`
    if [ "$docker_version" -lt "20" ]; then
        die "docker version is not 20"
    else
        echo "docker version ok"
    fi
}

function download_app {
    cd /root/
    git clone https://github.com/morya/golive-quick-install.git
}

function start_app {
    cd ~/golive-quick-install
    docker compose pull --force
    docker compose down
    docker compose up -d
    docker ps -a
}

function check_domain {
    domain_ip=`nslookup $1 | grep Address | awk '{print $2}' | tail -1`
    current_ip=$2

    if [ "$domain_ip" != "$current_ip" ]; then
        die "$1 is not pointing to a $current_ip"
    fi
}

function setup_domain {
    current_ip=$(curl -sSL https://ipinfo.io | jq -c -r '.ip')
    
    check_domain $domain $current_ip

    echo "domain setup ok"
}

apt-get install -y jq

check_running_user
check_os_pkg
download_app
setup_domain
start_app
