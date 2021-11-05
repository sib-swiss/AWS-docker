#!/usr/bin/env bash

cd /home/ubuntu
AWS-docker/backup_s3 \
-u credentials_jupyter/input_docker_start.txt \
-s ngs-introduction-training \
-e 20211103-NGS6 \
2>> cronjob.err
 
 
