FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy initialization script
COPY init_mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_mariadb.sh

# Expose MariaDB port
EXPOSE 3306

# Run initialization script
ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]