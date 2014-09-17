camunda-docker-ci-postgresql
============================

PostgreSQL docker image for Jenkins CI builds base on [camunda-docker-ci-base][].

# Additional Packages

  - postgresql server 9.3

# PostgresSQL User

  - `postgres` without password
  - `camunda` with password `camunda`

# Database

  - `process-engine`

# Usage (local)

```
# Start docker container
docker run -d -P 5432:5432 camunda/camunda-docker-ci-postgresql
```

[camunda-docker-ci-base]: https://github.com/camunda-ci/camunda-docker-ci-base
