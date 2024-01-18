echo "create database sql_playground;" | mysql -uroot -ppass -h127.0.0.1 -P3325

cat ./schema.sql | mysql -uroot -ppass -h127.0.0.1 -P3325
cat ./data.sql | mysql -uroot -ppass -h127.0.0.1 -P3325
