#!/bin/bash

docker run --rm -d -e MYSQL_ROOT_PASSWORD=pass -p 3325:3306 --name mysql_test mysql:5.7
echo "Connect to mysql client: "
echo "mysql -uroot -ppass -h127.0.0.1 -P3325"

sleep 15
echo "Creating person db... "
echo "CREATE DATABASE person;" | mysql -uroot -ppass -h127.0.0.1 -P3325

sleep 3
echo "Creating person table with indexing... "
echo "use person; CREATE TABLE IF NOT EXISTS person (
      id INT,
      first_name VARCHAR(255) NOT NULL,
      last_name VARCHAR(255) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      created_year INT,
      PRIMARY KEY(first_name,last_name)
    ) PARTITION BY KEY() 
    PARTITIONS 10;" | mysql -uroot -ppass -h127.0.0.1 -P3325

sleep 3
echo "use person; select * from  person" | mysql -uroot -ppass -h127.0.0.1 -P3325

echo "Inserting data into person table... "
echo "use person; insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202406);" | mysql -uroot -ppass -h127.0.0.1 -P3325
echo "use person; insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202406);" | mysql -uroot -ppass -h127.0.0.1 -P3325
echo "use person; insert into person (first_name,last_name,created_year) values ('Diego','Pacheco',202407);" | mysql -uroot -ppass -h127.0.0.1 -P3325

echo "use person; select * from  person" | mysql -uroot -ppass -h127.0.0.1 -P3325

echo "use person; SHOW CREATE TABLE person;" | mysql -uroot -ppass -h127.0.0.1 -P3325

echo "use person; EXPLAIN select * from person;" | mysql -uroot -ppass -h127.0.0.1 -P3325

echo "DONE."