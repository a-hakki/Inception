#!/bin/bash
set -e

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Configuring WordPress..."

    # Wait until MariaDB network is reachable
    echo "Waiting for database connection..."
    while ! mysqladmin ping -h "$MYSQL_HOST" --silent; do
        sleep 2
    done
    echo "Database is online!"

    wp core download --allow-root

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    echo "WordPress is configured!"
fi

chown -R www-data:www-data /var/www/html

exec "$@"