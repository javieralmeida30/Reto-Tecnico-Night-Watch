#!/bin/bash

DB_HOST="10.0.101.28"
DB_NAME="admin"
DB_USER="admin"
DB_PASS="adminpass"
BUCKET_NAME="BucketName"
REGION="us-east-1"
DATE=$(date +%F)
BACKUP_FILE="/tmp/postgres-backup-$DATE.sql"

export PGPASSWORD="$DB_PASS"

/usr/bin/pg_dump -U "$DB_USER" -h "$DB_HOST" -d "$DB_NAME" > "$BACKUP_FILE"

aws s3 cp "$BACKUP_FILE" "s3://$BUCKET_NAME/backups/postgres-backup-$DATE.sql" --region "$REGION"

echo "Backup from $DATE upload to S3."