#!/usr/bin/env bash
./AWS-docker/backup_s3.sh -u AWS-docker/credentials_rstudio/input_docker_start.txt -s single-cell-summerschool -e general
STATUS=$?
date >> /home/ubuntu/cronbackup.log
echo "Exit status: $STATUS" >> cronbackup.log
