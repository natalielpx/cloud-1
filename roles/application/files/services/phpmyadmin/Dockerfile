# PHPMYADMIN

# BASE IMAGE: Debian
FROM debian:bookworm

# WORKING DIRECTORY
WORKDIR /tmp/phpmyadmin
# Files are put and installed in /tmp/ to prevent being overwritten by volume mount

# INSTALL PHP & REQUIRED EXTENSIONS
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    wget ca-certificates gnupg \
    php8.2-fpm php8.2-mbstring php8.2-zip php8.2-gd php8.2-mysql php8.2-xml && \
    rm -rf /var/lib/apt/lists/*

# INSTALL PHP MYADMIN
# https://phoenixnap.com/kb/how-to-install-phpmyadmin-on-debian
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz && \
    # import keyring
    wget https://files.phpmyadmin.net/phpmyadmin.keyring && \
    gpg --import phpmyadmin.keyring && \
    # verify GPG key
    wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz.asc && \
    gpg --verify phpMyAdmin-latest-english.tar.gz.asc && \
    # unpack
    tar --strip-components=1 -xvf phpMyAdmin-latest-english.tar.gz &&\
    rm phpMyAdmin-latest-english.tar.gz phpmyadmin.keyring phpMyAdmin-latest-english.tar.gz.asc && \
    # change ownership
    chown -R www-data:www-data /tmp/phpmyadmin

# CONFIGURATION
COPY conf/config.inc.php /tmp/phpmyadmin/config.inc.php
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# ENTRYPOINT SCRIPT
COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

# ENTRYPOINT
ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]
CMD ["php-fpm8.2", "-F", "-R"]
