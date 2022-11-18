# 独立版本部署指南

系统配置要求：

| 配置项 | 要求 |
|-------------|---------------------------------------|
| 操作系统 | Debian 11 / Ubuntu20 / RockyLinux8 |
| Docker | 18.x, 20.x |
| Traefik | v2.6 |

## 具体步骤

### 操作系统更新

以 Debian 11 为例：

```shell
sudo apt-get update
sudo apt-get upgrate
```

### 安装 Docker

具体可参考： https://docs.docker.com/engine/install/debian/#install-using-the-repository

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### 准备 docker-compose 配置

```bash

```
