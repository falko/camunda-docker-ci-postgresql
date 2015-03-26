FROM camunda-ci1:5000/camunda-ci-base-centos:latest

# set environment variables for database
ENV POSTGRESQL_VERSION=9.3 \
    DB_USERNAME=camunda \
    DB_PASSWORD=camunda \
    DB_NAME=process-engine
ENV POSTGRESQL_VERSION_FULL=${POSTGRESQL_VERSION}.6 \
    PGDATA=/var/lib/pgsql/${POSTGRESQL_VERSION}/data \
    PGBIN=/usr/pgsql-${POSTGRESQL_VERSION}/bin
RUN save-env.sh POSTGRESQL_VERSION DB_USERNAME DB_PASSWORD DB_NAME
RUN add-path.sh $PGBIN

# install packages
RUN wget -P /tmp/postgresql \
      ftp://camunda-ci1/ci/binaries/postgresql/postgresql-${POSTGRESQL_VERSION_FULL}.rhel7.x86_64.rpm \
      ftp://camunda-ci1/ci/binaries/postgresql/postgresql-libs-${POSTGRESQL_VERSION_FULL}.rhel7.x86_64.rpm \
      ftp://camunda-ci1/ci/binaries/postgresql/postgresql-server-${POSTGRESQL_VERSION_FULL}.rhel7.x86_64.rpm && \
    rpm -ivh /tmp/postgresql/*.rpm && \
    rm -rf /tmp/postgresql

# init database
RUN su -p postgres -c "${PGBIN}/pg_ctl initdb -w"

# add postgresql config
ADD etc/postgresql/* ${PGDATA}/

# add postgresql user and create database
RUN chown -R postgres:postgres ${PGDATA}/* && \
    su -p postgres -c "${PGBIN}/pg_ctl start -w" && \
    su -p postgres -c "${PGBIN}/psql --command \"CREATE USER $DB_USERNAME WITH SUPERUSER PASSWORD '$DB_PASSWORD';\"" && \
    su -p postgres -c "${PGBIN}/createdb --owner=$DB_USERNAME --template=template0 --encoding=UTF8 $DB_NAME" && \
    su -p postgres -c "${PGBIN}/pg_ctl stop -w"

# add postgresql service to supervisor conifg
ADD etc/supervisor.d/postgresql.conf.ini /etc/supervisord.d/postgresql.conf.ini

# add database_ready script
ADD bin/database_ready /usr/local/bin/database_ready

# expose postgresql port
EXPOSE 5432
