camunda-ci-postgresql
============================

PostgreSQL docker image for Jenkins CI builds base on [camunda-ci-base-centos][].

# Additional Packages

  - postgresql server

# PostgresSQL User

  - `postgres` without password
  - `camunda` with password `camunda`

# Database

  - `process-engine`

# Usage (local)

```
# Start docker container
docker run -d -p 5432:5432 camunda/camunda-docker-ci-postgresql
```

[camunda-ci-base-centos]: https://github.com/camunda-ci/camunda-docker-ci-base-centos
[aufs bug]: https://github.com/docker/docker/issues/783
