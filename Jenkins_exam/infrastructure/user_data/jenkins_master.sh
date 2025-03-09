#!/bin/bash
# Cập nhật hệ thống
sudo yum update -y

# Cài đặt Docker
sudo amazon-linux-extras enable docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Cài đặt Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform

# Tạo thư mục cho Jenkins
mkdir -p ~/jenkins-master && cd ~/jenkins-master

# Tạo file docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-master
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
    environment:
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false
      - JENKINS_USER=admin
      - JENKINS_PASS=admin
      - JENKINS_PLUGINS=github,github-pullrequest,pipeline-github,pipeline-model-definition,pipeline-stage-view,ssh-slaves,ssh-build-agents,configuration-as-code,credentials,workflow-support
    networks:
      - jenkins_network

volumes:
  jenkins_home:

networks:
  jenkins_network:
    driver: bridge
EOF

# Chạy Jenkins bằng Docker Compose
docker-compose up -d

