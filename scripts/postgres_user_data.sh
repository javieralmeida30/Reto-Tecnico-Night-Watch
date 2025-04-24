#!/bin/bash
yum update -y
yum install -y docker
service docker start
systemctl enable docker
usermod -aG docker ec2-user

docker volume create postgres-data
docker run -d \
  --name postgres \
  --restart always \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=adminpass \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  postgres
