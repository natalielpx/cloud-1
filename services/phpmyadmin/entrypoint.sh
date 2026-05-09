#!/bin/sh
set -eu

echo "---------- Running Container Entrypoint Script ----------"

# Setup page
if [ ! -f "/var/www/phpmyadmin/.initialised" ]; then

    echo "----- Initialising phpMyAdmin at /var/www/phpmyadmin..."
    mkdir -p "/var/www/phpmyadmin"
    cp -a "/tmp/phpmyadmin/." "/var/www/phpmyadmin"
    chown -R www-data:www-data "/var/www/phpmyadmin"

	# Mark Initialisation
	touch /var/www/phpmyadmin/.initialised
	
	echo "----- Initialisation Complete"

else
	echo "----- Nothing to do"
fi

echo "---------- End of Container Entrypoint Script ----------"

# ----- Run Passed Command ------------------------------

exec "$@"