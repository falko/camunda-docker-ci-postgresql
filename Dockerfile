FROM camunda/camunda-ci-base-ubuntu

# set environment variables for database
ENV POSTGRESQL_VERSION=9.3 DB_USERNAME=camunda DB_PASSWORD=camunda DB_NAME=process-engine
RUN save-env.sh POSTGRESQL_VERSION DB_USERNAME DB_PASSWORD DB_NAME

# add postgresql apt repo
ADD etc/apt/postgresql.list /etc/apt/sources.list.d/
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# install packages
RUN install-packages.sh postgresql-$POSTGRESQL_VERSION

# add postgresql config
ADD etc/postgresql/* /etc/postgresql/$POSTGRESQL_VERSION/main/

# workaround for aufs bug (https://github.com/docker/docker/issues/783)
RUN mkdir /etc/ssl/private-new && \
    mv /etc/ssl/private/* /etc/ssl/private-new/ && \
    rm -rf /etc/ssl/private && \
    mv /etc/ssl/private-new /etc/ssl/private && \
    chown -R root:ssl-cert /etc/ssl/private

# add postgresql user and create database
RUN chown -R postgres:postgres /etc/postgresql/$POSTGRESQL_VERSION/main/* && \
    service postgresql start && \
    sudo -u postgres psql --command "CREATE USER $DB_USERNAME WITH SUPERUSER PASSWORD '$DB_PASSWORD';" && \
    sudo -u postgres createdb --owner=$DB_USERNAME --template=template0 --encoding=UTF8 $DB_NAME && \
    service postgresql stop

# add postgresql service to supervisor conifg
ADD etc/supervisor.d/postgresql.conf /etc/supervisor/conf.d/postgresql.conf

# expose postgresql port
EXPOSE 5432
