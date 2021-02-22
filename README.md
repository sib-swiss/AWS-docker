# AWS-docker

Scripts to employ multiple docker containers simultaneously for teaching. 

## Preparation

Install docker on AWS (e.g. on an ubuntu image):

```sh
curl https://get.docker.com | sh
sudo usermod -a -G docker ubuntu
sudo service docker start
```

You can add the above code to the code run at initialisation. Otherwise, logout and login again to be able use `docker` without `sudo`. 

Also install python3, pip and notebook:

```sh
sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install notebook
```

Clone this repository:

```sh
git clone https://github.com/GeertvanGeest/AWS-docker.git
```

## Deploying containers

Prepare a tab-delimited user list with three columns: port, username and password. E.g.:

```
10001	user01	pwusera
10002	user02	pwuserb
```

Prepare an iamge that you want to use for the course. This image should be based on a jupyter notebook container, e.g. [jupyter/base-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-base-notebook), and should be availabe from `dockerhub`. 

Run the script `run_jupyter_notebooks`:

```sh
run_jupyter_notebooks \
-i jupyter/base-notebook \
-u examples/user_list_test.txt \
-p test1234
```

The admin container (i.e. with sudo rights) is available from port 10000. The regular users at the ports specified in the tab-delimited text file. 
