-- Create 'marquez' user if it does not exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'marquez') THEN
    CREATE ROLE marquez WITH LOGIN PASSWORD 'marquez';
  END IF;
END
$$;

-- Create 'airflow' user if it does not exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'airflow') THEN
    CREATE ROLE airflow WITH LOGIN PASSWORD 'airflow';
  END IF;
END
$$;