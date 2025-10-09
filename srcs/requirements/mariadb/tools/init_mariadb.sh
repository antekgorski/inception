#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Start MySQL service temporarily for initialization
service mariadb start

# Wait for MariaDB to be ready
sleep 5

# Create database and user if they don't exist
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Stop the temporary MySQL service
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MariaDB in foreground with network access
exec mysqld --bind-address=0.0.0.0 --port=3306
