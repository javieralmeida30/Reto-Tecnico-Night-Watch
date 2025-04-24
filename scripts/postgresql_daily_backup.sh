#!/bin/bash

DB_HOST="10.0.101.199"
DB_NAME="admin"
DB_USER="admin"
DB_PASS="adminpass"
BUCKET_NAME="nightwatch-logs-backups-538d89e6"
REGION="us-east-1"
DATE=$(date +%F)
BACKUP_FILE="/tmp/postgres-backup-$DATE.sql"

export PGPASSWORD="$DB_PASS"

/usr/bin/pg_dump -U "$DB_USER" -h "$DB_HOST" -d "$DB_NAME" > "$BACKUP_FILE"

aws s3 cp "$BACKUP_FILE" "s3://$BUCKET_NAME/backups/postgres-backup-$DATE.sql" --region "$REGION"

echo "Backup from $DATE upload to S3."
#crontab example 0 3 * * * /home/ec2-user/scripts/postgresql_daily_backup.sh >> /home/ec2-user/pg_backup.log 2>&1 run 3 am every day