### Run

```bash
./run.sh
```

```
❯ ./run.sh
390dd6353948bbe47357665f71374a64c7218fa279f27f0aab6789ae213f6bbc
❯ docker ps
CONTAINER ID   IMAGE                                              COMMAND                  CREATED         STATUS         PORTS      NAMES
390dd6353948   registry.gitlab.com/dalibo/postgresql_anonymizer   "docker-entrypoint.s…"   2 seconds ago   Up 2 seconds   5432/tcp   anon_quickstart
```

### Create DB with anon extension

```bash
./create-db.sh
```

```
❯ ./create-db.sh
CREATE DATABASE
You are now connected to database "demo" as user "postgres".
CREATE TABLE
INSERT 0 1
NOTICE:  extension "anon" already exists, skipping
CREATE EXTENSION
ALTER DATABASE
DO
SECURITY LABEL
GRANT ROLE
SECURITY LABEL
SECURITY LABEL
```

### Do a SAFE query

```bash
❯ ./run-query.sh
You are now connected to database "demo" as user "skynet".
ERROR:  operator does not exist: integer ****** integer
HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.
```