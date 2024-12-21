DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'marquez') THEN
    CREATE ROLE marquez WITH LOGIN PASSWORD 'marquez';
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT datname
    FROM pg_database
    WHERE datname = 'marquez_db'
  ) THEN
    CREATE DATABASE marquez_db WITH OWNER marquez;
  END IF;
END
$$;
