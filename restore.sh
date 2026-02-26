#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi


if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

args=(
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" 
    run --rm -T
    -e PGPASSWORD="$DB_PASSWORD"
    postgres 
    psql 
    -h "$DB_URL" 
    -U "$DB_USERNAME" 
    -d "$DB_TARGET"
)

echo "Starting restore for database: $DB_TARGET..."

(
    echo "SET session_replication_role = 'replica';"
    cat "$BACKUP_FILE"
    echo "SET session_replication_role = 'origin';"
) | "${args[@]}"

if [ $? -eq 0 ]; then
    echo "Restore completed successfully!"
else
    echo "Error: Restore process failed!"
    exit 1
fi