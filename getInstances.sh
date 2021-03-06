#!/bin/bash
BASE_DIR=$(cd $(dirname $0);pwd)
source ${BASE_DIR}/config

AWS_PROFILE=$1

aws ec2 describe-instances --profile ${AWS_PROFILE} --filters "Name=block-device-mapping.status,Values=attached" --out json   \
| jq -r   ".Reservations[].Instances[] | {InstanceId, InstanceName: (.Tags[] | select(.Key==\"Name\").Value)}"  \
| jq -r --slurp   '.[] | .InstanceId + "\t" +  .InstanceName'

