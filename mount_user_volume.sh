#!/usr/bin/env bash

USER=$1
docker run -it --rm --mount source=$USER,target=/$USER -w /$USER ubuntu
