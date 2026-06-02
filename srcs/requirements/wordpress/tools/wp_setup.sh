#!/bin/bash

cd /var/www/html

# HARDCODE PASSWORDS DIRECT
MYSQL_USER_PASSWORD="password_mariadb_123"
WP_ADMIN_PWD="password_admin_123"
WP_USER_PWD="password_user_123"

# L-7ELL DIAL CONNECTION REFUSED: 
# Hna ghadin n-tsennaw MariaDB t-bda t-biyen f network d-shiy 100%
echo "Checking MariaDB connection..."
while ! mariadb-admin ping -h mariadb --user=$MYSQL_USER --password="$MYSQL_USER_PASSWORD" --silent; do
    echo "MariaDB is not ready yet... waiting 2 seconds."
    sleep 2
done

echo "MariaDB is UP and running! Moving to WordPress setup..."

# 1. Download WordPress
if [ ! -f wp-login.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# 2. Create wp-config.php
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass="$MYSQL_USER_PASSWORD" \
        --dbhost=mariadb
fi

# 3. Run Automated Installation
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-"admin@hdargui.42.fr"}
    WP_USER_EMAIL=${WP_USER_EMAIL:-"user@hdargui.42.fr"}

    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email=$WP_ADMIN_EMAIL

    echo "Creating second user..."
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass="$WP_USER_PWD" \
        --role=author \
        --allow-root
fi

# 4. Fix permissions
echo "Applying clean permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "WordPress setup completed successfully!"

# 5. Run PHP-FPM
exec /usr/sbin/php-fpm7.4 -F