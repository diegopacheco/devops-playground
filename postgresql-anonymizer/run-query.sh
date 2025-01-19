#!/bin/bash

docker exec -i anon_quickstart psql -U postgres <<EOF
\connect demo
SELECT * FROM people;

\connect - skynet
SELECT * FROM people;
EOF