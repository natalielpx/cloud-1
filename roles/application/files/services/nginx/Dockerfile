# NGINX

# BASE IMAGE: Debian
FROM debian:bookworm

# ALLOW HTTPS TRAFFIC
# EXPOSE 443

# INSTALLATION
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install -y --no-install-recommends nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# CONFIGURATION
COPY conf/cloud-1.conf /etc/nginx/conf.d/cloud-1.conf
# RUN sed -i 's|include /etc/nginx/sites-enabled/*;||g' /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*

# ENTRYPOINT
ENTRYPOINT ["nginx", "-g"]
CMD ["daemon off;"]