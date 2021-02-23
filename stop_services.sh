#!/usr/bin/env bash

docker stop $(docker ps -aq)
docker volume rm $(docker volume ls -q)
