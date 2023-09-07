#!/bin/bash
# debug with ctr + logs
# sudo ctr -n k8s.io containers list
# sudo cat /var/log/pods/

sudo su -c 'echo $(hostname -i | xargs -n1) $(hostname) >> /etc/hosts'

sudo apt update -y 
sudo apt install apt-transport-https ca-certificates curl software-properties-common jq -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y && sudo apt install containerd.io -y

sudo tee /etc/apt/sources.list.d/kubernetes.list<<EOL
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOL

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update -y

sudo apt install -y kubectl kubelet kubeadm kubernetes-cni
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
# net.ipv6.conf.all.disable_ipv6 = 0
# net.ipv6.conf.default.disable_ipv6 = 0
sudo sysctl --system

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo service containerd restart
sudo service kubelet restart  
# sudo systemctl status containerd
sudo systemctl enable kubelet

sudo kubeadm config images pull
sudo sysctl -p
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --apiserver-advertise-address=0.0.0.0 \
  --cri-socket unix:///run/containerd/containerd.sock
#   --control-plane-endpoint=$(hostname -i | xargs -n1) \

mkdir -p /root/.kube
mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config
sudo chown $(id -u ubuntu):$(id -g ubuntu) /home/ubuntu/.kube/config

kubectl taint nodes --all node.kubernetes.io/not-ready-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# CNI
VERSION=v3.26.1
curl -O https://raw.githubusercontent.com/projectcalico/calico/${VERSION}/manifests/tigera-operator.yaml
curl -O https://raw.githubusercontent.com/projectcalico/calico/${VERSION}/manifests/custom-resources.yaml 
kubectl create -f tigera-operator.yaml
kubectl create -f custom-resources.yaml

# autocomplete https://kubernetes.io/es/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
sudo echo 'source <(kubectl completion bash)' >> ~/.bashrc
sudo echo 'source <(kubectl completion bash)' >> /home/ubuntu/.bashrc
sudo su -c 'kubectl completion bash >/etc/bash_completion.d/kubectl'
sudo echo 'alias k=kubectl' >> ~/.bashrc
sudo echo 'alias k=kubectl' >> /home/ubuntu/.bashrc
sudo echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
sudo echo 'complete -o default -F __start_kubectl k' >> /home/ubuntu/.bashrc
source .bashrc

# deply vuln app
sudo su -c 'cat <<-"EOF" > /home/ubuntu/manifest.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: frontend
  name: frontend
  namespace: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: mateobur/tomcat-front:cyberdyne
          ports:
            - containerPort: 8080
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: frontend
  namespace: frontend
spec:
  selector:
    app: frontend
  type: LoadBalancer
  externalIPs:
  - nodeipnode
  ports:
   - port: 8082
     targetPort: 8080
EOF'

sudo sed -i "s/nodeipnode/$(curl -s http://whatismyip.akamai.com/)/g" /home/ubuntu/manifest.yaml

kubectl create ns frontend
kubectl apply -f /home/ubuntu/manifest.yaml -n frontend

# helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add sysdig https://charts.sysdig.com
helm repo update


touch /home/ubuntu/userdataDONE