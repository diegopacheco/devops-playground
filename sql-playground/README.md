# SQL Playground

it's a dockerized env(which also can work with podman) that has a full playground to play with sql in MySQL.

## Setting up the env

0. install depeendencies (docker, brew) and run:
```bash
./install-deps.sh
```
1. First spin up the mysql container.
```bash
./run-mysql-5.7-docker.sh
```
2. Create the DB, Schema and add some data
```bash
./create-schema-add-data.sh
```
3. Connect on the DB to test it
```bash
mysql -uroot -ppass -h127.0.0.1 -P3325
```
Run some basic queries
```sql
mysql> use sql_playground;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------------------+
| Tables_in_sql_playground |
+--------------------------+
| userprofile              |
| users                    |
+--------------------------+
2 rows in set (0,00 sec)

mysql> select * from users;
+------+-----------+----------+---------------------+----------+
| auid | username  | password | createdate          | isActive |
+------+-----------+----------+---------------------+----------+
|    1 | admin     | pswrd123 | 2024-01-18 00:00:00 |        1 |
|    2 | admin1    | pass506  | 2024-01-18 00:00:00 |        1 |
|    4 | fox12     | 45@jgo0  | 2024-01-18 00:00:00 |        1 |
|    6 | lexus1267 | 98hnfRT6 | 2024-01-18 00:00:00 |        1 |
|    1 | admin     | pswrd123 | 2024-01-18 00:00:00 |        1 |
|    2 | admin1    | pass506  | 2024-01-18 00:00:00 |        1 |
|    4 | fox12     | 45@jgo0  | 2024-01-18 00:00:00 |        1 |
|    6 | lexus1267 | 98hnfRT6 | 2024-01-18 00:00:00 |        1 |
+------+-----------+----------+---------------------+----------+
8 rows in set (0,00 sec)

mysql> select * from userprofile;
+------+------+-----------+-----------+-----------------------+--------------+
| apid | auid | firstname | lastname  | email                 | phone        |
+------+------+-----------+-----------+-----------------------+--------------+
|    1 |    1 | Jack      | Wolf      | bettestroom@gmail.com | 600075764216 |
|    2 |    3 | Tom       | Collins   | tnkc@outlook.com      | 878511311054 |
|    4 |    5 | Bill      | Fonskin   | bill_1290@gmail.com   | 450985764216 |
|    7 |    7 | Ivan      | Levchenko | ivan_new@outlook.com  | 878511311054 |
|    1 |    1 | Jack      | Wolf      | bettestroom@gmail.com | 600075764216 |
|    2 |    3 | Tom       | Collins   | tnkc@outlook.com      | 878511311054 |
|    4 |    5 | Bill      | Fonskin   | bill_1290@gmail.com   | 450985764216 |
|    7 |    7 | Ivan      | Levchenko | ivan_new@outlook.com  | 878511311054 |
+------+------+-----------+-----------+-----------------------+--------------+
8 rows in set (0,00 sec)

mysql>
```

## Play with Joins
* Inner Join
* Left Outer Join
* Right Outer Join
* Cross Join
* Full Join

INNER JOINs are used to fetch only common matching records. The INNER JOIN clause allows retrieving only those records from Table A and Table B, that meet the join condition. It is the most widely used type of JOIN.

LEFT OUTER JOINs allow retrieving all records from Table A, along with those records from Table B for which the join condition is met. For the records from Table A that do not match the condition, the NULL values are displayed.

RIGHT OUTER JOINs allow retrieving all records from Table B, along with those records from Table A for which the join condition is met. For the records from Table B that do not match the condition, the NULL values are displayed.

CROSS JOIN, also known as a cartesian join, retrieves all combinations of rows from each table. In this type of JOIN, the result set is returned by multiplying each row of table A with all rows in table B if no additional condition is introduced.

Unlike SQL Server, MySQL does not support FULL OUTER JOIN as a separate JOIN type. However, to get the results same to FULL OUTER JOIN, you can combine LEFT OUTER JOIN and RIGHT OUTER JOIN.


There is a folder `joins` with sh scripts where you can run in the console. i.e
```bash
❯ ./inner_join.sh

auid    username        password        createdate      isActive        apid    auid    firstname       lastname        email   phone
1       admin   pswrd123        2024-01-18 00:00:00     1       1       1       Jack    Wolf    bettestroom@gmail.com   600075764216
1       admin   pswrd123        2024-01-18 00:00:00     1       1       1       Jack    Wolf    bettestroom@gmail.com   600075764216
1       admin   pswrd123        2024-01-18 00:00:00     1       1       1       Jack    Wolf    bettestroom@gmail.com   600075764216
1       admin   pswrd123        2024-01-18 00:00:00     1       1       1       Jack    Wolf    bettestroom@gmail.com   600075764216
```