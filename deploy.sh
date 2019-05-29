#!/bin/bash
set -e

ACCOUNT_NUMBER=<ACCOUNT NUMBER HERE!!!>

STACK_NAME="Fargate-Play"
REGION="ap-southeast-2"
S3_CLOUDFORMATION_BUCKET="mc-cloudformation-templates"

mkdir -p packaged

if aws s3api head-bucket --bucket $S3_CLOUDFORMATION_BUCKET 2>/dev/null; then
    echo "$S3_CLOUDFORMATION_BUCKET bucket creation skipped"
else
    aws s3 mb s3://$S3_CLOUDFORMATION_BUCKET
fi

npm i

aws cloudformation package \
    --template-file ./Application.yml \
    --s3-bucket $S3_CLOUDFORMATION_BUCKET \
    --output-template-file ./packaged/Application.yml

aws cloudformation deploy \
    --template-file ./packaged/Application.yml \
    --stack-name $STACK_NAME \
    --capabilities CAPABILITY_IAM \