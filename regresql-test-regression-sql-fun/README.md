# Regresql - PostgreSQL Query Regression

## Start 

```bash
./start.sh
```
Result:
```
❯ ./start.sh
WARN[0000] /Users/diegopacheco/git/diegopacheco/devops-playground/regresql-test-regression-sql-fun/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
[+] Running 3/3
 ✔ Network regresql-test-regression-sql-fun_default  Cr...                                                    0.0s
 ✔ Container postgres17                              Healthy                                                  3.2s
 ✔ Container postgres15                              Healthy                                                  3.2s
Loading schema into PostgreSQL 15...
CREATE TABLE
CREATE TABLE
INSERT 0 5
INSERT 0 8
Loading schema into PostgreSQL 17...
CREATE TABLE
CREATE TABLE
INSERT 0 5
INSERT 0 8
Both databases are ready with test data
```

## Test Regressions

```bash
./run.sh
```
Result:
```
❯ ./run.sh
=== Running RegreSQL Tests on PostgreSQL 15 ===
Initializing plans for PostgreSQL 15...
Connecting to 'postgres://testuser:testpass@localhost:5432/testdb?sslmode=disable'… ✓
Directory 'queries/regresql' already exists
Creating configuration file 'queries/regresql/regress.yaml'
Skipping Plan 'queries/regresql/plans/count_users.yaml': query uses no variable
Skipping Plan 'queries/regresql/plans/get_all_orders.yaml': query uses no variable
Skipping Plan 'queries/regresql/plans/get_all_users.yaml': query uses no variable
Skipping Plan 'queries/regresql/plans/get_order_statistics.yaml': query uses no variable
Skipping: Plan file 'queries/regresql/plans/get_orders_by_status.yaml' already exists
Skipping: Plan file 'queries/regresql/plans/get_user_by_id.yaml' already exists
Skipping Plan 'queries/regresql/plans/get_user_total_spent.yaml': query uses no variable

Added the following queries to the RegreSQL Test Suite:
queries
  ./
    count_users.sql
    get_all_orders.sql
    get_all_users.sql
    get_order_statistics.sql
    get_orders_by_status.sql
    get_user_by_id.sql
    get_user_total_spent.sql

Empty test plans have been created in 'queries/regresql/plans'.\n
Edit the plans to add query binding values, then run\n
\n
  regresql update\n
\n
to create the expected regression files for your test plans. Plans are\n
simple YAML files containing multiple set of query parameter bindings. The\n
default plan files contain a single entry named "1", you can rename the test\n
case and add a value for each parameter.\n Updating expected results for PostgreSQL 15...
Connecting to 'postgres://testuser:testpass@localhost:5432/testdb?sslmode=disable'… ✓
Writing expected Result Sets:
  queries/regresql/expected
    count_users.out
    get_all_orders.out
    get_all_users.out
    get_order_statistics.out
    get_orders_by_status.1.out
    get_user_by_id.1.out
    get_user_total_spent.out

Expected files have now been created.
You can run regression tests for your SQL queries with the command

  regresql test

When you add new queries to your code repository, run 'regresql plan' to
create the missing test plans, edit them to add test parameters, and then
run 'regresql update' to have expected data files to test against.

If you change the expected result set (because picking a new data set or
because new requirements impacts the result of existing queries, you can run
the regresql update command again to reset the expected output files.

Running regression tests on PostgreSQL 15...
Connecting to 'postgres://testuser:testpass@localhost:5432/testdb?sslmode=disable'… ✓
TAP version 13
ok 1 - count_users.out
ok 2 - get_all_orders.out
ok 3 - get_all_users.out
ok 4 - get_order_statistics.out
ok 5 - get_orders_by_status.1.out
ok 6 - get_user_by_id.1.out
ok 7 - get_user_total_spent.out

=== Running RegreSQL Tests on PostgreSQL 17 ===
Running regression tests on PostgreSQL 17...
Connecting to 'postgres://testuser:testpass@localhost:5432/testdb?sslmode=disable'… ✓
TAP version 13
ok 1 - count_users.out
ok 2 - get_all_orders.out
ok 3 - get_all_users.out
ok 4 - get_order_statistics.out
ok 5 - get_orders_by_status.1.out
ok 6 - get_user_by_id.1.out
ok 7 - get_user_total_spent.out

=== All regression tests passed on both PostgreSQL 15 and 17 ===
```