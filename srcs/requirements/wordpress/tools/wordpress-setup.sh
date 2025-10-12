#!/bin/bash
set -e

# Get passwords from secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# Wait for database
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$MYSQL_USER" -p"$DB_PASSWORD" --silent; do
    sleep 2
done

cd /var/www/html

# Setup WordPress if not exists
if [ ! -f wp-config.php ]; then
    echo "WordPress not configured. Setting up..."
    
    # Download WordPress only if not already present
    if [ ! -f wp-load.php ]; then
        echo "Downloading WordPress..."
        wp core download --allow-root
    else
        echo "WordPress files already present."
    fi
    
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$DB_PASSWORD" --dbhost="$WORDPRESS_DB_HOST" --allow-root
    wp core install --url="https://$DOMAIN_NAME" --title="Inception" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WORDPRESS_ADMIN_EMAIL" --allow-root
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --role=author --allow-root
    echo "WordPress setup completed!"
else
    echo "WordPress already configured. Skipping setup."
fi

chown -R www-data:www-data /var/www/html
exec php-fpm7.4 -F