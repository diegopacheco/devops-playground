### Run
```
./run-mysql-container.sh
```

### Partition Options

**RANGE Partitioning**: This partitions data based on a specified range. It is useful when you want to partition data into groups based on specific intervals of a column's values, such as date ranges or numeric intervals.

**LIST Partitioning**: Similar to RANGE partitioning, but instead of ranges, specific values are used to define partitions. It's useful for categorizing rows into partitions where each partition is defined by one or more specific values.

**COLUMNS Partitioning**: This is an extension of RANGE and LIST partitioning that allows partitioning based on multiple columns. It's useful when partitioning needs to be done based on a combination of column values.

**LINEAR HASH and LINEAR KEY Partitioning**: These are variations of HASH and KEY partitioning that distribute rows using a linear hashing algorithm. They are designed to spread data more evenly across partitions.


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

Does not use parition - use indexing.
```
mysql> CREATE TABLE IF NOT EXISTS person (
    ->     id INT AUTO_INCREMENT,
    ->     first_name VARCHAR(255) NOT NULL,
    ->     last_name VARCHAR(255) NOT NULL,
    ->     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     created_year INT,
    ->     PRIMARY KEY(id),
    ->     UNIQUE KEY unique_name(first_name, last_name),
    ->     KEY(created_year)
    -> );
Query OK, 0 rows affected (0,04 sec)

mysql> 
```