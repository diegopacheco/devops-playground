#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DB_DIR="$SCRIPT_DIR/mydb"

rm -rf "$DB_DIR"
mkdir -p "$DB_DIR"
cd "$DB_DIR"

dolt init
dolt config --local --add user.email "diegopacheco@gmail.com"
dolt config --local --add user.name "Diego Pacheco"

dolt sql -q "create table employees (id int primary key, first_name varchar(255), last_name varchar(255), role varchar(255));"
dolt sql -q "insert into employees values (1, 'Diego', 'Pacheco', 'Engineer');"
dolt sql -q "insert into employees values (2, 'John', 'Doe', 'Manager');"
dolt sql -q "insert into employees values (3, 'Jane', 'Smith', 'Designer');"
dolt add .
dolt commit -m "Initial schema and data"

echo ""
echo "=== All Employees ==="
dolt sql -q "select * from employees;"

echo ""
echo "=== Creating branch and making changes ==="
dolt checkout -b feature-branch
dolt sql -q "insert into employees values (4, 'Bob', 'Jones', 'DevOps');"
dolt sql -q "update employees set role='Senior Engineer' where id=1;"
dolt add .
dolt commit -m "Added Bob and promoted Diego"

echo ""
echo "=== Diff between main and feature-branch ==="
dolt diff main feature-branch

echo ""
echo "=== Merging feature-branch into main ==="
dolt checkout main
dolt merge feature-branch
dolt commit -m "Merged feature-branch"

echo ""
echo "=== Final Employees ==="
dolt sql -q "select * from employees;"

echo ""
echo "=== Commit Log ==="
dolt log

echo ""
echo "=== History for Diego (id=1) ==="
dolt sql -q "select * from dolt_history_employees where id=1 order by commit_date;"

echo ""
echo "=== Done ==="
