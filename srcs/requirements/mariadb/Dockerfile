#base iamge lighadi n intalliwha ila 3andna m instalier jibha ila lae instaliha mn docker regestry
FROM debian:bullseye 

# Install MariaDB server: kan updatiw package list omoraha kan instaliw maiadb omoraha kanmess7o cash bach nkhaliw blassa imag sghira
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Slleh l-bind-address: Beddel 127.0.0.1 l 0.0.0.0 direkt f l-fichiy s7i7 bach ye9dar te9bel conection  mn bara container 
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
#sed -i  modifier folder in place mobachara 
#/g global replace.

# 9ad l-folder d l-socket o l-permissions / kan creaiw  wahed folder runtime file lihowa socket bach ytruna lina mariadb dialna 
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy script d l-setup
COPY tools/ma_setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]




#Debian base
#   ↓
#Install MariaDB
#  ↓
#Configure network (0.0.0.0)
#   ↓
#Prepare folders + permissions
#   ↓
#Add setup script
#   ↓
#Run script عند start

#127.0.0.1 = local only
#0.0.0.0 = accept from everywhere