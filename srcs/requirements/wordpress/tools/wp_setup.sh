#!/bin/bash

cd /var/www/html

if [ -f "/run/secrets/wp_admin_password" ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
fi

if [ -f "/run/secrets/wp_user_password" ]; then
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
fi

if [ -f "/run/secrets/db_password" ]; then
    SQL_PASSWORD=$(cat /run/secrets/db_password)
fi

echo "Checking MariaDB connection..."
while ! mariadb-admin ping -h mariadb --user=$SQL_USER --password="$SQL_PASSWORD" --silent; do
    echo "MariaDB is not ready yet... waiting 2 seconds."
    sleep 2
done

echo "MariaDB is UP and running! Moving to WordPress setup..."

if [ ! -f wp-login.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=$SQL_HOST
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email=$WP_ADMIN_EMAIL

    echo "Creating second user..."
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
    echo "Configuring Redis Object Cache..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    
    wp plugin install redis-cache --activate --allow-root
    
    wp redis enable --allow-root
fi

echo "Applying clean permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "WordPress setup completed successfully!"

exec /usr/sbin/php-fpm7.4 -F