# Run Dolt Commands

```bash
mkdir -p mydb && cd mydb
dolt init
dolt config --local --add user.email "diegopacheco@gmail.com"
dolt config --local --add user.name "Diego Pacheco"
```

```bash
dolt sql -q "create table employees (id int primary key, first_name varchar(255), last_name varchar(255), role varchar(255));"
dolt sql -q "insert into employees values (1, 'Diego', 'Pacheco', 'Engineer');"
dolt sql -q "insert into employees values (2, 'John', 'Doe', 'Manager');"
dolt sql -q "insert into employees values (3, 'Jane', 'Smith', 'Designer');"
dolt add .
dolt commit -m "Initial schema and data"
```

```bash
dolt sql -q "select * from employees;"
dolt log
dolt status
dolt diff
```

```bash
dolt checkout -b feature-branch
dolt sql -q "insert into employees values (4, 'Bob', 'Jones', 'DevOps');"
dolt sql -q "update employees set role='Senior Engineer' where id=1;"
dolt add .
dolt commit -m "Added Bob and promoted Diego"
```

```bash
dolt diff main feature-branch
dolt checkout main
dolt merge feature-branch
dolt commit -m "Merged feature-branch"
```

```bash
dolt log
dolt sql -q "select * from employees;"
dolt sql -q "select * from dolt_log;"
dolt sql -q "select * from dolt_diff_employees;"
dolt sql -q "select * from dolt_history_employees where id=1 order by commit_date;"
```
