#!/bin/bash
set -e

BASTION_IP="InstancePublicIP"
KEY_PATH="~/.ssh/prueba-tecnica.pem"
REMOTE_USER="ec2-user"
MANIFEST_PATH="./nginx-deployment.yaml" 

echo "Starting deployment on $BASTION_IP..."

echo "Creating manifests folder on the EC2 instance..."
ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" "mkdir -p /home/ec2-user/manifests"

echo "Uploading Nginx deployment manifest..."
scp -i "$KEY_PATH" "$MANIFEST_PATH" "$REMOTE_USER@$BASTION_IP:/home/ec2-user/manifests/"

echo "Deploying Nginx service on Kubernetes..."
ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" << 'EOF'
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f /home/ec2-user/manifests/nginx-deployment.yaml
EOF

echo "Nginx deployment applied on Kubernetes Accessible at http://$BASTION_IP:30080"

echo "#############################################################"

echo "Creating scripts folder on the EC2 instance..."
ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" "mkdir -p /home/ec2-user/scripts"

echo "⬆Uploading backup and log scripts..."
scp -i "$KEY_PATH" ./postgresql_daily_backup.sh "$REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/"
scp -i "$KEY_PATH" ./ec2_logs_to_s3.py "$REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/"

echo "Setting execution permissions for scripts..."
ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" "chmod +x /home/ec2-user/scripts/*.sh /home/ec2-user/scripts/*.py"

echo "Setting up cron jobs for daily backups and log exports..."
ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" << 'EOF'
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/python3 /home/ec2-user/scripts/ec2_logs_to_s3.py >> /home/ec2-user/cron_logs.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * * /home/ec2-user/scripts/postgresql_daily_backup.sh >> /home/ec2-user/cron_pg_backup.log 2>&1") | crontab -
/usr/bin/python3 /home/ec2-user/scripts/ec2_logs_to_s3.py
bash /home/ec2-user/scripts/postgresql_daily_backup.sh
EOF

echo "All scripts deployed and running on $BASTION_IP"
echo "Access Nginx at: http://$BASTION_IP:30080/"
