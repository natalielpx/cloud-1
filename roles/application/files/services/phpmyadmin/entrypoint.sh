#!/bin/sh
set -e # Exit immediately if a command fails

echo "---------- Running Container Entrypoint Script ----------"

ROOT="/var/www/phpmyadmin"
CONFIG_DIR="/etc/phpmyadmin"
SECRET_FILE="$ROOT/blowfish-secret.txt"

# Copy db-password into a www-data accessible directory
mkdir -p "$ROOT/secrets"
cp /run/secrets/db-password "$ROOT/secrets/db-password"
chgrp www-data "$ROOT/secrets/db-password"
chown 640 "$ROOT/secrets/db-password"

# Setup page
if [ ! -f "$CONFIG_DIR/config.inc.php" ]; then
    echo "Initialising phpMyAdmin at $ROOT..."
    mkdir -p "$ROOT"
    mkdir -p "$CONFIG_DIR"
    cp -a "/tmp/phpmyadmin/." "$ROOT"
    chown -R www-data:www-data "$ROOT"
fi

# Create Blowfish Secret
if [ ! -f "$SECRET_FILE" ]; then
    openssl rand -base64 32 > "$SECRET_FILE"
    chmod 600 "$SECRET_FILE"
    chown www-data:www-data "$SECRET_FILE"
    echo "Blowfish secret created."
else
    echo "Blowfish secret already exists."
fi

echo "---------- End of Container Entrypoint Script ----------"

# ----- Run Passed Command ------------------------------

exec "$@"
