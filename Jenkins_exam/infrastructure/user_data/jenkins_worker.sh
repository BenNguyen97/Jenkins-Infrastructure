#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo yum install -y java-17-amazon-corretto

# Tạo thư mục cho Jenkins
mkdir -p ~/jenkins