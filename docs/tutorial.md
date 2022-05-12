
In this tutorial we will go through the following steps: 

- start up an EC2 instance
- generate credentials 
- deploying containers running Rstudio server. 

The tutorial assumes that you already have an AWS account. If you haven't got one, make one [here](https://portal.aws.amazon.com/billing/signup#/start/email). 

## Start up an EC2 instance

Let's start with a small EC2 instance with the following characteristics:

- Type `t2.micro` (free small instance)
- Running Ubuntu
- 30Gb of disk space
- Accessible through ports 22 (ssh) and 9000-9050 (web access)

Do this by navigating to the EC2 console, and press the orange button **Launch instances**. Choose a ubuntu image running on `t2.micro`. At **Key pair** select the key pair you want to use (if you already have create one), or generate a new key. If you generate a new key, choose the default settings. It will automatically download the .pem file. After you have downloaded the key file, store it into a secure place, and change the permissions to `400` (if on Linux/Mac):

```sh
chmod 400 mykey.pem
```

Add a security group rule by expanding **Network settings** and clicking **Add security group rule**. At **port range** specify `9000-9050`, and at **source** `0.0.0.0/0` (meaning the ports can be approached from anywhere). At **Configure storage** specify 30 Gb of gp2 storage as Root volume. To launch the instance, now click **Launch instance**. 

## Login to the instance and install docker

To login to the instance, first find the public IPv4 address. To find this IP, go to the EC2 console, select your running instance, and find it at the tab *Details*. Now that you know your IP, open your local terminal and cd into the directory where you have stored your key file (.pem). After that, use ssh to logon onto the instance:

```sh
ssh -i mykey.pem ubuntu@[public IP address]
```

Now that we have logged on to our instance, we can install Docker. Do this by running the following commands:

```sh
curl https://get.docker.com | sh
sudo usermod -a -G docker ubuntu # ubuntu is the user with root access
sudo service docker start
```

Now logout and login again in order to be able to use docker without `sudo`. 

## Generate credentials

Now, clone this repository into your home directory on the instance (`/home/ubuntu`):

```sh
git clone https://github.com/sib-swiss/AWS-docker.git
```

First, we generate some credentials (link + password). We have prepared a tab delimited file with user information to test inside the repository at `examples/user_list_credentials.txt`. It's just tab-delimited file with first names and last names:

```
Jan     de Wandelaar
Piet    Kopstoot
Joop    Zoetemelk
```

Now that we have the user list ready we can generate the credentials with the script `generate_credentials`:

```sh
cd ~/AWS-docker
# [public IP address] is the public IPv4 address of your instance
./generate_credentials \
-l examples/user_list_credentials.txt \
-o credentials \
-p 9001 \
-a [public IP address]
```

The option `-o` specifies an output directory in which the following files are created:

* `input_docker_start.txt`: A file that serves as input to deploy the docker containers on the server
* `user_info.txt`: A file with user names, passwords and links that can be used to communicate credentials to the participants

The option `-p` is used to generate an individual port for each user. Ports will be assigned in an increasing number from `-p` to each user. So, in the example above, the first user gets port 9001, the second 9002, the third 9003, etc. **Be aware that port 9000 and 10000 are reserved for the admin containers!**

The option `-a` specifies the address on which the container will be hosted. This is used to generate the address per user. 

## Start an Rstudio container

Now that we have created credentials, we can start up three containers for the three users that we originally had in our user list. We will start up an rstudio container with the script `run_rstudio_server`. 

```sh
./run_rstudio_server \
-i rocker/rstudio \
-u ./credentials/input_docker_start.txt \
-p adminpassword \
-m 1g
-c 1
```

Here, we provide the image name at `-i`. This can be any image that is based on a `rocker/rstudio` image and hosted on docker hub. At `-u` we provide the credential information that we generated in the previous step. At `-p` we specify a password that is used to login to the admin container. At `-m` the memory limit, and `-c` the cpu limit (1GB with 1 CPU because that's what we have available at our small instance). 

This will start up the containers and volumes. Participants can access the containers with the link and password provided in `credentials/user_info.txt`. The admin container is available at port 9000. 

## Stopping containers

In order to stop all containers you can run:

```sh
docker stop $(docker ps -aq)
```

After stopping the containers, you can safely stop your instance (by using the EC2 console). With stopping the instance, you can keep your instance state, but you won't be charged for the instance (only for the disk space). 

In order to stop, remove all containers and volumes you can the `stop_services.sh` script in the `scripts` directory:

```sh
cd ~/AWS-docker/scripts
./stop_services.sh
```

At the end of your class/tutorial, don't forget to terminate the instance! Do this by navigating to the EC2 console. Select the instance, and click **Instance state** > **Terminate instance**. 
