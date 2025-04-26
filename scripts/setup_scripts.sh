#!/bin/bash

# Variables
BASTION_IP="Public_IP"
KEY_PATH="~/.ssh/prueba-tecnica.pem"
REMOTE_USER="ec2-user"

# Subir los scripts
scp -i $KEY_PATH ./scripts/postgresql_daily_backup.sh $REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/
scp -i $KEY_PATH ./scripts/upload_logs.py $REMOTE_USER@$BASTION_IP:/home/ec2-user/scripts/

# Dar permisos de ejecución
ssh -i $KEY_PATH $REMOTE_USER@$BASTION_IP "chmod +x /home/ec2-user/scripts/*.sh"

# Configurar el crontab
ssh -i $KEY_PATH $REMOTE_USER@$BASTION_IP << 'EOF'
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/python3 /home/ec2-user/scripts/upload_logs.py >> /home/ec2-user/cron_logs.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * * /home/ec2-user/scripts/postgresql_daily_backup.sh >> /home/ec2-user/cron_pg_backup.log 2>&1") | crontab -
EOF

echo "Scripts working on $BASTION_IP"
