### Run
```
./run-mysql-container.sh
```

### Errors (invalid)

```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->           id INT AUTO_INCREMENT PRIMARY KEY,
    ->           first_name VARCHAR(255) NOT NULL,
    ->           last_name VARCHAR(255) NOT NULL,
    ->           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->           created_year int,
    ->           UNIQUE KEY (id,created_year)
    ->       ) PARTITION BY HASH(created_year);
ERROR 1503 (HY000): A PRIMARY KEY must include all columns in the table's partitioning function
```

```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->           id INT AUTO_INCREMENT,
    ->           first_name VARCHAR(255) NOT NULL,
    ->           last_name VARCHAR(255) NOT NULL,
    ->           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->           created_year int,
    ->           UNIQUE KEY (created_year),
    ->           PRIMARY KEY(id)
    ->       ) PARTITION BY HASH(created_year);
ERROR 1503 (HY000): A PRIMARY KEY must include all columns in the table's partitioning function
mysql>
```

Partition works but it breaks unique key constraint
```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->           id INT,
    ->           first_name VARCHAR(255) NOT NULL,
    ->           last_name VARCHAR(255) NOT NULL,
    ->           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->           created_year int,
    ->           PRIMARY KEY(first_name,created_year)
    ->       ) PARTITION BY HASH(created_year);
Query OK, 0 rows affected (0,03 sec)

mysql> insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202406);
Query OK, 1 row affected (0,01 sec)

mysql> insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202406);
ERROR 1062 (23000): Duplicate entry 'Diego-202406' for key 'PRIMARY'
mysql> insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202407);
Query OK, 1 row affected (0,01 sec)

mysql> select * from person;
+------+------------+-----------+---------------------+--------------+
| id   | first_name | last_name | created_at          | created_year |
+------+------------+-----------+---------------------+--------------+
| NULL | Diego      | Pacheco   | 2024-06-27 08:04:18 |       202406 |
| NULL | Diego      | Pacheco   | 2024-06-27 08:04:25 |       202407 |
+------+------------+-----------+---------------------+--------------+
2 rows in set (0,00 sec)

mysql> 

```


### Works (valid)

```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->           id INT AUTO_INCREMENT,
    ->           first_name VARCHAR(255) NOT NULL,
    ->           last_name VARCHAR(255) NOT NULL,
    ->           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->           created_year int,
    ->           PRIMARY KEY(id,created_year)
    ->       ) PARTITION BY HASH(created_year);
Query OK, 0 rows affected (0,03 sec)
mysql> 
```