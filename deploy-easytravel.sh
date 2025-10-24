#!/bin/bash

# easyTravel Deployment Script for Amazon Linux 2
set -e

echo "=== Installing Docker ==="
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

echo "=== Installing Docker Compose ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Cloning easyTravel Repository ==="
git clone https://github.com/Dynatrace/easyTravel-Docker.git
cd easyTravel-Docker

echo "=== Starting easyTravel Application ==="
docker-compose up -d

echo "=== Deployment Complete ==="
echo "Application will be available at:"
echo "- Main Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):80"
echo "- Angular Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9079"
echo "- Backend API: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"

echo "=== Checking Container Status ==="
docker-compose ps
