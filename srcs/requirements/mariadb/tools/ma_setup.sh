#!/bin/bash

if [ -f "/run/secrets/db_root_password" ]; then
    SQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ -f "/run/secrets/db_password" ]; then
    SQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then 
    echo "Initializing MariaDB system folders..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi


mysqld_safe --skip-networking &
pid="$!"


for i in {1..30}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    echo "Waiting for MariaDB daemon..."
    sleep 1
done

if mysql -u root -e "EXIT" &>/dev/null; then
    MYSQL_CMD="mysql -u root"
else
    MYSQL_CMD="mysql -u root -p${SQL_ROOT_PASSWORD}"
fi

echo "Configuring database privileges..."
$MYSQL_CMD <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "Stopping temporary setup daemon..."
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "MariaDB system structural setup is ready! Booting PID 1..."

exec mysqld_safe --datadir=/var/lib/mysql
