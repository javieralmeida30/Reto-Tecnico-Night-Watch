#!/bin/bash
yum update -y
yum install -y docker python3 cronie
systemctl enable crond
systemctl start crond
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

sleep 5
docker volume create grafana-storage
docker run -d \
  --name grafana \
  -p 3000:3000 \
  --restart always \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana

yum install -y python3-pip
/usr/bin/pip3 install boto3
dnf install -y postgresql15
