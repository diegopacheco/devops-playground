#!/bin/bash

# Create the database if it doesn't exist
docker exec -i anon_quickstart psql -U postgres -c "CREATE DATABASE demo;"

# Connect to the demo database and set it up
docker exec -i anon_quickstart psql -U postgres <<EOF
\connect demo

CREATE TABLE IF NOT EXISTS people AS
    SELECT  153478       AS id,
            'Sarah'      AS firstname,
            'Conor'      AS lastname,
            '0609110911' AS phone
;

INSERT INTO people (id, firstname, lastname, phone) VALUES
    (153478, 'Sarah', 'Conor', '0609110911'::text);

ALTER DATABASE demo SET anon.transparent_dynamic_masking TO true;

CREATE ROLE skynet LOGIN;
SECURITY LABEL FOR anon ON ROLE skynet IS 'MASKED';
GRANT pg_read_all_data to skynet;

SECURITY LABEL FOR anon ON COLUMN people.lastname
  IS 'MASKED WITH FUNCTION anon.dummy_last_name()';

SECURITY LABEL FOR anon ON COLUMN people.phone
  IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$******$$,2)';

ALTER TABLE people ALTER COLUMN phone TYPE text USING phone::text;

SECURITY LABEL FOR anon ON COLUMN people.phone
  IS 'MASKED WITH FUNCTION anon.partial(phone::text,2,$$******$$,2)';
EOF