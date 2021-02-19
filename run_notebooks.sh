#!/usr/bin/env bash

USERLIST=$1
MASTERPW=$2

# create volume that will be populated with read-only data
docker volume create data

cat $USERLIST | tr -d '\015\040' | while read port user password
do
  echo $port
  echo $user
  echo $password

  HASH=`./generate_pw_hash.py -p $password`

  docker volume create $user

  docker run -d \
  --mount source=$user,target=/home/jovyan \
  --mount source=data,target=/home/jovyan/data,readonly \
  -p $port:8888 \
  jupyter/base-notebook \
  start-notebook.sh \
  --NotebookApp.password=$HASH
done

# generate has for master password
HASH=`./generate_pw_hash.py -p $MASTERPW`

# generate master container 
docker run -d \
--mount source=data,target=/home/jovyan/data \
-p 10000:8888 \
jupyter/base-notebook \
start-notebook.sh \
--NotebookApp.password=$HASH
