sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
# logout and login again

sudo yum install python3.7
sudo pip3 install notebook
