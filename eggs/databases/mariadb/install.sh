#!/bin/bash
# MariaDB Installation Script
#
# Server Files: /mnt/server
set -x

echo -e "installing dependencies"
apt-get -y update
apt-get -y install curl

## add user
echo -e "adding container user"
useradd -d /home/container -m container -s /bin/bash

## own server to container user
chown container: /mnt/server/

## run install script as user
echo -e "getting my.conf"
if [ -f /mnt/server/.my.cnf ]; then
    echo -e "moving current config for install"
    mv /mnt/server/.my.cnf /mnt/server/custom.my.cnf
    runuser -l container -c 'curl https://raw.githubusercontent.com/parkervcp/eggs/master/database/sql/mariadb/install.my.cnf > /mnt/server/.my.cnf'
else
    runuser -l container -c 'curl https://raw.githubusercontent.com/parkervcp/eggs/master/database/sql/mariadb/install.my.cnf > /mnt/server/.my.cnf'
fi

## mkdir and install db
echo -e "installing mysql database"
runuser -l container -c 'mkdir -p /mnt/server/run/mysqld'
runuser -l container -c 'mkdir -p /mnt/server/log/mysql'
runuser -l container -c 'mkdir /mnt/server/mysql'

runuser -l container -c 'mysql_install_db --defaults-file=/mnt/server/.my.cnf'

if [ -f /mnt/server/custom.my.cnf ]; then
    echo -e "moving current config back in place"
    mv /mnt/server/custom.my.cnf /mnt/server/.my.cnf
else
    curl https://raw.githubusercontent.com/parkervcp/eggs/master/database/sql/mariadb/my.cnf > /mnt/server/.my.cnf
fi

echo -e "install complete"
exit
