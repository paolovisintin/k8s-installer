#!/bin/bash
apt-get update
apt install -y docker.io apt-transport-https curl software-properties-common ufw
systemctl enable docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get install kubeadm -y
kubeadm init
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config


ufw allow from 185.139.30.137
ufw allow from 178.250.64.42
ufw allow from 176.9.103.215
ufw allow from 176.9.127.107
ufw allow from 78.46.37.142
ufw enable

