#!/bin/sh
# This script is meant to run on the nodes

echo "Running apt-get"

apt-get update

kubeadm join --discovery-token-unsafe-skip-ca-verification --token=102952.1a7dd4cc8d1f4cc5 172.17.0.50:6443
