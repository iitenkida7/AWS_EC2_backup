# AMI Image baackup Tool
This tool is a tool that you want to back up to get the EC2 of AMI.
This will regularly rotate the AMI.

## Installation

get this tools
```
git clone https://github.com/iiyuda7/AWS_EC2_backup
```

install awscli and jq 
```
pip install awscli --user
yum -y install jq
```
setup awlcli
```
mkdir -p ~/.aws

vi ~/.aws/config


#aws config sample
[profile hoge]
aws_access_key_id =  XXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
region = ap-northeast-1 #tokyo


```
set cron
```
10 2 * * * /file/to/path/autoBackup.sh       @aws_account_profile_name@
10 3 * * * /file/to/path/autoAmiCleaning.sh  @aws_account_profile_name@
```


