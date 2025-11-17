#!/bin/bash
set -e

export PATH="$PATH:$HOME/go/bin"

if ! command -v regresql &> /dev/null; then
    echo "Installing regresql..."
    go install github.com/dimitri/regresql@latest
fi

PG15_CONN="postgres://testuser:testpass@localhost:5432/testdb?sslmode=disable"
PG17_CONN="postgres://testuser:testpass@localhost:5433/testdb?sslmode=disable"

echo "=== Running RegreSQL Tests on PostgreSQL 15 ==="
echo "Initializing plans for PostgreSQL 15..."
regresql init -C queries "$PG15_CONN"

echo "Updating expected results for PostgreSQL 15..."
regresql update -C queries "$PG15_CONN"

echo "Running regression tests on PostgreSQL 15..."
regresql test -C queries "$PG15_CONN"

echo ""
echo "=== Running RegreSQL Tests on PostgreSQL 17 ==="
echo "Running regression tests on PostgreSQL 17..."
regresql test -C queries "$PG17_CONN"

echo ""
echo "=== All regression tests passed on both PostgreSQL 15 and 17 ==="
