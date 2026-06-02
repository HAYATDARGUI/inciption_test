#!/bin/bash

# Hardcode direct bach n-friyw l-mouchkil d sync
MYSQL_PASSWORD="password_mariadb_123"
MYSQL_ROOT_PASSWORD="password_root_123"

chown -R mysql:mysql /var/lib/mysql /run/mysqld

# 1. Initializi database directory ila khawi
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# 2. Start temporary daemon f background
mysqld_safe --skip-networking &
pid="$!"

# Tsennaha t-bda t-biyen
for i in {1..30}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    echo "Waiting for MariaDB..."
    sleep 1
done

# 3. FIX 1045: Check chmen tariqa ghadi n-dkblo biha l root (Safe Method)
if mysql -u root -e "EXIT" &>/dev/null; then
    # Ila kan root bla password (First boot)
    MYSQL_CMD="mysql -u root"
else
    # Ila root account already 3ndou password d root jdid
    MYSQL_CMD="mysql -u root -p${MYSQL_ROOT_PASSWORD}"
fi

# 4. Run commands nqiyyin setup account
echo "Configuring users and privileges..."
$MYSQL_CMD <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# 5. Shutdown temporary daemon b l-password s7i7
echo "Stopping temporary MariaDB..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "MariaDB is 100% ready!"
exec mariadbd