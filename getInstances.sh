#!/bin/bash

AWS_PROFILE=$1

aws ec2 describe-instances --profile ${AWS_PROFILE} --out json   \
| jq -r   ".Reservations[].Instances[] | {InstanceId, InstanceName: (.Tags[] | select(.Key==\"Name\").Value)}"  \
| jq -r --slurp   '.[] | .InstanceId + "\t" +  .InstanceName'

