#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo docker run -d -p 3000:3000 --name grafana grafana/grafana
