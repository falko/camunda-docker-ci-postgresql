FROM camunda/camunda-docker-ci-base
MAINTAINER Sebastian Menski <sebastian.menski@camunda.com>

# add build files
ADD . /build

# install packages
RUN /build/bin/install-packages.sh postgresql

# configure postgresql
RUN /build/bin/configure-postgresql.sh camunda camunda process-engine

# add postgresql service to supervisor conifg
RUN cat /build/etc/supervisord-postgresql.conf >> /etc/supervisor/conf.d/supervisord.conf

# expose postgresql port
EXPOSE 5432
