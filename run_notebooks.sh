#!/usr/bin/env bash

IMAGE=geertvangeest/ngs-longreads:v1
USERLIST=$1
MASTERPW=$2

# create general volume that will be populated with read-only data
docker volume create data
# create general volume for group work
docker volume create group

# remove carriage returns and spaces and pipe to while loop
cat $USERLIST | tr -d '\015\040' | while read port user password
do
  # generate hash from password
  HASH=`python3 ./generate_pw_hash.py -p $password`

  # create user volume. If the container crashes the volume keeps existing.
  docker volume create $user

  # generate container for each user
  # mount user volume, data volume (general, read only) and group work volume (general, read and write)
  # the permissions of general volumes (data and group work) need to be changed with the master container (this can probably be coded as well)
  # the --user, -e and -w commands are needed to change the user
  docker run \
  -d \
  --rm \
  --name $user \
  --mount source=$user,target=/home/jovyan \
  --mount source=data,target=/data,readonly \
  --mount source=group,target=/group_work \
  -p $port:8888 \
  $IMAGE \
  start-notebook.sh \
  --NotebookApp.password=$HASH
done

# generate hash for master password
HASH=`python3 ./generate_pw_hash.py -p $MASTERPW`

# generate admin container
# the option -e GRANT_SUDO=yes is required to e.g. change permissions in the root directory
docker run \
--rm \
-d \
--name admin \
--mount source=data,target=/home/jovyan/data \
--mount source=group,target=/home/jovyan/group_work \
--user root \
-e GRANT_SUDO=yes \
-p 10000:8888 \
$IMAGE \
start-notebook.sh \
--NotebookApp.password=$HASH

# stop all containers:
# docker stop $(docker ps -aq)
# remove all volumes:
# docker volume rm $(docker volume ls -q)
