#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Wait for MariaDB to be ready
sleep 10

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up WordPress..."
    
    # Download WordPress
    wp core download --allow-root --path=/var/www/html
    
    # Create wp-config.php
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root \
        --path=/var/www/html
    
    # Install WordPress
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root \
        --path=/var/www/html
    
    # Create additional user
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root \
        --path=/var/www/html
    
    echo "WordPress setup complete!"
fi

# Start PHP-FPM in foreground
exec php-fpm7.4 -F
