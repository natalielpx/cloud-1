# MARIADB

# BASE IMAGE: Debian
FROM debian:bookworm

# INSTALLATION
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install -y --no-install-recommends mariadb-server && \
	rm -rf /var/lib/apt/lists/*
	
# CONFIGURATION
COPY conf/my.cnf /etc/mysql/my.cnf

# ENTRYPOINT SCRIPT
COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

# ENTRYPOINT
ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]
CMD ["mysqld_safe", "--datadir=/var/lib/mysql", "--user=mysql"]