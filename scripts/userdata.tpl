#!/bin/bash
sudo apt update -y

# (if we want, at this step is where we need to setup the ec2 hosts as k8s nodes)

#setup machine with docker + compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

#install jupyter (vuln app), maybe change later with log4j in a k8s cluster
DIR=/home/admin/jupyter
mkdir $DIR
wget https://raw.githubusercontent.com/vulhub/vulhub/master/jupyter/notebook-rce/docker-compose.yml -P $DIR
docker compose -f $DIR/docker-compose.yml up -d

touch DONE