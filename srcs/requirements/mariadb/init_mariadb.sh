#!/bin/bash
set -e

# Get passwords from secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialize if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Check if database configuration is needed
DB_EXISTS=$([ -d "/var/lib/mysql/$MYSQL_DATABASE" ] && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "no" ] || [ ! -f "/var/lib/mysql/.user_created" ]; then
    echo "Setting up database and user..."
    
    # Start temp server to create database and user
    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    
    # Wait for start
    while ! mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do sleep 1; done
    
    # Create database and user
    mysql --socket=/run/mysqld/mysqld.sock -u ${MYSQL_ROOT_USER:-root} << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER '${MYSQL_ROOT_USER:-root}'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
    
    mysqladmin --socket=/run/mysqld/mysqld.sock -u ${MYSQL_ROOT_USER:-root} -p$ROOT_PASSWORD shutdown
    touch /var/lib/mysql/.user_created
    echo "Database and user setup completed successfully."
else
    echo "Database and user already configured. Skipping setup."
fi

echo "Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0