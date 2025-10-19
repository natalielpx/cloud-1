# WORDPRESS

# BASE IMAGE: Debian
FROM debian:bookworm

# WORKING DIRECTORY
WORKDIR /tmp/wordpress

# INSTALL PHP & REQUIRED EXTENSIONS
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install -y --no-install-recommends \
	sudo ca-certificates wget \
	php php-curl php-fpm php8.2-fpm php-gd php-json php-mbstring php-mysql php-xml php-zip && \
	rm -rf /var/lib/apt/lists/*

# INSTALL WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz && \
	tar --strip-components=1 -xvzf latest.tar.gz && \
	rm latest.tar.gz && \
	chown -R www-data:www-data /tmp/wordpress

# INSTALL WP CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# CONFIGURATION
COPY conf/wp-config.php /tmp/wordpress/wp-config.php
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY homepage.html /tmp/homepage.html

# ENTRYPOINT SCRIPT
COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

# ENTRYPOINT
ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
# Run PHP-FPM in the foreground
# -F: force to stay in foreground and ignore daemonize option
