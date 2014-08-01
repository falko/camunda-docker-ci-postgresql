#!/bin/bash

USERNAME=${1:-camunda}
PASSWORD=${2:-$USERNAME}
DATABASE=${3:-process-engine}

BIN=/usr/lib/postgresql/9.3/bin/postgres
CONF=/etc/postgresql/9.3/main/postgresql.conf
HBA=/etc/postgresql/9.3/main/pg_hba.conf

# listen on all interfaces
sed -i -e "s/.*listen_addresses.*/listen_addresses = '*'/g" $CONF

# allow from everywhere
echo -e "host\tall\tall\t0.0.0.0/0\tmd5" >> $HBA

# start postgresql
service postgresql start

# create database user
sudo -u postgres psql --command "CREATE USER $USERNAME WITH SUPERUSER PASSWORD '$PASSWORD';"
# create database
sudo -u postgres createdb --owner=$USERNAME --template=template0 --encoding=UTF8 $DATABASE
