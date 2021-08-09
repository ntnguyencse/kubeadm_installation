#! /bin/bash

HOSTNAME=$(hostname)

sed -i "1s/localhost/"${HOSTNAME}"/g" /etc/hosts

swapoff -a

ufw disable

echo 1 > /proc/sys/net/ipv4/ip_forward

### Translate sources
sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

sudo apt update -y

sudo apt-get update -y

sudo apt-get remove docker docker-engine docker.io -y

sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88 -y

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

sudo apt-get update -y

sudo apt-get install docker-ce -y

sudo bash -c 'sudo cat > /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF'

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo apt-get update -y

sudo apt-get upgrade -y

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update -y

sudo apt-get install -y kubelet kubeadm kubectl -y

sudo apt-mark hold kubelet kubeadm kubectl

kubeadm version
kubelet --version

echo -e "####################### kubeadm installation finished ! #######################\n####################### Set your Master Node & Worker Node #######################"
