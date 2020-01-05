#!/bin/bash

# Install SSM agent to connect instance
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

# Install of nginx
sudo amazon-linux-extras install nginx1.12 -y

sudo systemctl start nginx
sudo systemctl enable nginx

# Download s3 bucket files
cd /usr/share/nginx/html
sudo wget https://flugel-bucket-test.s3-us-west-2.amazonaws.com/test1
sudo wget https://flugel-bucket-test.s3-us-west-2.amazonaws.com/test2