#!/bin/bash

BASE_DIR=$(cd $(dirname $0);pwd)

source ${BASE_DIR}/config

AWS_PROFILE=$1
AWS_INSTANCEID=$2
AWS_AMI_TAGNAME=$3

BACKUP_TIMESTAMP=$(date +"%Y%m%d-%H%M")

# Tag:Name から文字列を抽出（マルチバイト＆記号は除外） 
AWS_AMI_DESCRIPTION=$(echo ${AWS_AMI_TAGNAME} | sed "s%[^a-zA-Z0-9]%%g" | cut -b-50 )
if [ "_${AWS_AMI_DESCRIPTION}" == "_" ] ; then 
  AWS_AMI_DESCRIPTION=${AWS_INSTANCEID}
fi

#run
aws  ec2 create-image --instance-id ${AWS_INSTANCEID} \
--name "${AMI_PREFIX}_${AWS_INSTANCEID}_${BACKUP_TIMESTAMP}" \
--description "${AWS_AMI_DESCRIPTION}" \
--no-reboot \
--out json \
--profile ${AWS_PROFILE} >/dev/null 2>&1
if [ "_${?}" != "_0" ] ; then

	echo -e "failed:\t${AMI_PREFIX}_${AWS_INSTANCEID}_${BACKUP_TIMESTAMP}\t${AWS_AMI_DESCRIPTION}"
	exit 1
fi

echo -e "success:\t${AMI_PREFIX}_${AWS_INSTANCEID}_${BACKUP_TIMESTAMP}\t${AWS_AMI_DESCRIPTION}"
