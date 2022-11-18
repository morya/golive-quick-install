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
apt-get remove docker docker-engine docker.io containerd runc

apt-get install \
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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

}

function check_os_pkg {
    which docker
    if [ $? -ne 0 ]; then
        install_docker
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
    cd golive-quick-install
}

function start_app {
    cd ~/golive-quick-install
    docker compose down
    docker compose up -d
    docker ps -a
}

check_os_pkg
prepare
download_app
start_app
