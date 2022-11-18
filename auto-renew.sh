#!/bin/bash

source /etc/profile
source /root/.bashrc

export PATH=/usr/bin:/usr/local/bin:/root/bin:$PATH

echo "path=$PATH"

cd /root/golive-quick-install

docker compose pull