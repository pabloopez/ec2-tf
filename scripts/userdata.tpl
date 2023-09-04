#!/bin/bash
# sudo apt -y update && sudo apt -y upgrade 
# (if we want, at this step is where we need to setup the ec2 hosts as k8s nodes)

#setup machine with docker + compose
# cd /home/admin/
# curl -fsSL https://get.docker.com -o get-docker.sh
# chmod +x ./get-docker.sh
# sudo sh ./get-docker.sh
# sudo usermod -aG docker $USER
# newgrp docker

#install jupyter (vuln app), maybe change later with log4j in a k8s cluster
# DIR=/home/admin/jupyter
# mkdir $DIR
# wget https://raw.githubusercontent.com/vulhub/vulhub/master/jupyter/notebook-rce/docker-compose.yml -P $DIR
# docker compose -f $DIR/docker-compose.yml up -d


# agent
# sudo docker run -d --name sysdig-agent --restart always --privileged --net host --pid host \
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

touch DONE