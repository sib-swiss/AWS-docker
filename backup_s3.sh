#!/usr/bin/env bash

USAGE="Usage: run_rstudio_server -i <image> -u <user list> -p <admin password>\n
\n
Creates a backup of group_work volume and user volumes in S3\n
\n
-u user list. Tab delimited list of users with three columns: port, user name, password\n
-s S3 bucket.\n
-e EC2 server name.\n
"

while getopts ":u:s:e:" opt
do
  case $opt in
    u)
      USERLIST=$OPTARG
      ;;
    s)
      S3BUCKET=$OPTARG
      ;;
    e)
      SERVERNAME=$OPTARG
      ;;
  esac
done

# return usage if no options are passed
if [ $OPTIND -eq 1 ]
then
  echo -e "No options were passed. \n" >&2
  echo -e $USAGE >&2
  exit 1
fi

# required options
if [ "$USERLIST" == "" ]; then echo "option -u is missing, but required">&2 && exit 1; fi
if [ "$SERVERNAME" == "" ]; then echo "option -e is missing, but required">&2 && exit 1; fi
if [ "$S3BUCKET" == "" ]; then echo "option -s is missing, but required">&2 && exit 1; fi

# S3BUCKET=single-cell-transcriptomics
# SERVERNAME=general
# USERLIST=small_userlist.txt

docker run \
--rm \
-ti \
-v ~/.aws:/root/.aws \
--mount source=group,target=/group_work,readonly \
amazon/aws-cli \
s3 sync --delete \
/group_work \
s3://$S3BUCKET/$SERVERNAME/group_work

cat $USERLIST | tr -d '\015\040' | while read port user password
do
    docker run \
    --rm \
    -v ~/.aws:/root/.aws \
    --mount source=$user,target=/root/$user,readonly \
    amazon/aws-cli \
    s3 sync --delete \
    /root/$user/ \
    s3://$S3BUCKET/$SERVERNAME/users/$user
done