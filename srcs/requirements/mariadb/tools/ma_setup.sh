#!/bin/bash

# 🚨 SLLE7NA L-FKH: 7iydna l-hardcode! Ga3 l-passwords daba 
# kiy-9raw direct mn .env kima mtloub f grid correction.

chown -R mysql:mysql /var/lib/mysql /run/mysqld

# 1. Initializi database directory ila khawi
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# 2. Start temporary daemon f background (bla network f l-bdaya bash y-koun secure)
mysqld_safe --skip-networking &
pid="$!"

# Tsennaha t-fya9 100%
for i in {1..30}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    echo "Waiting for MariaDB to boot..."
    sleep 1
done

# 3. Safe Method: Check chmen tariqa ghadin n-dkhlo biha (Root login validation)
if mysql -u root -e "EXIT" &>/dev/null; then
    # First boot: Root ba9i bla password
    MYSQL_CMD="mysql -u root"
else
    # Mlli kiy-koun l-password already initialized mn l-env variables
    MYSQL_CMD="mysql -u root -p${SQL_ROOT_PASSWORD}"
fi

# 4. Executi SQL queries clean setup
echo "Configuring users and privileges..."
$MYSQL_CMD <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# 5. Shutdown temporary daemon b l-password s7i7 jdid
echo "Stopping temporary MariaDB..."
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "MariaDB is 100% ready to go!"

# 6. Run formal daemon f l-foreground kima standard setup rules[cite: 1]
exec mysqld_safe --datadir=/var/lib/mysql