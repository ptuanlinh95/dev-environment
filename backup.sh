#!/bin/bash

generate_backup_filename() {
    local db_name=$1
    local timestamp=$(date +"%H%M_%d%m%Y")
    echo "${db_name}_backup_${timestamp}.sql"
}

ENV_FILE="./.env"

if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

mkdir -p backups

FILE_NAME=$(generate_backup_filename "$DB_TARGET")
FULL_PATH="backups/$FILE_NAME"

args=(
    docker compose -f "docker-compose.yml"
    run --rm
    -e PGPASSWORD="$DB_PASSWORD"
    postgres
    pg_dump
    -h "$DB_URL"
    -U "$DB_USERNAME"
    -a
    --column-inserts
    -T "databasechangelog*"
    "$DB_TARGET"
)

echo "Starting backup for database: $DB_TARGET"

if "${args[@]}" > "$FULL_PATH"; then
    echo "Backup completed successfully!"
    echo "Location: $FULL_PATH"
else
    echo "Error: Backup process failed!"
    exit 1
fi