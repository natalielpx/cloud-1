#!/bin/sh
set -e # Exit immediately if a command fails

echo "---------- Running Container Entrypoint Script ----------"

DB_ROOT_PASSWORD=$(cat /run/secrets/db-root-password)
DB_PASSWORD=$(cat /run/secrets/db-password)

# ----- Prepare Runtime Directories ------------------------------
# Create needed directories and setup permissions to store mysqld.sock
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod 755 /run/mysqld /var/lib/mysql

# ----- Initialise Database If Empty ------------------------------
if [ ! -f "/var/lib/mysql/.mariadb_initialised" ]; then

	# Initialise MariaDB
	echo "Initialising MariaDB..."
	mariadb-install-db --datadir=/var/lib/mysql --user=mysql

	# Start MariaDB
	echo "Starting MariaDB..."
	mysqld_safe --datadir=/var/lib/mysql &
	until mysqladmin ping --silent; do sleep 1; done

	# Run SQL using env vars
	mysql -u root --password="$DB_ROOT_PASSWORD" <<-EOSQL
		-- Create a Database
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

		-- Create a User(s) (With Remote & Local Access)
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';

		-- Grant Privileges to User(s)
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';

		-- Require Password for root
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';

		-- Apply Changes
		FLUSH PRIVILEGES;
	EOSQL

	# Shut Down MariaDB
	echo "Shutting Down MariaDB..."
	mysqladmin -u root --password="$DB_ROOT_PASSWORD" shutdown

	# Mark Initialisation
	touch /var/lib/mysql/.mariadb_initialised
	echo "Initialisation Complete"
fi

unset DB_ROOT_PASSWORD
unset DB_PASSWORD

echo "---------- End of Container Entrypoint Script ----------"

# ----- Run Passed Command ------------------------------
exec "$@"