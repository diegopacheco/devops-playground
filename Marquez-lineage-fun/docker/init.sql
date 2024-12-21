-- Create 'marquez' user
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'marquez') THEN
    CREATE ROLE marquez WITH LOGIN PASSWORD 'marquez';
  END IF;
END
$$;

-- Create 'marquez_db' database
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'marquez_db'
  ) THEN
    CREATE DATABASE marquez_db WITH OWNER marquez;
  END IF;
END
$$;

-- Create 'airflow' user
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'airflow') THEN
    CREATE ROLE airflow WITH LOGIN PASSWORD 'airflow';
  END IF;
END
$$;

-- Create 'airflow' database
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'airflow'
  ) THEN
    CREATE DATABASE airflow WITH OWNER airflow;
  END IF;
END
$$;