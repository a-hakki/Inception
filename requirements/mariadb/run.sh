#!/bin/bash
set -e

unset MYSQL_HOST

chown -R mysql:mysql /var/lib/mysql

# Check for the core system tables
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First run detected. Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Starting temporary server for configuration..."
    mariadbd-safe &
    MARIADB_PID=$!

    while ! mysqladmin ping --silent; do
        sleep 1
    done

    echo "Configuring database and users..."
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    echo "Configuration complete. Shutting down temporary server..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $MARIADB_PID
fi

echo "Starting MariaDB in the foreground..."
exec mariadbd-safe