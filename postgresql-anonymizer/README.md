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
SELECT 1
INSERT 0 1
ALTER DATABASE
CREATE ROLE
SECURITY LABEL
GRANT ROLE
SECURITY LABEL
SECURITY LABEL
```

### Do a SAFE query

```bash
./run-query.sh
```

```bash
❯ ./run-query.sh
You are now connected to database "demo" as user "postgres".
   id   | firstname | lastname |   phone
--------+-----------+----------+------------
 153478 | Sarah     | Conor    | 0609110911
(1 row)

You are now connected to database "demo" as user "skynet".
   id   | firstname | lastname | phone
--------+-----------+----------+-------
 153478 | Sarah     | Marks    |
(1 row)
```