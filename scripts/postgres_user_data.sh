#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

sudo docker volume create postgres-data
sudo docker run -d \
  --name postgres \
  --restart always \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=adminpass \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  postgres
