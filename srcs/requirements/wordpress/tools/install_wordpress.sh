#!/bin/bash

set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"mariadb" --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is up!"

# Download WP-CLI if not already installed
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Change to WordPress directory
cd /var/www/html

# Download WordPress if not already downloaded
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root
    
    echo "WordPress installed successfully!"
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
