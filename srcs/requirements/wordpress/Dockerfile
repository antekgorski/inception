FROM debian:bullseye

RUN mkdir -p /run/php && chown www-data:www-data /run/php
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
    wget \
    mariadb-client \
    sudo \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM configuration and remove default
COPY wp.conf /etc/php/7.4/fpm/pool.d/wp.conf
RUN rm -f /etc/php/7.4/fpm/pool.d/www.conf

# Copy and set permissions for setup script
COPY tools/wordpress-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-setup.sh

# Create working directory
WORKDIR /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Run setup script and PHP-FPM
ENTRYPOINT ["/usr/local/bin/wordpress-setup.sh"]
CMD ["php-fpm7.4", "-F"]