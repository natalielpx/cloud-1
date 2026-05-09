# MARIADB

# BASE IMAGE: Debian
FROM debian:bookworm-slim

# INSTALLATION
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
	mariadb-server \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
	
# CONFIGURATION
COPY conf/my.cnf /etc/mysql/my.cnf

# ENTRYPOINT SCRIPT
COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

# ENTRYPOINT
ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]
CMD ["mariadbd-safe", "--datadir=/var/lib/mysql", "--user=mysql"]