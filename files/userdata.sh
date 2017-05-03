#!/bin/bash
# Inspired by https://raw.githubusercontent.com/technekes/docker-awscli/master/Dockerfile
# TODO Move this installation process out to the project Docker file
TEMP_DIR="$(mktemp -d)"
AWS_CLI_BUNDLE="awscli-bundle.zip"

apk add --update groff less python
rm /var/cache/apk/*

cd $TEMP_DIR
wget "s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O $AWS_CLI_BUNDLE
unzip $AWS_CLI_BUNDLE
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin

cd /
rm -rf $TEMP_DIR

aws s3 cp s3://${bucket}/${key} /etc/ecs/ecs.config --region=${region}
