#!/bin/bash

set -e

# Check if MariaDB data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    
    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping --silent; then
            echo "MariaDB is up!"
            break
        fi
        sleep 1
    done
    
    # Create database and user
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    
    # Stop temporary MariaDB
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    echo "MariaDB initialized successfully!"
fi

# Start MariaDB
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
