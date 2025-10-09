#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Wait for MariaDB to be ready
sleep 10

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up WordPress..."
    
    # Validate secrets exist
    for s in mariadb_password wp_admin_password wp_user_password; do
        [ -s "/run/secrets/$s" ] || { echo "Missing secret: $s" >&2; exit 1; }
    done

    # Validate environment variables exist
    for v in MARIADB_DATABASE MARIADB_USER MYSQL_HOST DOMAIN_NAME WP_TITLE WP_ADMIN_USER WP_ADMIN_EMAIL WP_USER WP_USER_EMAIL; do
        [ -n "${!v}" ] || { echo "Missing env var: $v" >&2; exit 1; }
    done
    
    # Download WordPress
    wp core download --allow-root --path=/var/www/html
    
    # Create wp-config.php
    wp config create \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="$(cat /run/secrets/mariadb_password)" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root \
        --path=/var/www/html
    
    # Install WordPress
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/wp_admin_password)" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root \
        --path=/var/www/html
    
    # Create additional user
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="$(cat /run/secrets/wp_user_password)" \
        --role=author \
        --allow-root \
        --path=/var/www/html
    
    echo "WordPress setup complete!"
fi

# Start PHP-FPM in foreground
exec php-fpm7.4 -F
