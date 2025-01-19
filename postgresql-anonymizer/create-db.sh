#!/bin/bash

docker exec -i anon_quickstart psql -U postgres -c "DROP DATABASE IF EXISTS demo;"
docker exec -i anon_quickstart psql -U postgres -c "CREATE DATABASE demo;"

docker exec -i anon_quickstart psql -U postgres <<EOF
\connect demo

-- Fully drop the anonymizer extension and table
DROP EXTENSION IF EXISTS anon CASCADE;
DROP TABLE IF EXISTS people CASCADE;

-- Recreate table with phone as TEXT
CREATE TABLE people (
  id INTEGER,
  firstname TEXT,
  lastname TEXT,
  phone TEXT
);

-- Insert data as TEXT
INSERT INTO people VALUES (153478, 'Sarah', 'Conor', '0609110911'::text);

-- Reinstall anonymizer extension
CREATE EXTENSION anon;
ALTER DATABASE demo SET anon.transparent_dynamic_masking TO true;

-- Create the masked role
DROP ROLE IF EXISTS skynet;
CREATE ROLE skynet LOGIN;
SECURITY LABEL FOR anon ON ROLE skynet IS 'MASKED';
GRANT pg_read_all_data TO skynet;

-- Masking rules
SECURITY LABEL FOR anon ON COLUMN people.lastname
  IS 'MASKED WITH FUNCTION anon.dummy_last_name()';
SECURITY LABEL FOR anon ON COLUMN people.phone
  IS 'MASKED WITH VALUE NULL';
EOF