#!bin/bash

curl https://get.docker.com | sh
sudo usermod -a -G docker ubuntu
sudo service docker start

# only for jupyter notebooks:
sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install notebook # not needed anymore?
pip3 install jupyter_server

git clone https://github.com/GeertvanGeest/AWS-docker.git

# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout notebook.key -out notebook.pem
