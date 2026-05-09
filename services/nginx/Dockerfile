# NGINX

# BASE IMAGE: Debian
FROM debian:bookworm

# INSTALLATION
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
	nginx \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# CONFIGURATION
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# ENTRYPOINT
ENTRYPOINT ["nginx", "-g"]
CMD ["daemon off;"]