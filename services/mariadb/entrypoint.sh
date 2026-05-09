#!/bin/sh

echo "---------- Running Container Entrypoint Script ----------"

# ----- Check Variables ------------------------------
# Obtain and check valid env variables
DB_PASSWORD=$(cat /run/secrets/db-password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db-root-password)
: ${DB_NAME:?DB_NAME is unset or null}
: ${DB_USER:?DB_USER is unset or null}
: ${DB_HOST:?DB_HOST is unset or null}
: ${DB_PASSWORD:?DB_PASSWORD is unset or null}
: ${DB_ROOT_PASSWORD:?DB_ROOT_PASSWORD is unset or null}

# ----- Prepare Runtime Directories ------------------------------
# Create needed directories and setup permissions to store mysqld.sock
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod 700 /run/mysqld /var/lib/mysql

# ----- MariaDB Users Clarification ------------------------------
# root(MariaDB): Superuser for administration
# mysql(system user): OS-level user that runs the mysql process for file onwership and process permissions
# DB_USER: Application-level user that Wordpress connects as

# ----- Initialise Database If Empty ------------------------------
if [ ! -f "/var/lib/mysql/.initialised" ]; then

	# Initialise MariaDB
	echo "----- Initialising MariaDB..."
	mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

	# Start MariaDB
	echo "----- Starting MariaDB..."
	mariadbd-safe --user=mysql --basedir=/usr --datadir=/var/lib/mysql &
	until mariadb-admin ping --silent
	do
		echo "----- Waiting..."
		sleep 1
	done
	echo "----- MariaDB alive"

	# Run SQL using env vars
	echo "----- Creating Database and User(s)..."
	mariadb -u root <<-EOSQL

		-- Create a Database
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

		-- Create a User(s) (With Remote & Local Access)
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';

		-- Grant Privileges to User(s)
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';

		-- Required Password for root
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

		-- Apply Changes
		FLUSH PRIVILEGES;

	EOSQL
	echo "----- Database and User(s) Created"

	# Shut Down MariaDB
	echo "----- Shutting Down MariaDB..."
	mariadb-admin -u root --password="$DB_ROOT_PASSWORD" shutdown
	wait

	# Mark Initialisation
	touch /var/lib/mysql/.initialised
	
	echo "----- Initialisation Complete"

fi

echo "---------- End of Container Entrypoint Script ----------"

# ----- Run Passed Command ------------------------------
exec "$@"