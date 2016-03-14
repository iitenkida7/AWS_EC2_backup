#!/bin/bash
source ${BASE_DIR}/config

BASE_DIR=$(cd $(dirname $0);pwd)

AWS_PROFILE=$1

aws ec2 describe-images \
--owners self --filters  "Name=name,Values=${AMI_PREFIX}*" \
--profile ${AWS_PROFILE} \
| jq -r ' .Images[] |.CreationDate  +"\t"+ .ImageId +"\t"+ .Name'
