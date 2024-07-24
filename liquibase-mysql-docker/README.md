### Result

```
❯ ./run.sh
[+] Running 2/0
 ✔ Container liquibase-mysql-docker-mysql-1      Created                                                                                                0.0s 
 ✔ Container liquibase-mysql-docker-liquibase-1  Created                                                                                                0.0s 
Attaching to liquibase-1, mysql-1
mysql-1      | 2024-07-24 10:29:24+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 9.0.1-1.el9 started.
mysql-1      | 2024-07-24 10:29:25+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
mysql-1      | 2024-07-24 10:29:25+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 9.0.1-1.el9 started.
mysql-1      | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
mysql-1      | 2024-07-24T10:29:25.643284Z 0 [System] [MY-015015] [Server] MySQL Server - start.
mysql-1      | 2024-07-24T10:29:25.920066Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 9.0.1) starting as process 1
mysql-1      | 2024-07-24T10:29:25.926457Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql-1      | 2024-07-24T10:29:26.579776Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql-1      | 2024-07-24T10:29:26.823373Z 0 [System] [MY-010229] [Server] Starting XA crash recovery...
mysql-1      | 2024-07-24T10:29:26.846420Z 0 [System] [MY-010232] [Server] XA crash recovery finished.
mysql-1      | 2024-07-24T10:29:26.946079Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql-1      | 2024-07-24T10:29:26.946105Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql-1      | 2024-07-24T10:29:26.952696Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql-1      | 2024-07-24T10:29:26.977786Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
mysql-1      | 2024-07-24T10:29:26.977863Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '9.0.1'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
liquibase-1  | ####################################################
liquibase-1  | ##   _     _             _ _                      ##
liquibase-1  | ##  | |   (_)           (_) |                     ##
liquibase-1  | ##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
liquibase-1  | ##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
liquibase-1  | ##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
liquibase-1  | ##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
liquibase-1  | ##              | |                               ##
liquibase-1  | ##              |_|                               ##
liquibase-1  | ##                                                ## 
liquibase-1  | ##  Get documentation at docs.liquibase.com       ##
liquibase-1  | ##  Get certified courses at learn.liquibase.com  ## 
liquibase-1  | ##                                                ##
liquibase-1  | ####################################################
liquibase-1  | Starting Liquibase at 10:29:29 (version 4.28.0 #2272 built at 2024-05-16 19:00+0000)
liquibase-1  | Liquibase Version: 4.28.0
liquibase-1  | Liquibase Open Source 4.28.0 by Liquibase
liquibase-1  | Running Changeset: insert-products-data.sql::raw::includeAll
liquibase-1  | 
liquibase-1  | UPDATE SUMMARY
liquibase-1  | Run:                          1
liquibase-1  | Previously run:               2
liquibase-1  | Filtered out:                 0
liquibase-1  | -------------------------------
liquibase-1  | Total change sets:            3
liquibase-1  | 
liquibase-1  | Liquibase: Update has been successful. Rows affected: 7
liquibase-1  | Liquibase command 'update' was executed successfully.
liquibase-1 exited with code 0
```

### Checking the DB State

```
❯ docker exec -it f666a1f426de mysql -uroot -proot db
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 9.0.1 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use db;
Database changed
mysql> show tables;
+-----------------------+
| Tables_in_db          |
+-----------------------+
| DATABASECHANGELOG     |
| DATABASECHANGELOGLOCK |
| products              |
| users                 |
+-----------------------+
4 rows in set (0.00 sec)

mysql> select * from users;
Empty set (0.00 sec)

mysql> select * from products;
+----+------------+-------+----------+---------------------+---------------------+
| id | name       | price | quantity | created_at          | updated_at          |
+----+------------+-------+----------+---------------------+---------------------+
|  1 | Apple      |  0.99 |      100 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
|  2 | Banana     |  0.59 |      200 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
|  3 | Cherry     |  2.99 |       50 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
|  4 | Elderberry |  3.99 |       25 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
|  5 | Fig        |  1.99 |       75 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
|  6 | Grape      |  1.49 |      150 | 2024-07-24 10:29:30 | 2024-07-24 10:29:30 |
+----+------------+-------+----------+---------------------+---------------------+
6 rows in set (0.00 sec)

mysql> 
```
