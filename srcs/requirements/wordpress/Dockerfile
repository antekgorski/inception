FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Create necessary directories
RUN mkdir -p /var/www/html /run/php

# Copy WordPress installation script
COPY tools/install_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install_wordpress.sh

# Expose PHP-FPM port
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Run WordPress installation script
ENTRYPOINT ["/usr/local/bin/install_wordpress.sh"]
