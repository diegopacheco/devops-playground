#!/bin/bash
set -e

docker-compose up -d --wait

echo "Loading schema into PostgreSQL 15..."
podman exec -i postgres15 psql -U testuser -d testdb < schema.sql

echo "Loading schema into PostgreSQL 17..."
podman exec -i postgres17 psql -U testuser -d testdb < schema.sql

echo "Both databases are ready with test data"
