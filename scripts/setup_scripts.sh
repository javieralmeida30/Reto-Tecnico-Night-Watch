#!/bin/bash

BASTION_IP="Public_IP"
KEY_PATH="~/.ssh/prueba-tecnica.pem"
REMOTE_USER="ec2-user"

ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" "mkdir -p /home/ec2-user/scripts"

scp -i "$KEY_PATH" ./postgresql_daily_backup.sh "$REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/"
scp -i "$KEY_PATH" ./ec2_logs_to_s3.py "$REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/"

ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" "chmod +x /home/ec2-user/scripts/*.sh /home/ec2-user/scripts/*.py"

ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" << 'EOF'
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/python3 /home/ec2-user/scripts/ec2_logs_to_s3.py >> /home/ec2-user/cron_logs.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * * /home/ec2-user/scripts/postgresql_daily_backup.sh >> /home/ec2-user/cron_pg_backup.log 2>&1") | crontab -
EOF

ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" << 'EOF'
/usr/bin/python3 /home/ec2-user/scripts/ec2_logs_to_s3.py
bash /home/ec2-user/scripts/postgresql_daily_backup.sh
EOF

echo "Scripts working on $BASTION_IP"
