#!/bin/bash
# removing swap if present
sudo sed -i '/ swap / s/^/#/' /etc/fstab
swapoff -a
apt-get update
apt install -y docker.io apt-transport-https curl software-properties-common ufw
systemctl enable docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get install kubeadm -y
# Updating docker cgrtoup driver and logs (https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

kubeadm init
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config


ufw allow from 185.139.30.137
ufw allow from 178.250.64.42
ufw allow from 176.9.103.215
ufw allow from 176.9.127.107
ufw allow from 78.46.37.142
ufw allow from 172.16.0.0/16
ufw allow from 172.18.0.0/16
ufw allow from 172.21.0.0/16
ufw enable

