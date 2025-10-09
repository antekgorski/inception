#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Initialize MariaDB if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temporary server
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    
    echo "Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping --silent; then
            echo "MariaDB is up!"
            break
        fi
        sleep 1
    done

    # Validate secrets exist
    for s in mariadb_root_password mariadb_password; do
        [ -s "/run/secrets/$s" ] || { echo "Missing secret: $s" >&2; exit 1; }
    done

    # Validate environment variables exist
    for v in MARIADB_DATABASE MARIADB_USER; do
        [ -n "${!v}" ] || { echo "Missing env var: $v" >&2; exit 1; }
    done

    echo "Configuring database and user..."
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`;
        CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/mariadb_password)';
        GRANT ALL PRIVILEGES ON \`$MARIADB_DATABASE\`.* TO '$MARIADB_USER'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/mariadb_root_password)';
        FLUSH PRIVILEGES;
EOSQL

    echo "Shutting down temporary MariaDB..."
    mysqladmin -u root --password="$(cat /run/secrets/mariadb_root_password)" shutdown

    echo "MariaDB initialized successfully!"
fi

# Start MariaDB normally
echo "Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0
