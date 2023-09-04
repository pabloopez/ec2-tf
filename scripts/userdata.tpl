#!/bin/bash
# sudo su

# swapoff -a
# cat >>/etc/modules-load.d/containerd.conf<<EOF
# overlay
# br_netfilter
# EOF
# modprobe overlay
# modprobe br_netfilter

# # Add Kernel settings
# cat >>/etc/sysctl.d/kubernetes.conf<<EOF
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables  = 1
# net.ipv4.ip_forward                 = 1
# EOF
# sysctl --system >/dev/null 2>&1

# sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost master/' /etc/hosts

# apt-get update && apt install docker.io -y
# apt-get install -y gpg apt-transport-https ca-certificates curl

# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# apt-get update
# apt-get install -y kubelet kubeadm kubectl
# apt-mark hold kubelet kubeadm kubectl

# kubeadm init --pod-network-cidr=192.168.0.0/16

# export KUBECONFIG=/etc/kubernetes/admin.conf

# kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-

# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml 
# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

# sudo su
# apt -y update && apt -y upgrade 
# # (if we want, at this step is where we need to setup the ec2 hosts as k8s nodes)

# #setup machine with docker + compose
# cd /home/admin/
# curl -fsSL https://get.docker.com -o get-docker.sh
# chmod +x ./get-docker.sh
# sh ./get-docker.sh
# usermod -aG docker admin
# usermod -aG docker root
# usermod -aG docker $USER
# newgrp docker

# #install jupyter (vuln app), maybe change later with log4j in a k8s cluster
# DIR=/home/admin/jupyter
# mkdir $DIR
# wget https://raw.githubusercontent.com/vulhub/vulhub/master/jupyter/notebook-rce/docker-compose.yml -P $DIR
# docker compose -f $DIR/docker-compose.yml up -d


# # agent
# docker run -d --name sysdig-agent --restart always --privileged --net host --pid host \
#     -e ACCESS_KEY \
#     -e COLLECTOR=ingest-us2.app.sysdig.com \
#     -e SECURE=true \
#     -v /var/run/docker.sock:/host/var/run/docker.sock \
#     -v /dev:/host/dev \
#     -v /proc:/host/proc:ro \
#     -v /boot:/host/boot:ro \
#     -v /lib/modules:/host/lib/modules:ro \
#     -v /usr:/host/usr:ro \
#     -v /etc:/host/etc:ro \
#     --shm-size=512m \
#     quay.io/sysdig/agent

# touch DONE