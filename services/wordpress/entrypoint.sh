#!/bin/sh
set -e # Exit immediately if a command fails

echo "---------- Running Container Entrypoint Script ----------"

# Get password from secrets
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp-admin-password)
: ${DB_NAME:?DB_NAME is unset or null}
: ${DB_USER:?DB_USER is unset or null}
: ${DB_HOST:?DB_HOST is unset or null}
: ${WP_EMAIL:?WP_EMAIL is unset or null}
: ${WP_TITLE:?WP_TITLE is unset or null}
: ${WP_ADMIN:?WP_ADMIN is unset or null}
: ${WP_ADMIN_PASSWORD:?WP_ADMIN_PASSWORD is unset or null}

# Copy db-password into a www-data accessible directory
# mkdir -p /var/www/html/secrets
# cp /run/secrets/db-password /var/www/html/secrets/db-password
# chgrp www-data /var/www/html/secrets/db-password
# chmod 640 /var/www/html/secrets/db-password

# Setup site
if [ ! -f "/var/www/html/.initialised" ]; then

	echo "----- Initialising WordPress at /var/www/html..."
	cp -a "/tmp/wordpress/." "/var/www/html"
	chown -R www-data:www-data "/var/www/html"
	# rm -rf "/tmp/wordpress/"

	echo "----- Installing wp core..."
	wp core install \
		--url="http://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_EMAIL" \
		--allow-root

	echo "----- Deleting all default pages"
	# echo "wp post delete $(wp post list --format=ids --allow-root) --allow-root"
	# echo "wp post delete $(wp post list --post_type='page' --format=ids --allow-root) --allow-root"

	echo "----- Creating page..."
	wp post create \
		--post_type=post \
		--post_title="J’ai passé tellement de temps sur ce projet" \
		--post_content="$(cat /var/www/html/homepage.html)" \
		--post_status=publish \
		--allow-root

	# Mark Initialisation
	touch /var/www/html/.initialised
	
	echo "----- Initialisation Complete"
fi

echo "---------- End of Container Entrypoint Script ----------"

# ----- Run Passed Command ------------------------------
exec "$@"