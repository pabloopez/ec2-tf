#!/bin/bash
# debug with ctr + logs
# sudo ctr -n k8s.io containers list
# sudo cat /var/log/pods/

set -euxo pipefail

sudo su -c 'echo $(hostname -i | xargs -n1) $(hostname) >> /etc/hosts'

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update -y

sudo tee /etc/apt/sources.list.d/kubernetes.list<<EOL
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOL

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common jq python3-pip nmap kubectl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y && sudo apt install containerd.io -y

pip uninstall awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip &> /dev/null
./aws/install &> /dev/null
hash  -r
rm -rf /root/awscliv2.zip /root/aws


mkdir -p /root/resources

cat << EOF > /root/resources/aws_creds.json
{ "Code" : "Success", "LastUpdated" : "2023-09-15T06:56:32Z", "Type" : "AWS-HMAC", "AccessKeyId" : "ASIA3VS7F4K3DDGDH6I3", "SecretAccessKey" : "pcIkQ3D0j2o6y+f4k3yenWj4/Ve+mKF4k3/79t3D", "Token" : "IQoJb3f4k3luX2VjEG8aCXVzLWVhc3QtMSJIMEYCIQClKANop4jZmV1YFM/0ckoSnmzAOg5GOGQ0HxV8tpl0iQIhAOWajImP8zSvkxH7Fz0ZcrPoKEg43dtAMK+osIBEjBH1KrwFCFgQABoMODAyMjg1MTM5OTE4Igw5Ixq88O6nL4ziEmIqmQWWAg8yHu3MHM41T3ytfmazA4s6410gM9vzKxOTU6yfXSlLP+pAg5w+031eVHRLPW0SyU0qf4k3ITW7JtJVB3K9hQQKTidv29sAuX7M5+n/4qpizdHs9a838uCyoJWVqTzKinWE9c0SYtGEd0mXGZxtbWbIkX2C4WAwfUeYLF2eXoAv/ciYr43yiCC3Tk8icAXfUvF/QOJRo1iPnXnt8Cfw0IkcXUvaCW6WojWC6OlWTFJhoXtlTTmp1bWyVnIj/wxUcbmYkh5sz4V9a6V7hvwNCpFpzbHwNwi2QmcJ9gG1mf+i1HIEeNp2at0LRnovGYRk59YLMPIxwAt53W8m8omkk7qmFbN98t9hUQLLS5xDa1gJrPzEW6bO5NWjZQU1fNybtqov95OfQP/J8rYQ1BxZa/R2FIoK1/iLIZ4LQ1Xm+ItanO//eZg+ieg9K+vU26jXZoTnd6h5IwvxQERQ79BDXGKrg92MrK/DzSmkUWyiGnF2/Z5DLZWlwA8wAdvpnTKPCo48SnoOLqvBhoiYsm2SOVC4vTL+5HwynxP7a3+hXseqO8kKOi/ZEjH8kYNOgYZMDairI2kPXxbGVGgqkXDH8h5WlxN3DSz/6wb/X3D4xj49y9IfrLu5EilvuNagqXnU6a7YEAvta4NW4SpVjIZnUyKeQ8MDkg00gJQehfZr4F+m54XAgkURAAnuU/eolYE16WBx3zqiYKCTyfZe0NZl8nxxOSn/iWQAKBPr5JRTfhXGeoQqAK+CLuiuYvwm/RFNxuBH+Do7E//DvvefcII6FTE/JcTVok3/gYwzzTLlgl3xV4CXNQV6KHuaKZBvuzTO0Xe88DTFq55zTlBMDWiTM1X2Mp8SyU9EU7xlmfXfm1m/f/qZijCNgJCoBjqwATmFruKxvdVaXf4k34Q49sYIJJrZk6AYBHqvH3zv7oKkv/OCQetqCqdh4qk7ZtQQEMeKsA7XDTYlMg6BdSQ4TWU2HrhDj4gxmwdXdUs5yt8hK8VxCVg0u9gEIaL8Ghm8caIzYZHOMrj2Hv3y81T2ytH3OQ3C6sLFoCAK9XVeuqyj4D3Z1/nE31lbmowxBPRgCUuc/u39NQuAMjsO+a8NVriYEnWmk/3Kw6PnG/6YwQOj", "Expiration" : "2023-09-15T13:31:13Z" }
EOF

# setup rootkit for the exploit
git clone https://github.com/craig/SpringCore0day.git
cd SpringCore0day
pip3 install requests

# install pacu
git clone https://github.com/RhinoSecurityLabs/pacu.git
cd pacu && pip3 install -r requirements.txt

pip3 install -U chalice
pip3 install pyopenssl --upgrade
pip3 install -U pacu