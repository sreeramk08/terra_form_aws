#!/bin/sh
# This script runs on the kubernetes master

echo "Running apt-get"

apt-get update

sudo kubeadm init --token=102952.1a7dd4cc8d1f4cc5 --kubernetes-version $(kubeadm version -o short)

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
#export KUBECONFIG=$HOME/admin.conf

sudo echo "export KUBECONFIG=$HOME/admin.conf" >> ~/.bashrc
source ~/.bashrc

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

