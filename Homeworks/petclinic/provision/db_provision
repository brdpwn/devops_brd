#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Install MySQL
apt-get update
apt-get install -y mysql-server

# Configure MySQL to accept connections from private network
sed -i "s/bind-address.*/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

# Create user and database
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'192.168.56.%';
FLUSH PRIVILEGES;
EOF

