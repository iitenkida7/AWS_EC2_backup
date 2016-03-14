#!/bin/bash

AWS_PROFILE=$1
BASE_DIR=$(cd $(dirname $0);pwd)

source ${BASE_DIR}/config
AGO=$(date -u -d "${N_DAY} day ago" '+%s')

LIST=$(${BASE_DIR}/getAmiBackupList.sh ${AWS_PROFILE})

IFS=$'\n'
for ITEM in ${LIST} ; do 

  AMI_CLEATE_DATE=$(echo ${ITEM} | awk '{print $1}' |  sed -e "s%T% %g" -e "s%\..*%%g")
  AMI_ID=$(echo ${ITEM} | awk '{print $2}')
  AMI_AMI_DESCRIPTION=$(echo ${ITEM} | awk '{print $3}')

  if [ $(date -u -d  "${AMI_CLEATE_DATE}" '+%s')  -lt ${AGO} ] ; then
      # AMI 登録解除
      aws ec2 deregister-image --image-id ${AMI_ID} --profile ${AWS_PROFILE} --out json
      # AMIに紐づくsnapshotを捕捉
      SNAPSHOTS=$(aws ec2 describe-snapshots --filters "Name=description,Values=Created by CreateImage*${AMI_ID}*" --profile ${AWS_PROFILE} | jq -r '.Snapshots[].SnapshotId')
      for SNAPSHOT in ${SNAPSHOTS} ; do
        # AMI に紐づくsnapshotを削除
        echo -e "Delete:\t${AMI_ID}\t${SNAPSHOT}\t${AMI_AMI_DESCRIPTION}"
        if [ "_${?}" == "_0" ] ; then
          aws ec2 delete-snapshot --snapshot-id ${SNAPSHOT} --profile ${AWS_PROFILE}
        fi
      done
      
  fi

done
