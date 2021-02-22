#!bin/bash

curl https://get.docker.com | sh
sudo usermod -a -G docker ubuntu
sudo service docker start

sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install notebook
