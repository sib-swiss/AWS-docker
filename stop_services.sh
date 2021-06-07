#!/usr/bin/env bash

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
sleep 5
docker volume rm $(docker volume ls -q)
