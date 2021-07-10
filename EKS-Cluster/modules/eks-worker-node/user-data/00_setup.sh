#!/bin/bash

echo 'Sleeping for 30 seconds to give the AMIs enough time to initialize (otherwise, packages may fail to install).'
sleep 30
echo 'Installing AWS CLI'
sudo yum update -y && sudo yum install -y aws-cli unzip jq