### Run

```bash
./run.sh
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

Do a query

```bash
❯ ./run-query.sh
You are now connected to database "demo" as user "skynet".
ERROR:  operator does not exist: integer ****** integer
HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.
```