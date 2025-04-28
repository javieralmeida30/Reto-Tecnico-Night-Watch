#!/bin/bash
set -e

BASTION_IP="18.204.194.30"
PRIVATE_IP="10.0.101.199"
KEY_PATH="~/.ssh/prueba-tecnica.pem"
REMOTE_USER="ec2-user"
DB_USER="admin"
DB_NAME="postgres"

echo "Connecting to Bastion Host $BASTION_IP..."

ssh -i "$KEY_PATH" "$REMOTE_USER@$BASTION_IP" << EOF
set +e

echo "=============================="
echo "Testing TCP connection to PostgreSQL (port 5432)..."
nc -zv $PRIVATE_IP 5432
PG_PORT_STATUS=\$?
echo "PostgreSQL Port Exit Code: \$PG_PORT_STATUS"
echo "=============================="

echo "=============================="
echo "Testing TCP connection to SSH (port 22)..."
nc -zv $PRIVATE_IP 22
SSH_PORT_STATUS=\$?
echo "SSH Port Exit Code: \$SSH_PORT_STATUS"
echo "=============================="

echo "=============================="
echo "Attempting PostgreSQL login using psql..."
PGPASSWORD='adminpass' psql -h $PRIVATE_IP -U $DB_USER -d $DB_NAME -c '\l'
PSQL_STATUS=\$?
echo "PostgreSQL Login Exit Code: \$PSQL_STATUS"
echo "=============================="

echo ""
echo "====== TEST SUMMARY ======"
[[ \$PG_PORT_STATUS -eq 0 ]] && echo "PostgreSQL Port 5432: OPEN" || echo "PostgreSQL Port 5432: CLOSED"
[[ \$SSH_PORT_STATUS -eq 0 ]] && echo "SSH Port 22: OPEN" || echo "SSH Port 22: CLOSED"
[[ \$PSQL_STATUS -eq 0 ]] && echo "PostgreSQL Login: SUCCESS" || echo "PostgreSQL Login: FAILED"
echo "==========================="
EOF

echo "Test finished through Bastion Host $BASTION_IP"
